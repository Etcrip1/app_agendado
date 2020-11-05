import 'package:app_agendado/Telas/TelaAdicionarEvento.dart';
import 'package:app_agendado/Telas/TelaEventos.dart';
import 'package:app_agendado/Telas/WidgetEvento.dart';
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

  @override
  void initState() {
    _events.clear();
    _dataToList();
    super.initState();
  }

  mapConverter(List<Evento> lista) {
    Map<DateTime, List<dynamic>> map = new Map();
    for (Evento evento in lista) {
      map.putIfAbsent(evento.data, () => [evento.nome]);
    }
    return map;
  }

  Widget getNextEvent() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('eventos')
            .where('data', isGreaterThan: DateTime.now())
            .orderBy('data')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          Evento evento;

          if (snapshot.hasData) {
            if (snapshot.data.docs.isNotEmpty) {
              evento = Evento(
                  snapshot.data.docs.first.id,
                  snapshot.data.docs.first.get('data').toDate(),
                  snapshot.data.docs.first.get('nome'));
            }

            if (evento != null) {
              return WidgetEvento(
                altura: 60,
                evento: evento,
                listar: false,
              );
            } else {
              return WidgetEvento(
                altura: 60,
                evento: null,
                listar: false,
              );
            }
          } else {
            return WidgetEvento(
              altura: 60,
              evento: null,
              listar: false,
            );
          }
        });
  }

  _dataToList() {
    FirebaseFirestore.instance
        .collection('eventos')
        .snapshots()
        .listen((event) {
      _events.clear();
      setState(() {
        event.docs.forEach((element) {
          if (element['data'].toDate().compareTo(DateTime.now()) == 1) {
            _events.add(
                Evento(element.id, element['data'].toDate(), element['nome']));
          }
        });
      });
    });
  }

  Widget transformDateEvento(DateTime date) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('eventos')
            .where('data', isGreaterThanOrEqualTo: date)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          Evento evento;
          if (snapshot.hasData) {
            evento = Evento(
                snapshot.data.docs.first.id,
                snapshot.data.docs.first.get('data').toDate(),
                snapshot.data.docs.first.get('nome'));

            if (evento != null) {
              return WidgetEvento(
                altura: 60,
                evento: evento,
                listar: true,
              );
            } else {
              return WidgetEvento(
                altura: 60,
                evento: null,
                listar: true,
              );
            }
          } else {
            return WidgetEvento(
              altura: 60,
              evento: null,
              listar: true,
            );
          }
        });
  }

  _openEvento(BuildContext context, DateTime date) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return transformDateEvento(date);
        });
  }

  @override
  Widget build(BuildContext context) {
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
                getNextEvent(),
                TableCalendar(
                  calendarController: _calendarController,
                  events: mapConverter(_events),
                  onDaySelected: (day, events) {
                    return _openEvento(context, day);
                  },
                ),
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
                              builder: (context) => new TelaEventos(),
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
