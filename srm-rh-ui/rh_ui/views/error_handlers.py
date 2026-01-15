import logging

from flask import render_template, g, request, current_app as app
from structlog import wrap_logger

logger = wrap_logger(logging.getLogger(__name__))


def handle_404(_exception: Exception) -> tuple[str, int]:
    attempt_to_set_language()
    return render_template("error_pages/404.html"), 404


# this will also capture all unexpected errors
def handle_500(exception: Exception) -> tuple[str, int]:
    attempt_to_set_language()
    logger.exception('Handling unexpected internal error',
                     exception=exception,
                     method=request.method,
                     path=request.path)
    return render_template("error_pages/error.html"), 500


def attempt_to_set_language() -> None:
    """Try to set the language code from the request to localise the error page, otherwise default to 'en'"""
    potential_lang_code = request.path.split('/')[1]
    g.lang_code = potential_lang_code if potential_lang_code in app.config['LANGUAGES'] else 'en'
