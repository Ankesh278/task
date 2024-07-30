import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Provider/data_provider.dart';
import 'View.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => data_provider()),
      ],
      child: MaterialApp(
        title: 'User List App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: UserListPage(),
      ),
    );
  }
}
