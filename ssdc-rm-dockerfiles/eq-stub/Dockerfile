FROM python:3.12.12-slim@sha256:dc9e92fcdc085ad86dda976f4cfc58856dba33a438a16db37ff00151b285c8ca

WORKDIR /app
COPY app.py app.py
COPY Pipfile* /app
EXPOSE 5000
RUN pip3 install pipenv && pipenv install --deploy --system

ENTRYPOINT ["python3"]
CMD ["app.py"]
