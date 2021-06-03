run:
# Postgres
	@echo "Postgres benchmark"
	@echo "\tRemoving old container..."
	@docker stop benchPostgres 2> /dev/null || true && echo "\tStarting test database" && docker run --rm --name benchPostgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=password -p 5433:5432 -d postgres:12.4 1> /dev/null
	@sleep 3
	@PGPASSWORD=password psql -h localhost -p 5433 -U postgres -f ./benchmark.ddl 1> /dev/null || { docker stop benchPostgres && docker rm benchPostgres; exit 1; }
	@echo "\tTest schema/data loaded into database"
