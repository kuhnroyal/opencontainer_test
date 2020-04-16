import 'package:flutter/material.dart';
import 'package:opencontainer_tests/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenContainer Tests',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
      builder: (context, child) {
        return Provider<HomeListModel>(
          create: (_) => HomeListModel(),
          dispose: (_, model) => model.dispose(),
          child: child,
        );
      },
    );
  }
}
