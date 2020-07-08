CONTAINER_REGISTRY_BASE=quay.io/api-platform

run:
	docker-compose up

install:
	docker-compose run admin yarn install

build:
	docker-compose run admin yarn build

load-fixtures:
	docker-compose run php bin/console hautelook:fixtures:load

drop-db:
	docker-compose run php bin/console doctrine:schema:drop --full-database --force

update-db:
	docker-compose run php bin/console doctrine:schema:update  --complete --force
