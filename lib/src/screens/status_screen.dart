import 'package:band_names/src/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("ServerStatus: ${socketService.serverStatus}")],
        ),
      ),

      ///* Mensaje a servidor por comunicación por sockets
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.message),
        onPressed: () {
          // *emitir: nuevo-mensaje
          socketService.socket?.emit('nuevo-mensaje',
              {'nombre': 'Flutter', 'mensaje': 'Hola desde Flutter'});
        },
      ),
    );
  }
}
