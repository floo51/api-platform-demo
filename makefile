
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
	docker-compose exec admin yarn install

test-open:
	cd tests && yarn run cypress open

test:
	cd tests && yarn run cypress run

install-cypress:
	$(DOCKER_COMPOSE_TEST) run --rm --no-deps cypress bash -ci 'yarn run cypress install'

test-docker-environment-start:
	$(DOCKER_COMPOSE_TEST) up

test-docker-run:
	$(DOCKER_COMPOSE_TEST) run --rm --no-deps cypress bash -ci 'yarn run cypress run'

test-docker-build:
	$(DOCKER_COMPOSE_TEST) run admin yarn build

test-docker-open-cypress:
	$(DOCKER_COMPOSE_TEST) -f ./tests/cy-open.yml run --no-deps cypress bash -ci 'NODE_ENV=test ./node_modules/.bin/cypress open'