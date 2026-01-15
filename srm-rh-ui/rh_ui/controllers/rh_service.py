import hashlib

import requests
from flask import current_app
from requests import Response


def get_eq_token(uac: str, region: str) -> Response:
    uac_hash = get_sha256_hash(uac)
    response = request_eq_launch_token(uac_hash, region)
    return response


def request_eq_launch_token(uac_hash: str, region_code: str) -> Response:
    rh_svc_url_token = (f'{current_app.config.get("RH_SVC_URL")}/eqLaunch/{uac_hash}?languageCode={region_code}' +
                        f'&accountServiceUrl={current_app.config.get("ACCOUNT_SERVICE_URL")}')
    response = requests.get(rh_svc_url_token)
    return response


def get_sha256_hash(uac: str) -> str:
    return hashlib.sha256(uac.encode()).hexdigest()
