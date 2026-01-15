.PHONY: jdk17-maven-node22 gcloud-firestore-emulator gcloud-pubsub-emulator modsecurity cloud-sdk-firebase-cli tinyproxy cloudsql-proxy python-pipenv cloud-sdk-terraform eq-stub owasp-venom

jdk17-maven-node22:
	docker build ./jdk17-maven-node22 -t europe-west2-docker.pkg.dev/ssdc-rm-ci/docker/jdk17-mvn-node22-npm:latest

gcloud-pubsub-emulator:
	docker build ./gcloud-pubsub-emulator -t europe-west2-docker.pkg.dev/ssdc-rm-ci/docker/gcloud-pubsub-emulator:latest

gcloud-firestore-emulator:
	docker build ./gcloud-firestore-emulator -t europe-west2-docker.pkg.dev/ssdc-rm-ci/docker/gcloud-firestore-emulator:latest

modsecurity:
	docker build ./modsecurity -t europe-west2-docker.pkg.dev/ssdc-rm-ci/docker/modsecurity:latest

cloud-sdk-firebase-cli:
	docker build ./cloud-sdk-firebase-cli -t europe-west2-docker.pkg.dev/ssdc-rm-ci/docker/cloud-sdk-firebase-cli:latest

tinyproxy:
	docker build ./tinyproxy -t europe-west2-docker.pkg.dev/ssdc-rm-ci/docker/tinyproxy:latest

cloudsql-proxy:
	docker build ./cloudsql-proxy -t europe-west2-docker.pkg.dev/ssdc-rm-ci/docker/cloudsql-proxy:latest

python-pipenv: python-pipenv-3.12

python-pipenv-3.13:
	docker build --build-arg="PYTHON_TAG=$$(cat python-pipenv/python-3.13-tag.txt)" ./python-pipenv -t europe-west2-docker.pkg.dev/ons-ci-rm/docker/python-pipenv:3.13

python-pipenv-3.12:
	docker build --build-arg="PYTHON_TAG=$$(cat python-pipenv/python-3.12-tag.txt)" ./python-pipenv -t europe-west2-docker.pkg.dev/ons-ci-rm/docker/python-pipenv:3.12

python-pipenv-3.11:
	docker build --build-arg="PYTHON_TAG=$$(cat python-pipenv/python-3.11-tag.txt)" ./python-pipenv -t europe-west2-docker.pkg.dev/ons-ci-rm/docker/python-pipenv:3.11

cloud-sdk-terraform:
	docker build ./cloud-sdk-terraform -t europe-west2-docker.pkg.dev/ssdc-rm-ci/docker/cloud-sdk-terraform:latest

eq-stub:
	docker build ./eq-stub -t europe-west2-docker.pkg.dev/ssdc-rm-ci/docker/ssdc-rm-eq-stub:latest

owasp-venom:
	docker build ./owasp-venom -t europe-west2-docker.pkg.dev/ssdc-rm-ci/docker/venom:latest

build-all: gcloud-pubsub-emulator gcloud-firestore-emulator modsecurity cloud-sdk-firebase-cli tinyproxy cloudsql-proxy python-pipenv-3.11 python-pipenv-3.12 cloud-sdk-terraform eq-stub owasp-venom
