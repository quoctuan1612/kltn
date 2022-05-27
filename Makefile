.DEFAULT_GOAL := usage

build:
	docker-compose build

db-create:
	export DB_PORT=$()
	docker-compose up -d
	docker-compose exec app bin/rails db:create

up:
	rm -rf tmp/pids/server.pid
	docker-compose up

down:
	docker-compose down

stop:
	docker-compose stop

db-migrate-up:
	scripts/db_migrate "postgres://localhost:5432/app_development?sslmode=disable&user=postgres" up
	scripts/db_migrate "postgres://localhost:5432/app_test?sslmode=disable&user=postgres" up
	docker-compose run --rm app ./bin/rails db:environment:set RAILS_ENV=test

db-migrate-down:
	scripts/db_migrate "postgres://localhost:5432/app_development?sslmode=disable&user=postgres" down
	scripts/db_migrate "postgres://localhost:5432/app_test?sslmode=disable&user=postgres" down

db-drop-create:
	docker-compose run --rm app ./bin/rails db:environment:set RAILS_ENV=development
	docker-compose run --rm -e RAILS_ENV=development app bundle exec rake db:drop db:create

reset: db-drop-create db-migrate-up

bundle:
	docker-compose run --rm app bundle install

yarn:
	docker-compose run --rm app yarn install

bundle-update:
	docker-compose run --rm app bundle update

console:
	docker-compose run --rm app bundle exec rails console

rubocop-fix:
	docker-compose run --rm app bundle exec rubocop --auto-correct

rspec:
	docker-compose run --rm app bundle exec rspec ${OPTS} --profile -- ${TARGETS}

attach:
	docker container attach $(docker-compose ps -q | head -n 1)

usage:
	@echo usage: [build, db-create, up, down, stop, db-migrate-up, db-migrate-down, db-drop-create, reset, bundle, bundle-update, console, rubocop-fix, rspec, update-pb, attach]
