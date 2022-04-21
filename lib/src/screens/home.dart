import 'dart:io';

import 'package:band_names/src/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import '../services/socket_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket?.on('active-bands', _handleActiveBands);
    super.initState();
  }

  void _handleActiveBands(dynamic payload) {
    //*Casteamos el payload como una lista ya que es de tipo dynamico y así podemos mapearlo
    bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket?.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
        appBar: AppBar(
          title:
              const Text("BandNames", style: TextStyle(color: Colors.black87)),
          backgroundColor: Colors.white,
          elevation: 1,
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 10),
                child: (socketService.serverStatus != ServerStatus.online)
                    ? const Icon(
                        Icons.offline_bolt,
                        color: Colors.red,
                      )
                    : Icon(Icons.check_circle, color: Colors.blue[300]))
          ],
        ),
        body: Column(
          children: [
            _showPieChart(),
            Expanded(
              child: ListView.builder(
                  itemCount: bands.length,
                  itemBuilder: (BuildContext context, int index) =>
                      _bandTile(bands[index])),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(
              Icons.add,
            ),
            elevation: 1,
            onPressed: _addNewBand));
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id!),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) =>
          socketService.socket?.emit('delete-band', {'id': band.id}),
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
        onTap: () => socketService.socket?.emit('vote-band', {'id': band.id}),
      ),
    );
  }

  _addNewBand() {
    final TextEditingController textEditingController = TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: const Text("New Band Name"),
                  content: TextField(controller: textEditingController),
                  actions: [
                    MaterialButton(
                        child: const Text("Add"),
                        elevation: 5,
                        textColor: Colors.blue,
                        onPressed: () =>
                            _addBandToList(textEditingController.text))
                  ]));
    }
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
                title: const Text("New Band Name"),
                content: CupertinoTextField(controller: textEditingController),
                actions: [
                  CupertinoDialogAction(
                      isDefaultAction: true,
                      child: const Text("Add"),
                      onPressed: () =>
                          _addBandToList(textEditingController.text)),
                  CupertinoDialogAction(
                      isDestructiveAction: true,
                      child: const Text("Dismiss"),
                      onPressed: () => Navigator.pop(context))
                ]));
  }

  void _addBandToList(String bandName) {
    if (bandName.length > 1) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      //* Podemos agregar
      socketService.socket?.emit('add-band', {'bandName': bandName});
    }
    Navigator.pop(context);
  }

  Widget _showPieChart() {
    Map<String, double> dataMap = {'Bands': 0};
    for (var band in bands) {
      dataMap.putIfAbsent(band.name ?? "", () => band.votes?.toDouble() ?? 1);
    }
    return SizedBox(
        width: double.infinity,
        height: 200,

        ///*En docu muchas propiedades
        child: PieChart(
          dataMap: dataMap,
          animationDuration: const Duration(milliseconds: 800),
          chartLegendSpacing: 32,
          chartRadius: MediaQuery.of(context).size.width / 3.2,
          initialAngleInDegree: 0,
          chartType: ChartType.ring,
          ringStrokeWidth: 20,
          centerText: "",
          legendOptions: const LegendOptions(
            showLegendsInRow: false,
            legendPosition: LegendPosition.right,
            showLegends: true,
            legendShape: BoxShape.circle,
            legendTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          chartValuesOptions: const ChartValuesOptions(
            showChartValueBackground: true,
            showChartValues: true,
            showChartValuesInPercentage: true,
            showChartValuesOutside: false,
            decimalPlaces: 0,
          ),
          // gradientList: ---To add gradient colors---
          // emptyColorGradient: ---Empty Color gradient---
        ));
  }
}
