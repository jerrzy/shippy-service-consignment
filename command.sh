#! /bin/bash

# 1. install GO v1.16 on ubantu
# 1.1  wget https://golang.org/dl/go1.16.10.linux-amd64.tar.gz
# 1.2  tar -xzf go1.16.10.linux-amd64.tar.gz -C /usr/local
# 1.3  open /etc/profile, add export PATH=$PATH:/usr/local/go/bin, source /etc/profile
# 1.4  go version


# NOTE! New to protoc!
# google deprecated grpc plugin, 
# Now you have to download two libs for compiling proto
# 	go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.26
# 	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.1
# And use the new command to generate go files
#	protoc --go_out=. --go_opt=paths=source_relative     --go-grpc_out=. --go-grpc_opt=paths=source_relative     proto/consignment/consignment.proto
# This will create two files
#	consignment_grpc.pb.go	Code for client and server.
#	consignment.pb.go		Code for populating, serializing, and retrieving HelloRequest and HelloReply message types.

# the code for the server remains the same. one import will cover both.

# Note! setup grpc path for the linter to run properly.
# Although the grpc cli still function without it.

$ mkdir shippy && cd shippy
$ mkdir -p shippy-service-consignment/proto/consignment/
$ touch shippy-service-consignment/proto/consignment/consignment.proto

cd shippy-service-consignment
# run the command at shippy/shippy-service-consignment directory
# the directory where we run the .sh should match what's in the .proto definition
# e.g. option go_package="proto/consignment";
# NOTE! plugins are no longer supported
protoc -I. --go_out=plugins=grpc:. proto/consignment/consignment.proto
# new command
protoc --go_out=. --go_opt=paths=source_relative \
    --go-grpc_out=. --go-grpc_opt=paths=source_relative \
    proto/consignment/consignment.proto
#
protoc --go_out=. --go-grpc_out=. proto/consignment/consignment.proto

# call local module
go mod edit -replace source-module-url=source-module-local-dir (../shippy-service-consignment/)
go mod tidy

# go mod tidy will create something like this
# github.com/jerryli/shippy-service-consignment v0.0.0-00010101000000-000000000000
# all sub directories are accessable



# docker
# build the image
docker build -t shippy-service-consignment .
# run the image
docker run -p 50051:50051 shippy-service-consignment


# micro v2
go get github.com/micro/micro/v2
go get github.com/micro/micro/v2/cmd/protoc-gen-micro@master

# micro v3
go get github.com/micro/micro/v3

# protoc command that works on micro v3.
protoc --proto_path=. --go_out=. --micro_out=. proto/consignment/consignment.proto