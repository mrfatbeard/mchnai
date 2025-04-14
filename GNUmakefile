IP=10.254.0.166

all:

apk:
	flutter build apk

protogen:
	mkdir -p lib/src/generated
	protoc --dart_out=grpc:lib/src/generated -Iprotos protos/service.proto
	protoc -I=protos --java_out=android/app/src/main/java/protos --kotlin_out=android/app/src/main/kotlin/protos protos/service.proto

rundebug:
	~/go/bin/grpcui  -import-path $(shell pwd)/protos -proto $(shell pwd)/protos/service.proto -plaintext $(IP):50051