import csv
import os
import json
import io
import boto3
import requests
from datetime import datetime, timedelta, timezone


BASE_URL = "https://api.binance.com/api/v3/"
s3: boto3.session.Session.client  = boto3.client("s3")

def iso_datetime(date, hour):
    return datetime.fromisoformat(f"{date}T{hour}:00:00").replace(tzinfo=timezone.utc)

def fetch_binance_data(endpoint, params):
    response = requests.get(f"{BASE_URL}{endpoint}", params=params, timeout=5)
    response.raise_for_status()
    return response.json()

def fetch_klines(
        symbol: str,
        start_ms: int,
        end_ms: int,
        interval: str,
)->list:
    params = {
        "symbol": symbol,
        "interval": interval,
        "startTime": start_ms,
        "endTime": end_ms
    }
    return fetch_binance_data("klines", params)


def fetch_agg_trades(
        symbol: str,
        start_ms: int,
        end_ms: int
)->list:
    params = {
        "symbol": symbol,
        "startTime": start_ms,
        "endTime": end_ms,
        "limit": 1000
    }

    results = []
    while True:
        data = fetch_binance_data("aggTrades", params)
        if not data:
            break
        results.extend(data)
        params["startTime"] = data[-1]["T"] + 1
        if len(data) < 1000:
            break
    return results

def write_to_s3(
        bucket:str,
        endpoint: str,
        symbol: str,
        data: list,
        date: str,
        hour: str
):
    buffer = io.StringIO()
    writer = csv.DictWriter(buffer, fieldnames=data[0].keys())
    writer.writeheader()
    writer.writerows(data)

    key = f"type={endpoint}/symbol={symbol}/date={date}/hour={hour}/data.csv"

    s3.put_object(
        Bucket=bucket,
        Key=key,
        Body=buffer.getvalue(),
        ContentType="application/json"
    )

    print(f"✅ Written parquet to {bucket}/{key}")


def lambda_handler(event, context):
    for record in event.get("Records", []):
        msg = json.loads(record["body"])
        date = msg.get("date")          # "2024-05-01"
        hour = msg.get("hour")          # "14"
        endpoint = msg.get("endpoint")  # "aggTrades" | "klines"
        symbol = msg.get("symbol")      # "BTCUDS"
        interval = msg.get("interval")  # "1m" => 1 minute

        if not date or not hour:
            raise ValueError("Missing 'date' or 'hour' in message")

        if endpoint == "klines":
            if not interval:
                raise ValueError("interval must be specified")

        dt = iso_datetime(date, hour)
        start_ms = int(dt.timestamp() * 1000)
        end_ms = int((dt + timedelta(hours=1)).timestamp() * 1000)

        if endpoint == "aggTrades":
            data = fetch_agg_trades(symbol, start_ms, end_ms)
        elif endpoint == "klines":
            data = fetch_klines(symbol, start_ms, end_ms, interval)
        else:
            raise ValueError(f"Unsupported type: {endpoint}")

        write_to_s3(
            bucket=os.environ["BUCKET_NAME"],
            endpoint=endpoint,
            symbol=symbol,
            data=data,
            date=date,
            hour=hour
        )
