import os
import json
import boto3
import requests
from datetime import datetime, timedelta, timezone

s3 = boto3.client("s3")
symbol = "BTCUSDT"

def fetch_agg_trades(symbol, start_ms, end_ms):
    url = "https://api.binance.com/api/v3/aggTrades"
    params = {
        "symbol": symbol,
        "startTime": start_ms,
        "endTime": end_ms,
        "limit": 1000
    }

    results = []
    while True:
        resp = requests.get(url, params=params, timeout=5)
        resp.raise_for_status()
        data = resp.json()
        if not data:
            break
        results.extend(data)
        last_id = data[-1]["a"]
        params["fromId"] = last_id + 1
        if len(data) < 1000:
            break
    return results

def write_to_s3(bucket, prefix, symbol, data, datetime_obj):
    timestamp_str = datetime_obj.isoformat().replace(":", "-")
    key = f"{prefix}/{symbol}/{timestamp_str}.json"

    s3.put_object(
        Bucket=bucket,
        Key=key,
        Body=json.dumps(data),
        ContentType="application/json"
    )
    print(f"✅ Wrote {len(data)} trades to s3://{bucket}/{key}")

def lambda_handler(event, context):
    for record in event.get("Records", []):
        msg = json.loads(record["body"])
        date = msg.get("date")       # "2024-05-01"
        hour = msg.get("hour")       # "14"

        if not date or not hour:
            raise ValueError("Missing 'date' or 'hour' in message")

        dt = datetime.strptime(f"{date}T{hour}:00:00Z", "%Y-%m-%dT%H:%M:%SZ").replace(tzinfo=timezone.utc)
        start_ms = int(dt.timestamp() * 1000)
        end_ms = int((dt + timedelta(hours=1)).timestamp() * 1000)

        trades = fetch_agg_trades(symbol, start_ms, end_ms)

        write_to_s3(
            bucket=os.environ["BUCKET_NAME"],
            prefix="trades",
            symbol=symbol,
            data=trades,
            datetime_obj=dt
        )
