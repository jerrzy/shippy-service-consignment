#! /bin/bash

# pre steps 
# 1. prepare your ubantu. install all essential packages
# apt-get install build-essential

# 1. install GO v1.16 on ubantu
# 1.1  wget https://golang.org/dl/go1.16.10.linux-amd64.tar.gz
# 1.2  tar -xzf go1.16.10.linux-amd64.tar.gz -C /usr/local
# 1.3  open /etc/profile, add export PATH=$PATH:/usr/local/go/bin, source /etc/profile
# 1.4  go version

# git reminder
# 1. link to a remote repo
#   git remote add origin https://github.com/jerrzy/microservice_client.git
# 2. push to master. default branch is main.
#   git push --set-upstream origin master
# 3. git clone a branch
#   git clone -b master https://github.com/jerrzy/microservice-demo.git

# install gRPC
# 1 apt install -y protobuf-compiler
# 2 go get github.com/golang/protobuf/protoc-gen-go
# 3 go get github.com/micro/micro/v3/cmd/protoc-gen-micro
# 4 test it by protoc

# !VERY important note of using micro
# For SURE! micro v3 is completely different to micro v2 and its complier uses different dependencies (micro v3 to v2) for proto!
# so the v3 generated proto.go doesn't work on v2 dependencies!
# make sure double check the pb.micro.go and the micro dependencies are v2
# protoc command that works on micro v2.
protoc --proto_path=. --go_out=. --micro_out=. proto/consignment/consignment.proto

# docker
# build the image
docker build -t shippy-service-consignment .
# run the image
docker run -p 50051:50051 -e MICRO_SERVER_ADDRESS=:50051 shippy-service-consignment
# don't know why have to use an older version of grpc for micro
replace google.golang.org/grpc => google.golang.org/grpc v1.26.0

# publish go module
# 1. commit and push to github
# 2. git commit -m "mymodule: changes for v0.1.0"
#    git tag v0.1.0
#    git push origin v0.1.0
# 3. GOPROXY=proxy.golang.org go list -m example.com/mymodule@v0.1.0
# old comment by myself
#################################################################
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






# micro v2
go get github.com/micro/micro/v2
go get github.com/micro/micro/v2/cmd/protoc-gen-micro@master

# micro v3
go get github.com/micro/micro/v3

