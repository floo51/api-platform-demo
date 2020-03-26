
load-fixtures:
	docker-compose exec php bin/console hautelook:fixtures:load

drop-db:
	docker-compose exec php bin/console doctrine:schema:drop --full-database --force

update-db:
	docker-compose exec php bin/console doctrine:schema:update  --complete --force

install-admin-deps:
	docker-compose exec admin yarn install
