import 'package:band_names/src/screens/status_screen.dart';
import 'package:band_names/src/services/socket_service.dart';
import 'package:band_names/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SocketService())],
      child: MaterialApp(
        title: 'Material App',
        initialRoute: "status",
        routes: {
          "home": (_) => const HomeScreen(),
          "status": (_) => StatusScreen(),
        },
      ),
    );
  }
}
