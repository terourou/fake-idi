default: run

data: generate_data.R
	Rscript generate_data.R

# files in sql directory
sql_files := $(wildcard sql/*.sql)

create_db.R: generate_data.R

sql/%.sql: create_db.R
	Rscript create_db.R

run: build $(sql_files)
	docker run -it --rm \
		-v $(PWD):/data \
		--env-file ../.env \
		terourou/idi

build: Dockerfile
	docker build -t terourou/idi .
