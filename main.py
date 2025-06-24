import os
import json
import boto3
import requests
from datetime import datetime

s3 = boto3.client("s3")
symbol = "BTCUSDT"


def main():
    url = f"https://api.binance.com/api/v3/depth"
    params = {"symbol": symbol, "limit": 5}

    response = requests.get(url, params=params, timeout=5)
    response.raise_for_status()
    data = response.json()
    print(data)


if __name__ == '__main__':
    main()
