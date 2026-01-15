import json
from datetime import datetime, timezone
from flask import Flask, request

app = Flask(__name__)

flush_requests = []


@app.route('/flush', methods=['POST'])
def flush():
    token = request.args.get('token')
    if not token:
        return 'No token found in request', 403
    flush_requests.append({'timestamp': str(datetime.now(timezone.utc).replace(tzinfo=None)),
                           'token': token})
    return 'Successful dummy flush', 200


@app.route('/log/flush', methods=['GET'])
def get_flush_log():
    return json.dumps(flush_requests), 200


@app.route('/log/reset', methods=['GET'])
def reset():
    flush_requests.clear()
    return {}, 200


if __name__ == '__main__':
    app.run(host="0.0.0.0")
