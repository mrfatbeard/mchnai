import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'dart:async';
import 'package:grpc/grpc.dart';
import 'package:rxdart/subjects.dart';

import 'src/generated/service.pb.dart';
import 'src/generated/service.pbgrpc.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ServerControlScreen(),
    );
  }
}

class ServerControlScreen extends StatefulWidget {
  @override
  _ServerControlScreenState createState() => _ServerControlScreenState();
}

class _ServerControlScreenState extends State<ServerControlScreen> {
  bool _isServerRunning = false;

  Future<void> _startServer() async {
    setState(() {
      _isServerRunning = true;
    });
    await startServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('gRPC Server Control')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isServerRunning ? null : _startServer,
              child: Text('Запустить gRPC сервер'),
            ),
            SizedBox(height: 20),
            Text(
              _isServerRunning ? 'Сервер запущен' : 'Сервер не запущен',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> startServer() async {
  final server = Server([HelloServiceImpl()]);
  await server.serve(port: 50051);
  print('Server is listening on port ${server.port}...');
}

class HelloServiceImpl extends HelloServiceBase {
  /*@override
  Stream<StringReply> sayHelloStream(ServiceCall call, NumMessagesRequest request) async* {
    for (var i = 0; i < request.numMessages; i++) {
      await Future.delayed(Duration(seconds: 1)); // Имитация задержки
      yield StringReply()..message = 'Message #$i from Dart';
    }
  }*/
  @override
  Stream<StringMessage> sayHelloStream(ServiceCall call, NumMessages request) async *{
    final MethodChannel a = MethodChannel('com.example.grpc');
    final res = await a.invokeMethod('sayHelloStream', {'count': request.count});
    final resMap = res as Map;
    yield StringMessage(
      message: resMap["message"]
    );
    return;

    /*
    final PublishSubject<StringMessage> stream = PublishSubject();
    a.setMethodCallHandler((call) async {
      stream.add(
        StringMessage(
          message: call.toString()
        )
      );
      // из натива
      //if (call.method = 'updateStatus') {
        //stream.add(call.arguments['status']);
      //}
    });
    final res = await a.invokeMethod('sayHelloStream', {'count': count});
    final rs = res.toString();
    return stream;*/

    /*
    // Используем EventChannel для получения результатов
    const EventChannel eventChannel = EventChannel('com.example.grpc/event');

    // Вызов метода на платформе
    const platform = MethodChannel('com.example.grpc');
    try {
      await platform.invokeMethod('sayHelloStream', {'count': count});
    } on PlatformException catch (e) {
      print("Failed to invoke: '${e.message}'.");
    }

    // Слушаем события из EventChannel
    //eventChannel.receiveBroadcastStream().listen((data) {
    //  StringMessage msg = StringMessage()..message = data;
    //  yield msg;
    //});

    final evtStream = eventChannel.receiveBroadcastStream();
    await for(final evt in evtStream) {
        StringMessage msg = StringMessage()..message = evt;
        yield msg;
    }
     */
  }
}

void main() {
  runApp(MyApp());
}
