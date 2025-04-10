all:

apk:
	flutter build apk

compile-proto:
	mkdir -p lib/src/generated
	protoc --dart_out=grpc:lib/src/generated -Iprotos protos/service.proto
