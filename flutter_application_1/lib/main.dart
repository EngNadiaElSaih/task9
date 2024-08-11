import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/post_provider.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_1/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(),
        home: HomePage(),
      ),
    );
  }
}
