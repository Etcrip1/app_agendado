import 'package:app_agendado/Telas/TelaAdicionarEvento.dart';
import 'package:app_agendado/Telas/TelaEventos.dart';
import 'package:app_agendado/Telas/WidgetProximoEvento.dart';
import 'package:app_agendado/model/Evento.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../commom/AppColors.dart';

class TelaPrincipal extends StatefulWidget {
  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  var _calendarController = CalendarController();
  List<Evento> _events = [];
  Evento _evento;
  Map<DateTime, List<dynamic>> _map;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference eventos =
      FirebaseFirestore.instance.collection('eventos');

  mapConverter(List<Evento> lista) {
    Map<DateTime, List<dynamic>> map = new Map();
    for (Evento evento in lista) {
      map.putIfAbsent(evento.data, () => [evento.nome]);
    }
    return map;
  }

  List<Evento> readFirebase() {
    List<Evento> lista = [];
    FirebaseFirestore.instance
        .collection('eventos')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                lista.add(Evento('doc.id', doc['data'].toDate(), doc['nome']));
              })
            });

    return lista;
  }

  Evento getNextEvent(List<Evento> lista) {
    if (lista.isNotEmpty) {
      List<Evento> temp = lista
          .where((element) => element.data.isAfter(DateTime.now()))
          .toList();

      temp.sort((x, y) => x.data.compareTo(y.data));
      return temp.first;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    _events = readFirebase();
    _evento = getNextEvent(readFirebase());
    _map = mapConverter(_events);
  }

  @override
  Widget build(BuildContext context) {
    initState();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "AGENDADO",
            style: TextStyle(color: AppColors.secondaryColor),
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.add,
                  size: 40,
                  color: AppColors.secondaryColor,
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaAdicionarEvento(),
                    )))
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                WidgetProximoEvento(
                    texto: "Próximo evento", altura: 60, evento: _evento),
                TableCalendar(
                    calendarController: _calendarController, events: _map),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RaisedButton(
                        color: AppColors.primaryColor,
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Adicionar eventos",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TelaAdicionarEvento(),
                            ))),
                    RaisedButton(
                        color: AppColors.primaryColor,
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Eventos",
                          style: TextStyle(
                              color: AppColors.secondaryColor, fontSize: 20),
                        ),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TelaEventos(_events, null),
                            )))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
