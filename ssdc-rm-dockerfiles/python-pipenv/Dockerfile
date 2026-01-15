ARG PYTHON_TAG
FROM python:${PYTHON_TAG}

RUN apt-get update
RUN apt-get install -y --no-install-recommends build-essential gcc
RUN pip3 install --user pipenv
