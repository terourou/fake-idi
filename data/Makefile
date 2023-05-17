default: run

run: build
	docker run -it --rm \
		-v $(PWD):/data \
		--env-file ../.env \
		terourou/idi

build: Dockerfile
	docker build -t terourou/idi .

.PHONY: run
