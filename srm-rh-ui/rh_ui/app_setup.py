import logging
import os

from flask import Flask, g, request
from flask_babel import Babel
from flask_talisman import Talisman
from jinja2 import ChainableUndefined
from structlog import wrap_logger

from rh_ui.logger_config import logger_initial_config
from rh_ui.security import CSP, PERMISSION_POLICY


def create_app() -> Flask:
    app = Flask("RH-UI app")

    # Babel setup
    def get_locale() -> str:
        if not g.get('lang_code', None):
            g.lang_code = request.accept_languages.best_match(app.config["LANGUAGES"])
        return g.lang_code

    app.config['BABEL_TRANSLATION_DIRECTORIES'] = 'rh_ui/translations'
    Babel(app, locale_selector=get_locale)

    # App config setup
    app_config = f'config.{os.environ.get("APP_CONFIG", "BaseConfig")}'
    app.config.from_object(app_config)
    app.secret_key = app.config.get('SECRET_KEY')  # required to enable the flash function
    app.session_cookie_name = 'RH2_SESSION'  # Use a custom session cookie name to avoid ambiguity and clashes
    app.session_cookie_secure = app.config.get('SESSION_COOKIE_SECURE')
    app.jinja_env.undefined = ChainableUndefined  # This is needed to prevent jinja from throwing an error when chained parameters are undefined # noqa: E501

    # Configure logger
    logger_initial_config(log_level=app.config.get("LOGGING_LEVEL", "INFO"))
    logger = wrap_logger(logging.getLogger(__name__))
    logger.debug("App configuration set", config=app_config)

    # Register the i18n blueprint, which all internationalised routes are registered below
    from rh_ui.views.i18n import i18n
    app.register_blueprint(i18n)
    from rh_ui.views.healthcheck import healthcheck_bp
    app.register_blueprint(healthcheck_bp)
    # Register error handlers
    from rh_ui.views.error_handlers import handle_404
    app.register_error_handler(404, handle_404)
    from rh_ui.views.error_handlers import handle_500
    app.register_error_handler(500, handle_500)
    # Register security
    from rh_ui.security import security
    app.register_blueprint(security)

    Talisman(
        app,
        content_security_policy=CSP,
        content_security_policy_nonce_in=['script-src'],
        force_https=False,
        frame_options='DENY',
        strict_transport_security='includeSubDomains',
        strict_transport_security_max_age=31536000,
        x_content_type_options='nosniff',
        permissions_policy=PERMISSION_POLICY,
        session_cookie_secure=app.config["SESSION_COOKIE_SECURE"]
    )

    return app
