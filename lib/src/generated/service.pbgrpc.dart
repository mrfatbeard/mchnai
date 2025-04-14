//
//  Generated code. Do not modify.
//  source: service.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'service.pb.dart' as $0;

export 'service.pb.dart';

@$pb.GrpcServiceName('HelloService')
class HelloServiceClient extends $grpc.Client {
  static final _$sayHelloStream = $grpc.ClientMethod<$0.NumMessages, $0.StringMessage>(
      '/HelloService/sayHelloStream',
      ($0.NumMessages value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.StringMessage.fromBuffer(value));

  HelloServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseStream<$0.StringMessage> sayHelloStream($0.NumMessages request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$sayHelloStream, $async.Stream.fromIterable([request]), options: options);
  }
}

@$pb.GrpcServiceName('HelloService')
abstract class HelloServiceBase extends $grpc.Service {
  $core.String get $name => 'HelloService';

  HelloServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.NumMessages, $0.StringMessage>(
        'sayHelloStream',
        sayHelloStream_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.NumMessages.fromBuffer(value),
        ($0.StringMessage value) => value.writeToBuffer()));
  }

  $async.Stream<$0.StringMessage> sayHelloStream_Pre($grpc.ServiceCall $call, $async.Future<$0.NumMessages> $request) async* {
    yield* sayHelloStream($call, await $request);
  }

  $async.Stream<$0.StringMessage> sayHelloStream($grpc.ServiceCall call, $0.NumMessages request);
}
