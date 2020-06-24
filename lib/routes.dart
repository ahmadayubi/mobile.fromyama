import 'package:flutter/material.dart';
import 'screens/boot.dart';

class Routes {
  final routes = <String, WidgetBuilder>{
    //'/MainDash': (BuildContext context) => new MainDash(),
    '/': (BuildContext context) => new Boot(),
  };

  Routes() {
    runApp(new MaterialApp(
      title: 'FromYama',
      routes: routes,
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    ));
  }
}
