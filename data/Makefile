default: run

create_db.sql: create_db.R
	Rscript create_db.R

run: build create_db.sql
	docker run -it --rm \
		-v $(PWD):/data \
		--env-file ../.env \
		terourou/idi

build: Dockerfile
	docker build -t terourou/idi .
