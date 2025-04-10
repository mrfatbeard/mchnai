import 'package:flutter/material.dart';
import 'dart:async';
import 'package:grpc/grpc.dart';
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
  final server = Server([GreeterService()]);
  await server.serve(port: 50051);
  print('Server is listening on port ${server.port}...');
}

class GreeterService extends GreeterServiceBase {
  @override
  Stream<StringReply> sayHelloStream(ServiceCall call, NumMessagesRequest request) async* {
    for (var i = 0; i < request.numMessages; i++) {
      await Future.delayed(Duration(seconds: 1)); // Имитация задержки
      yield StringReply()..message = 'Message #$i from Dart';
    }
  }
}

void main() {
  runApp(MyApp());
}
