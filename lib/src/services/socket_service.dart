import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  ///*Asignamos un status predeterminado
  ServerStatus _serverStatus = ServerStatus.connecting;
  ServerStatus get serverStatus => _serverStatus;
  Socket? _socket;
  Socket? get socket => _socket;

  ///* Para simplificar el emit del socket
  Function? get emit => _socket?.emit;

  ///*InitialFetch
  SocketService() {
    _initConfig();
  }

  ///*InitialFetch
  void _initConfig() {
    // *Dart Client
    _socket = io(
        //*Alternativas, puede variar de IOS a Android
        // 'http://localhost:3000',
        // 'http://10.0.2.2:3000',
        'http://192.168.1.33:3000',
        OptionBuilder()
            .setTransports(['websocket']) // *for Flutter or Dart VM
            .enableAutoConnect() // *enable auto-connection
            .build());
    _socket?.connect();
    _socket?.onConnect((_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });
    _socket?.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });

    //* Evento personalizado en "duro"
    // socket.on('nuevo-mensaje', (payload) {
    //   //* CallBack que se ejecuta cuando recibimos nuevo-mensaje
    //   debugPrint('nuevo-mensaje:');
    //   debugPrint('nombre:' + payload['nombre']);
    //   debugPrint('mensaje:' + payload['mensaje']);
    //   debugPrint(payload.containsKey(
    //       // * Todos los mapas tienen la propiedad containsKey para manejar las excepciones
    //       'mensaje2') ? payload['mensaje2'] : 'No hay mensaje');
    // });
    _socket?.off('nuevo-mensaje');
  }
}
