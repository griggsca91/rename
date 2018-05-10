package-name = rename

go-files = api.go db.go user.go

srcs = $(go-files:%=$(package-name)/%)

build: get-libraries main frontend

run: main
	ulimit -n 65536
	nohup ./main &

get-libraries:
	dep ensure

watch: install-frontend
	./node_modules/.bin/webpack -d --watch

run-dev: get-libraries frontend main
	go run -x main.go --port=3000 

frontend: install-frontend
	./node_modules/.bin/webpack

init-db:
	createuser --createdb --createrole --superuser --replication toiletbowl;

install-frontend: package.json
	npm i

main:  $(srcs) main.go
	go build -o main

clean:
	rm main
