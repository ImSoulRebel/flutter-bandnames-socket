import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  ServerStatus get serverStatus => _serverStatus;
  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    // *Dart Client

    Socket socket = io(
        'http://192.168.1.46:3000',
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .enableAutoConnect() // enable auto-connection
            .build());
    socket.connect();
    socket.onConnect((_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    socket.onDisconnect((_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
    socket.on('nuevo-mensaje', (payload) {
      debugPrint('nuevo-mensaje:');
      debugPrint('nombre:' + payload['nombre']);
      debugPrint('mensaje:' + payload['mensaje']);
      debugPrint(payload.containsKey(
          // * Todos los mapas tienen la propiedad containsKey para manejar las excepciones
          'mensaje2') ? payload['mensaje2'] : 'No hay mensaje');
    });
    socket.off('nuevo-mensaje');
  }
}
