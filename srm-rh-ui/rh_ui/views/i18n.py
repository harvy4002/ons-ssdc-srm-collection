import logging

from flask import g, Blueprint
from structlog import wrap_logger

from rh_ui.views.info_pages import info_pages_bp
from rh_ui.views.start import start_bp

logger = wrap_logger(logging.getLogger(__name__))

i18n = Blueprint("i18n", __name__, url_prefix='/<lang_code>')

# The internationalisation (i18n) blueprint handles the language code in the route, all translated routes should be
# registered underneath this blueprint, so their routes inherit the language code url prefix.
i18n.register_blueprint(start_bp)
i18n.register_blueprint(info_pages_bp)


@i18n.url_defaults
def add_language_code(_endpoint, values):
    values.setdefault('lang_code', g.lang_code)


@i18n.url_value_preprocessor
def pull_lang_code(_endpoint, values):
    g.lang_code = values.pop('lang_code')
