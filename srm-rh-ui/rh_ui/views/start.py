import logging
import re

from flask import Blueprint, request, flash, g, redirect, current_app, render_template
from flask.typing import ResponseReturnValue
from requests import Response, HTTPError
from structlog import wrap_logger

from rh_ui.controllers.rh_service import get_eq_token

logger = wrap_logger(logging.getLogger(__name__))

start_bp = Blueprint("start_bp", __name__, template_folder="../templates")

UAC_ERROR_PAGES = {
    'UAC_RECEIPTED': {'template': 'uac_error_pages/uac-already-used.html', 'log': 'attempt to use receipted UAC'},
    'UAC_INACTIVE': {'template': 'uac_error_pages/uac-inactive.html', 'log': 'attempt to use inactive UAC'}
}
UAC_LENGTH = 16


@start_bp.route("/start/", methods=["GET"])
def start_get() -> ResponseReturnValue:
    return render_template("start.html")


@start_bp.route("/start/", methods=["POST"])
def start_post():
    uac = request.form.get('uac').upper().replace(' ', '')
    if error := pre_check_uac(uac):
        flash(error)
        return render_template("start.html"), 401
    token_response = get_eq_token(uac, g.lang_code)

    if error_response := handle_token_error_response(token_response):
        return error_response

    return redirect(f'{current_app.config["EQ_URL"]}/session?token={token_response.text}')


def pre_check_uac(uac: str) -> str | None:
    if not uac:
        error = 'uac_empty'
        return error
    if len(uac) != 16:
        error = 'uac_invalid_length'
        return error

    uac_validation_pattern = re.compile(fr'^[A-Z0-9]{{{UAC_LENGTH}}}$')  # Outer 2 curly braces escape the f-string

    if not uac_validation_pattern.fullmatch(uac):
        error = 'uac_invalid'
        return error
    return None


def handle_token_error_response(response: Response):
    try:
        response.raise_for_status()
    except HTTPError as ex:

        # TODO: look into implementing that as a flashed message rather than a separate page
        if ex.response.status_code == 400:
            logger.warn(UAC_ERROR_PAGES[response.text]['log'])
            return render_template(UAC_ERROR_PAGES[response.text]['template'])
        elif ex.response.status_code == 302:
            return response
        elif ex.response.status_code == 404:
            flash('uac_invalid')
            logger.warn('attempt to use an invalid access code')
            return render_template("start.html"), 401
        raise ex
