install:
	pipenv install --dev

lint:
	pipenv run flake8

start:
	pipenv run python app.py

build:
	docker build -t europe-west2-docker.pkg.dev/ssdc-rm-ci/docker/ssdc-rm-eq-stub:latest .

eq-stub: build

docker-run:
	docker run -d --name=eq-stub -p 8918:5000 europe-west2-docker.pkg.dev/ssdc-rm-ci/docker/ssdc-rm-eq-stub:latest

down:
	docker stop eq-stub
	docker rm eq-stub
