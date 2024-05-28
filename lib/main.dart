import 'app_router.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(BreakingbadApp(approuter: Approuter()));
}

class BreakingbadApp extends StatelessWidget {
  final Approuter approuter;
  const BreakingbadApp({Key? key, required this.approuter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: approuter.generateroute,
    );
  }
}
