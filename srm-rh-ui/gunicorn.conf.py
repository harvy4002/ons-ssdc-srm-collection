import os
from datetime import datetime, timezone

"""
This is a config file Gunicorn automatically finds and runs at startup,
see https://docs.gunicorn.org/en/stable/settings.html#settings for details on the settings variables
"""

wsgi_app = 'run:app'

# Set the host and port
bind = f"{os.getenv('HOST', '0.0.0.0')}:{os.getenv('PORT', 9092)}"

worker_class = os.getenv('GUNICORN_WORKER_CLASS', 'gthread')
workers = os.getenv('GUNICORN_WORKERS', 2)
threads = os.getenv('GUNICORN_THREADS', 2)  # Threads per worker, only used by the gthread worker class

# Configure the access logs to be GCP compatible JSON structure
# Hardcode the severity to DEBUG to make it easy to filter to the access logs from other application logs
access_log_format = ('{"severity":"DEBUG", "logger":"gunicorn.access", "method":"%(m)s", "url":"%(U)s", '
                     '"remote_address":"%(h)s", "forwarded_client_ip":"%({X-Forwarded-For}i)s", "date":"%(t)s", '
                     '"status_line":"%(r)s", "status":"%(s)s", "referrer":"%(f)s", "user_agent":"%(a)s", '
                     '"process_id":"%(p)s", "request_time_ms":%(M)s}')
accesslog = '-'  # Send the access logs to stdout

# Use our custom structured logging configuration
logconfig = 'gunicorn_log.conf'

# Add a log line to the gunicorn startup stating how many workers it intends to use
print(
    f'{{"timestamp":"{datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%S")}", "severity":"NOTICE", "level":"INFO", '
    f'"service":"rh_ui", "event":"Booting gunicorn with {workers}"}}'
)
