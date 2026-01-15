# SRM Respondent Home UI

User Interface for respondents to access ONS Survey Data Collection questionnaires and services

## Installation/build

To install all dependencies and download the templates run:

```shell
make install
```

To build the docker image and run the tests:

```shell
make build
```

## Running

Once that's done, you can run the make command to run it in your terminal:

```shell
make run
```

or to run it in Pycharm, use the run template that's specified and it should work as expected.

Podman and Docker are both supported for building and running the application.
By default the Makefile will use `docker` unless you are on an `arm64` architecture (e.g. M1/M2 Mac) in which case it will use `podman`.
You can override this by setting the `DOCKER` environment variable to either `docker` or `podman`.
For example, to force using `docker` on an M1/M2 Mac:
```shell
DOCKER=docker make <command>
```

## Translations

The site uses PyBabel for translations.

Text to translate is marked up in `.html` and `.py` templates and files with the [gettext](https://en.wikipedia.org/wiki/Gettext) mechanism. Then a `messages.pot` file is build via Pybabel, which collates all the text to translate.

Based on the content of the `.pot` file translation files `messages.po` are created for all specified language codes. Finally, the `.po` files are compiled into `.mo` files, which are then used on the page.

1. Extract text to translation

To build/re-build the translation messages.pot use:

```shell
pipenv run pybabel extract -F babel.cfg -o rh_ui/translations/messages.pot .
```

2. Create new language file
> [!CAUTION]
> Follow this step only when you want to add translation for a new language. Running it for an existing language code will overwrite the existing translations.

To create a new language messages file, run the following, changing the 2 character language code at the end to the
required language code. Only generate a individual language file once.

```shell
pipenv run pybabel init -i rh_ui/translations/messages.pot -d rh_ui/translations -l cy
```

3. Update translation files

Once created, you can update the existing language messages.po files to include changes in the messages.pot by running
the following. This will update ALL language files.

```shell
pipenv run pybabel update -i rh_ui/translations/messages.pot -d rh_ui/translations
```

4. Compile the translations

> [!NOTE]
> Double check your translation files (messages.po) for the `#, fuzzy` comment. This indicates that the tranlsation isn't an exact match and won't be rendered on the page. Double check the translations and remove any incorrectly matched lines, then remove the `fuzzy` comment.

To compile updates to the messages.po files into messages.mo (the file actually used by the site) use:
```shell
pipenv run pybabel compile -d rh_ui/translations
```
## Venom Tests

We have a suite of [Venom tests](https://github.com/ovh/venom) for testing the OWASP header recommendations. These tests
are copied from the [OWASP Secure Headers Project](https://github.com/oshp/oshp-validator).

See [./tests/venom_tests.yml](./tests/venom_tests.yml).

These tests are designed to be run against a public HTTPS endpoint in a prod-like environment, since some of the headers
they check must not be present on HTTP responses e.g.
the [HSTS header](https://www.rfc-editor.org/rfc/rfc6797#section-6.1). Hence, these tests cannot all pass when run
against a local HTTP only instance. However, it may be useful for development to still run them locally.

### Running Venom locally

* First, use our [docker dev](https://github.com/ONSdigital/ssdc-rm-docker-dev) to run our local development
  environment to test against.

* Now create a local copy of the venom test suite with the correct URL substituted in:

  ```shell
  sed -e "s|<VENOM_TARGET_URL>|http://host.docker.internal:9092/en/start|" ./tests/venom_tests.yml > tmp_venom_local.yml
  ```

  It may be helpful to now open the created `tmp_venom_local.yml` file in an editor and comment out the
  `Strict-Transport-Security` test case which is bound to fail locally.

* Now run the tests against the docker dev RH UI using the official OVH Venom docker image (
  See <https://github.com/ovh/venom?tab=readme-ov-file#docker-image> for more details on running venom and docs on
  configuration).

  ```shell
  mkdir -p tmp_venom_results
  docker run --network="ssdcrmdockerdev_default" \
    --mount type=bind,source=$(pwd)/tmp_venom_local.yml,target=/workdir/tests/tests.yml \
    --mount type=bind,source=$(pwd)/tmp_venom_results,target=/workdir/results \
    ovhcom/venom:latest 
  ```

* The test results should be shown in your terminal, and details logs written in the `tmp_venom_results` folder.
