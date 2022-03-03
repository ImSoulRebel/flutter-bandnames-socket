import 'dart:io';

import 'package:band_names/src/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands = [
    Band(id: "1", name: "metallica", votes: 5),
    Band(id: "2", name: "Queen", votes: 5),
    Band(id: "3", name: "Héroes del Silencio", votes: 5),
    Band(id: "4", name: "Bon Jovi", votes: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              const Text("BandNames", style: TextStyle(color: Colors.black87)),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: ListView.builder(
            itemCount: bands.length,
            itemBuilder: (BuildContext context, int index) =>
                _bandTile(bands[index])),
        floatingActionButton: FloatingActionButton(
            child: const Icon(
              Icons.add,
            ),
            elevation: 1,
            onPressed: addNewBand));
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id!),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        //TODO llamar borrado ne server
      },
      background: Container(
          padding: const EdgeInsets.only(left: 8),
          color: Colors.red,
          child: const Align(
              alignment: Alignment.centerLeft,
              child:
                  Text("Delete band", style: TextStyle(color: Colors.white)))),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name!.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name!),
        trailing: Text("${band.votes}", style: const TextStyle(fontSize: 20)),
        onTap: () {
          print(band.name);
        },
      ),
    );
  }

  addNewBand() {
    final TextEditingController textEditingController = TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  title: const Text("New Band Name"),
                  content: TextField(
                    controller: textEditingController,
                  ),
                  actions: [
                    MaterialButton(
                        child: const Text("Add"),
                        elevation: 5,
                        textColor: Colors.blue,
                        onPressed: () =>
                            addBandToList(textEditingController.text))
                  ]));
    }
    showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
                title: const Text("New Band Name"),
                content: CupertinoTextField(controller: textEditingController),
                actions: [
                  CupertinoDialogAction(
                      isDefaultAction: true,
                      child: const Text("Add"),
                      onPressed: () =>
                          addBandToList(textEditingController.text)),
                  CupertinoDialogAction(
                      isDestructiveAction: true,
                      child: const Text("Dismiss"),
                      onPressed: () => Navigator.pop(context))
                ]));
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      // Podemos agregar
      bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
