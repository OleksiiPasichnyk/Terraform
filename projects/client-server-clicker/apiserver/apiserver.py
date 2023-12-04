from flask import Flask, request, jsonify
from flask_cors import CORS
from datetime import datetime

app = Flask(__name__)
CORS(app)  # This will enable CORS for all routes


def get_current_time():
    return datetime.now().strftime("%Y-%m-%d %H:%M:%S")


@app.route('/', methods=['POST'])
def process_request():
    data = request.json
    print(f"[{get_current_time()}] API server has Received JSON request:", data)  # Debug print for received JSON

    name = data.get('name', 'Unknown')
    profession = data.get('profession', 'profession')

    response = {"message": f"{name} is a cool {profession}"}
    print(f"[{get_current_time()}] API server is Sending JSON response:", response)  # Debug print for sent JSON

    return jsonify(response)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=7001, debug=True)
