import 'package:band_names/src/screens/status_screen.dart';
import 'package:band_names/src/services/socket_service.dart';
import 'package:band_names/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SocketService())],
      child: MaterialApp(
        title: 'Material App',
        initialRoute: "home",
        routes: {
          "home": (_) => const HomeScreen(),
          "status": (_) => const StatusScreen(),
        },
      ),
    );
  }
}
