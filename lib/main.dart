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
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ValueListenableBuilder(
            valueListenable: store.connectionState,
            builder: (context, value, _) {
              if (value == ConnectionStatus.conectado) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10.0,
                  ),
                  child: FloatingActionButton.extended(
                    onPressed: store.sendPing,
                    backgroundColor: Colors.green,
                    label: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 10,
                          ),
                          child: Text(
                            store.conectionStatusText(value).$2,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: store.pingState,
                          builder: (context, value, _) {
                            String ping = value;

                            if (value.isEmpty) {
                              return const Icon(
                                Icons.sync,
                                color: Colors.white,
                              );
                            }

                            return Text(
                              ping,
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }

              return const SizedBox();
            },
          ),
          ValueListenableBuilder(
            valueListenable: store.connectionState,
            builder: (context, value, _) {
              return FloatingActionButton.extended(
                onPressed: value == ConnectionStatus.conectando ||
                        value == ConnectionStatus.conectado
                    ? store.disconnectToServer
                    : store.connectToServer,
                backgroundColor: store.connectionStatusColor(
                  value,
                ),
                label: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 10,
                      ),
                      child: Text(
                        store.conectionStatusText(value).$1,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.dns,
                      color: Colors.white,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
