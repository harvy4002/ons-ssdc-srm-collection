FROM python:3.12.12-slim@sha256:dc9e92fcdc085ad86dda976f4cfc58856dba33a438a16db37ff00151b285c8ca

RUN pip3 install pipenv
RUN apt-get update -y && apt-get install -y curl git postgresql-client
WORKDIR /app
COPY . /app
RUN pipenv install --system --deploy