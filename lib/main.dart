import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grpc/grpc.dart';

import 'src/generated/service.pbgrpc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ServerControlScreen());
  }
}

class ServerControlScreen extends StatefulWidget {
  const ServerControlScreen({super.key});

  @override
  State<ServerControlScreen> createState() => _ServerControlScreenState();
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
  final server = Server.create(services: [HelloServiceImpl()]);
  await server.serve(port: 50051);
  debugPrint('Server is listening on port ${server.port}...');
}

class HelloServiceImpl extends HelloServiceBase {
  @override
  Stream<StringMessage> sayHelloStream(ServiceCall call, NumMessages request) {
    final EventChannel e = EventChannel('com.example.grpc/event');
    return e.receiveBroadcastStream().map((e) => StringMessage(message: e));
  }
}

void main() {
  runApp(MyApp());
}
