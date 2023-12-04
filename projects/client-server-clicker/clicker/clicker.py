import os
import time
import requests
from bs4 import BeautifulSoup
from datetime import datetime

RETRY_ON_FAILURE_INTERVAL = 5  # Seconds to wait between retries


def get_current_time():
    return datetime.now().strftime("%Y-%m-%d %H:%M:%S")


def submit_form(url, retry_on_success_interval):
    while True:
        try:
            session = requests.Session()
            response = session.get(url)
            soup = BeautifulSoup(response.text, 'html.parser')

            payload = {
                'name': 'Alice',
                'profession': 'Doctor'
            }

            form = soup.find('form', {'id': 'form1'})
            submit_url = url + form['action']
            print(f"[{get_current_time()}] Clicking form at URL: " + submit_url)

            response = session.post(submit_url, data=payload)

            if "API Response" in response.text:
                print(f"[{get_current_time()}] API Response received:" + response.text)
            else:
                print(f"[{get_current_time()}] API Response not found")

            session.close()

            print(
                f"[{get_current_time()}] Connection to web-front at {url} succeeded. Retrying in {retry_on_success_interval} seconds...")
            time.sleep(retry_on_success_interval)

        except requests.exceptions.RequestException as e:
            print(
                f"[{get_current_time()}] Connection to web-front at {url} failed: {e}. Retrying in {RETRY_ON_FAILURE_INTERVAL} seconds...")
            time.sleep(RETRY_ON_FAILURE_INTERVAL)


def main():
    env_var_url = 'URL_TO_CLICK'
    url = os.environ.get(env_var_url)
    print(f"Got URL from {env_var_url} env variable: {url}")

    env_var_retry_on_success_interval = 'RETRY_ON_SUCCESS_INTERVAL'
    retry_on_success_interval = float(
        os.environ.get(env_var_retry_on_success_interval))  # Seconds to wait between retries
    print(f"Got Retry Interval from {env_var_retry_on_success_interval} env variable: {retry_on_success_interval}")

    submit_form(url, retry_on_success_interval)


if __name__ == '__main__':
    main()
