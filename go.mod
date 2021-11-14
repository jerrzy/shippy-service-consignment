module github.com/jerrzy/shippy-service-consignment

go 1.16

replace google.golang.org/grpc => google.golang.org/grpc v1.26.0

require (
	github.com/EwanValentine/shippy/shippy-service-consignment v0.0.0-20200612174527-3ad7cf4c07aa
	github.com/golang/protobuf v1.5.2
	github.com/micro/go-micro/v2 v2.9.1
	google.golang.org/grpc/examples v0.0.0-20211112205835-cf8b64e2c5bf // indirect
	google.golang.org/protobuf v1.27.1
)
