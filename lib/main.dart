import 'package:flutter/material.dart';
import 'package:behealthy/pages/home.dart';
import 'package:behealthy/pages/calorieshistoty.dart';
import 'package:behealthy/pages/submitfoods.dart';


main()=> runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Home(),);
  }
}
