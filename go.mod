module github.com/jerrzy/shippy-service-consignment

go 1.16

replace google.golang.org/grpc => google.golang.org/grpc v1.26.0

require (
	github.com/golang/protobuf v1.5.2
	github.com/jerrzy/shippy-service-vessel v0.1.1
	github.com/micro/go-micro/v2 v2.9.1
	github.com/pkg/errors v0.9.1
	go.mongodb.org/mongo-driver v1.7.4
	google.golang.org/grpc/examples v0.0.0-20211117200604-295d7e66becc // indirect
	google.golang.org/protobuf v1.27.1
)
