ARG  python_pipenv_build_image=europe-west2-docker.pkg.dev/ons-ci-rm/docker/python-pipenv:3.12
FROM ${python_pipenv_build_image} as build

ENV PIPENV_VENV_IN_PROJECT=1

WORKDIR /app
COPY Pipfile* /app/

RUN /root/.local/bin/pipenv sync

FROM python:3.12.12-slim@sha256:dc9e92fcdc085ad86dda976f4cfc58856dba33a438a16db37ff00151b285c8ca

RUN groupadd -g 984 respondenthome && useradd -r -u 984 -g respondenthome respondenthome

WORKDIR /app

RUN mkdir -v /app/venv && chown respondenthome:respondenthome /app/venv

COPY --chown=respondenthome:respondenthome --from=build /app/.venv/ /app/venv/
COPY --chown=respondenthome:respondenthome . /app/

EXPOSE 9092

USER respondenthome

ENTRYPOINT ["/app/venv/bin/python"]
CMD ["/app/venv/bin/gunicorn"]