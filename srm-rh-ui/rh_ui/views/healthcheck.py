from flask import make_response, jsonify, Response, Blueprint

healthcheck_bp = Blueprint("healthcheck_bp", __name__)


@healthcheck_bp.route('/info/', methods=["GET"])
def info_healthcheck() -> Response:
    info = {
        'name': 'respondent-home-ui',
    }
    return make_response(jsonify(info))
