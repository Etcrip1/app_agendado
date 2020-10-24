import 'package:app_agendado/Telas/TelaDeletar.dart';
import 'package:app_agendado/Telas/TelaEditar.dart';
import 'package:app_agendado/model/Evento.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../commom/AppColors.dart';

class TelaEventos extends StatefulWidget {
  final List<Evento> eventos;
  final Function function;

  TelaEventos(this.eventos, this.function);

  @override
  _TelaEventosState createState() => _TelaEventosState();

  _openEventoEditor(BuildContext context, Evento e, Function f) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TelaEditar(
            evento: e,
            function: f,
          );
        });
  }

  _openEventoDelete(BuildContext context, Evento e, Function f) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TelaDeletar(
            evento: e,
            function: f,
          );
        });
  }
}

class _TelaEventosState extends State<TelaEventos> {
  orderByName() {
    setState(() {
      widget.eventos.sort((a, b) => a.nome.compareTo(b.nome));
    });
  }

  orderByData() {
    setState(() {
      widget.eventos.sort((a, b) => a.data.compareTo(b.data));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Eventos",
            style: TextStyle(color: AppColors.secondaryColor),
          ),
        ),
        body: Column(children: [
          Card(
            child: Container(
              height: 80,
              child: Column(
                children: [
                  Text("Ordernar"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.calendar_today,
                            size: 50,
                          ),
                          onPressed: () => orderByData()),
                      IconButton(
                          icon: Icon(
                            Icons.text_format,
                            size: 50,
                          ),
                          onPressed: () => orderByName()),
                    ],
                  )
                ],
              ),
            ),
          ),
          Card(
            elevation: 5,
            child: Container(
              height: 430,
              child: ListView(
                children: widget.eventos.map((e) {
                  return FlatButton(
                    onLongPress: () {
                      widget._openEventoDelete(context, e, () => print("ola"));
                    },
                    onPressed: () => widget._openEventoEditor(
                        context, e, () => print("ola")),
                    child: Container(
                      height: 80,
                      width: double.infinity,
                      child: Card(
                        color: AppColors.primaryColor,
                        elevation: 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.secondaryColor,
                                      width: 2)),
                              child: Text(
                                "${DateFormat('d - MM - yyyy').format(e.data)}",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.secondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                                child: Text("${e.nome}",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: AppColors.tertiaryColor)))
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ]));
  }
}
