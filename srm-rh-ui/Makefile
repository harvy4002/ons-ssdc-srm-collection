# Set the container runtime based on architecture, default to docker for amd64 and podman for arm64
DOCKER ?= $(shell if [ "$$(uname -m)" = "arm64" ]; then echo podman; else echo docker; fi)

load_templates:
	./load_templates.sh

install: load_templates
	pipenv install --dev

run: run_gunicorn

run_dev:
	APP_CONFIG=DevelopmentConfig pipenv run python run.py

run_gunicorn:
	pipenv run gunicorn

flake:
	pipenv run flake8 --exclude=whitelist.py

vulture:
	pipenv run vulture .

update_vulture_whitelist:
	pipenv run vulture . --make-whitelist > whitelist.py || true

lint: flake vulture

unit_test: lint
	APP_CONFIG=TestingConfig pipenv run pytest tests/unit --cov rh_ui --cov-report html --cov-report term-missing --cov-fail-under 80

test: install unit_test integration_test

build: test docker_build

build-no-test: install docker_build

docker_build:
	$(DOCKER) build --platform linux/amd64 -t europe-west2-docker.pkg.dev/ssdc-rm-ci/docker/srm-rh-ui .

docker_run:
	$(DOCKER) run -p 9093:9092 --network=ssdcrmdockerdev_default -e APP_CONFIG=DevelopmentConfig -e RH_SVC_URL=http://rh-service:8071/ --name srm-rh-ui europe-west2-docker.pkg.dev/ssdc-rm-ci/docker/srm-rh-ui

docker_stop:
	$(DOCKER) stop srm-rh-ui
	$(DOCKER) rm srm-rh-ui

extract_translation:
	pipenv run pybabel extract -F babel.cfg -o rh_ui/translations/messages.pot .

update_welsh_translation_file:
	pipenv run pybabel init -i rh_ui/translations/messages.pot -d rh_ui/translations -l cy

compile_translations:
	pipenv run pybabel compile -d rh_ui/translations

translate:
	pipenv run pybabel extract -F babel.cfg -o rh_ui/translations/messages.pot . 		# update the .pot files basing on templates
	pipenv run pybabel update -i rh_ui/translations/messages.pot -d rh_ui/translations	# update .po files basing on .pot
	pipenv run pybabel compile -d rh_ui/translations

up:
	$(DOCKER) compose up -d
	CONTAINER_CLI=$(DOCKER) bash ./tests/integration/wait_for_dependencies.sh

down:
	$(DOCKER) compose down

integration_test: up
	APP_CONFIG=TestingConfig pipenv run pytest tests/integration
	$(DOCKER) compose down

megalint:  ## Run the mega-linter.
	$(DOCKER) run --platform linux/amd64 --rm \
		-v /var/run/docker.sock:/var/run/docker.sock:rw \
		-v $(shell pwd):/tmp/lint:rw \
		oxsecurity/megalinter:v8

megalint-fix:  ## Run the mega-linter and attempt to auto fix any issues.
	$(DOCKER) run --platform linux/amd64 --rm \
		-v /var/run/docker.sock:/var/run/docker.sock:rw \
		-v $(shell pwd):/tmp/lint:rw \
		-e APPLY_FIXES=all \
		oxsecurity/megalinter:v8

clean-megalint: ## Clean the temporary files.
	rm -rf megalinter-reports

lint-check: clean-megalint megalint

