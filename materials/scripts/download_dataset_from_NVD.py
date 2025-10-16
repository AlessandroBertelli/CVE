#!/usr/bin/env python3
import os
import requests
import gzip
import shutil

# Target directory
TARGET_DIR = os.path.expanduser("~/Desktop/University/KTH/DATA_INTENSIVE_COMPUTING/Project/CVE/datasets/nvd")
os.makedirs(TARGET_DIR, exist_ok=True)

# Year range
START_YEAR = 2002
BASE_URL = "https://nvd.nist.gov/feeds/json/cve/2.0"
END_YEAR = 2025  # update to current year

def download_file(url, dest_path):
    print(f"Downloading {url} ...")
    headers = {"User-Agent": "Mozilla/5.0"}
    r = requests.get(url, headers=headers, stream=True)
    if r.status_code == 200:
        with open(dest_path, "wb") as f:
            for chunk in r.iter_content(chunk_size=8192):
                f.write(chunk)
        return True
    else:
        print(f"Error {r.status_code} for {url}")
        return False

def decompress_gz(gz_path, json_path):
    print(f"Decompressing {gz_path} ...")
    with gzip.open(gz_path, "rb") as f_in:
        with open(json_path, "wb") as f_out:
            shutil.copyfileobj(f_in, f_out)

if __name__ == "__main__":
    for year in range(START_YEAR, END_YEAR + 1):
        file_gz = f"nvdcve-2.0-{year}.json.gz"
        url = f"{BASE_URL}/{file_gz}"
        dest_gz = os.path.join(TARGET_DIR, file_gz)
        dest_json = dest_gz[:-3]

        if download_file(url, dest_gz):
            decompress_gz(dest_gz, dest_json)

    print(f"\nDownload completed! Files are in {TARGET_DIR}")