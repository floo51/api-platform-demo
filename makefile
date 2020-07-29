
USER_ID = $(shell id -u)
GROUP_ID = $(shell id -g)

export UID = $(USER_ID)
export GID = $(GROUP_ID)

DOCKER_COMPOSE_TEST = docker-compose -p api-platform-argos -f docker-compose.yml -f docker-compose.test.yml

load-fixtures:
	docker-compose exec -T php bin/console hautelook:fixtures:load -n --no-ansi -q

drop-db:
	docker-compose exec php bin/console doctrine:schema:drop --full-database --force

update-db:
	docker-compose exec php bin/console doctrine:schema:update  --complete --force

install-admin-deps:
	docker-compose run admin yarn install

test-open:
	cd tests && yarn run cypress open

test:
	cd tests && yarn run cypress run

install-cypress:
	$(DOCKER_COMPOSE_TEST) run --rm --no-deps cypress bash -ci 'yarn run cypress install'




test-load-fixtures:
	$(DOCKER_COMPOSE_TEST) run -T php bin/console hautelook:fixtures:load -n --no-ansi -q

test-update-db:
	$(DOCKER_COMPOSE_TEST) run php bin/console doctrine:schema:update  --complete --force


test-docker-run: test-update-db test-load-fixtures
	$(DOCKER_COMPOSE_TEST) up --force-recreate --abort-on-container-exit --exit-code-from cypress






build-cypress:
	$(DOCKER_COMPOSE_TEST) build cypress

bash-cypress:
	$(DOCKER_COMPOSE_TEST) exec cypress bash

test-docker-build:
	$(DOCKER_COMPOSE_TEST) run admin yarn build

test-docker-open-cypress:
	$(DOCKER_COMPOSE_TEST) -f ./tests/cy-open.yml run --no-deps cypress bash -ci 'NODE_ENV=test ./node_modules/.bin/cypress open --config baseUrl=http://admin:3000/'


test-docker-environment-start:
	$(DOCKER_COMPOSE_TEST) up -d
	$(MAKE) test-docker-build
	$(MAKE) test-update-db
	$(MAKE) test-load-fixtures

test-docker-environment-stop:
	$(DOCKER_COMPOSE_TEST) stop

test-docker-environment-logs:
	$(DOCKER_COMPOSE_TEST) logs -f

setup-test: install-admin-deps test-docker-build test-docker-environment-start

teardown-test: test-docker-environment-stop

run-test:
	$(DOCKER_COMPOSE_TEST) run --rm --no-deps --name=api-platform-argos_cypress_run cypress bash -ci 'yarn wait-and-test'
