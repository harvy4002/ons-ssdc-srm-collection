from flask import Blueprint

CSP = {
    'base-uri': [
        "'none'"
    ],
    'default-src': [
        "'self'",
        'https://cdn.ons.gov.uk',
    ],
    'font-src': [
        "'self'",
        'data:',
        'https://cdn.ons.gov.uk',
    ],
    'script-src': [
        "'strict-dynamic'",
        "'self'",
        'https://cdn.ons.gov.uk',
        'https://www.googletagmanager.com',
    ],
    'connect-src': [
        "'self'",
        'https://cdn.ons.gov.uk',
        'https://*.google-analytics.com/',
        "https://*.analytics.google.com",
        "https://*.googletagmanager.com"
    ],
    'img-src': [
        "'self'",
        'data:',
        'https://cdn.ons.gov.uk',
        "https://*.google-analytics.com",
        "https://*.googletagmanager.com"
    ],
}

PERMISSION_POLICY = ('accelerometer=(),autoplay=(),camera=(),display-capture=(),document-domain=(),'
                     'encrypted-media=(),fullscreen=(),geolocation=(),gyroscope=(),magnetometer=(),'
                     'microphone=(),midi=(),payment=(),picture-in-picture=(),publickey-credentials-get=(),'
                     'screen-wake-lock=(),sync-xhr=(self),usb=(),xr-spatial-tracking=()')

# These headers were in use on the old RH-UI but are currently not able to be set via Talisman
# and so require a different method to be set
DEFAULT_RESPONSE_HEADERS = {
    'X-Frame-Options': 'DENY',
    'X-Permitted-Cross-Domain-Policies': 'None',
    'clear-site-data': '"storage"',
    'Cross-Origin-Opener-Policy': 'same-origin',
    'Cross-Origin-Resource-Policy': 'same-site',
    'Cache-Control': ['no-store', 'max-age=0'],
    'Server': 'Office For National Statistics',
}

security = Blueprint("security", __name__)


def build_response_headers():
    headers = {}
    for header, value in DEFAULT_RESPONSE_HEADERS.items():
        if isinstance(value, dict):
            value = '; '.join([
                f"{section} {' '.join(content)}"
                for section, content in value.items()
            ])
        elif not isinstance(value, str):
            value = ' '.join(value)
        headers[header] = value
    return headers


@security.after_app_request
def add_security_headers(resp):
    '''This is required to set extra headers that Talisman doesn't support'''
    resp.headers.extend(build_response_headers())
    return resp
