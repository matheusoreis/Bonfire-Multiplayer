import 'dart:async';

import 'package:flutter/material.dart';
import 'package:websocket/main_store.dart';
import 'package:websocket/misc/app_dependencies.dart';

void main() {
  AppDependencies.setup();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MainStore store = dependency.get<MainStore>();
  late StreamSubscription<String> _alertSubscription;

  @override
  void initState() {
    super.initState();

    store.context = context;

    _alertSubscription = store.alertCore.alertStream.listen((message) {
      store.showAlertDialog(message);
    });
  }

  @override
  void dispose() {
    _alertSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Websocket'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder<ConnectionStatus>(
              valueListenable: store.connectionState,
              builder: (context, status, child) {
                String connectionStatus = 'Conectando...';

                if (status == ConnectionStatus.conectado) {
                  connectionStatus = 'Conectado';
                } else if (status == ConnectionStatus.desconectado) {
                  connectionStatus = 'Desconectado';
                }

                return Text(
                  connectionStatus,
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                );
              },
            ),
            ValueListenableBuilder<String?>(
              valueListenable: store.connectionErrorState,
              builder: (context, error, child) {
                if (error != null) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      error,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            ValueListenableBuilder(
              valueListenable: store.connectionState,
              builder: (context, value, _) {
                if (value == ConnectionStatus.conectado) {
                  return Column(
                    children: [
                      ValueListenableBuilder(
                        valueListenable: store.pingState,
                        builder: (context, value, _) {
                          return Text(value);
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          store.sendPing();
                        },
                        child: const Text(
                          'Enviar Ping',
                        ),
                      ),
                    ],
                  );
                }

                return const SizedBox();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: store.connectionState,
        builder: (context, value, _) {
          return FloatingActionButton(
            onPressed: value == ConnectionStatus.conectando ||
                    value == ConnectionStatus.conectado
                ? null
                : () {
                    store.connectToServer();
                  },
            backgroundColor: store.connectionStatusColor(
              value,
            ),
            child: const Icon(
              Icons.dns,
            ),
          );
        },
      ),
    );
  }
}
