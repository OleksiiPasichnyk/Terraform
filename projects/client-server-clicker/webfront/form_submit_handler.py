from flask import Flask, request, render_template_string
import requests
import time
from datetime import datetime

app = Flask(__name__)

# URL of the external API
API_URL = "http://apiserver:7001"


def get_current_time():
    return datetime.now().strftime("%Y-%m-%d %H:%M:%S")


@app.route('/form_submit', methods=['POST'])
def form_submit():
    form_data = request.form
    json_data = form_data.to_dict()

    RETRY_INTERVAL = 5  # Seconds to wait between retries

    while True:
        try:
            # Send JSON data to the external API
            response = requests.post(API_URL, json=json_data)
            response_data = response.json()

            # Display the API's response
            return render_template_string("""
                <!DOCTYPE html>
                <html lang="en">
                <head>
                    <meta charset="UTF-8">
                    <title>API Response</title>
                </head>
                <body>
                    <p>API Response:</p>
                    <h1>{{ message }}</h1>
                    <p>
                        <button onclick="window.history.back();">Back to the form</button>
                    </p>
                </body>
                </html>
            """, message=response_data.get("message"))

        except requests.exceptions.RequestException as e:
            print(
                f"[{get_current_time()}] Connection to apiserver at {API_URL} failed: {e}. Retrying in {RETRY_INTERVAL} seconds...")
            time.sleep(RETRY_INTERVAL)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
