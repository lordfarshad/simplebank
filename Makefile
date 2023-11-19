postgres:
	docker run --name=bank -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_HOST_AUTH_METHOD=trust -d postgres:16
mysql:
	docker run --name mysql8 -p 3306:3306 -e MYSQL_PASSWORD=something -d mysql:8.2

createdb:
	docker exec -it bank createdb --username=root --owner=root simplebank

dropdb:
	docker exec -it bank dropdb simplebank
migrateup:
	migrate -path db/migration -database "postgresql://root:postgres@localhost:5432/simplebank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:postgres@localhost:5432/simplebank?sslmode=disable" -verbose down 

sqlc: 
	sqlc generate
	
test: 
	go test -v -cover -race ./...

server: 
	go run main.go

.PHONY:	postgres mysql createdb dropdb migrateup migratedown sqlc test server