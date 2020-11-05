import 'package:app_agendado/Telas/TelaDeletar.dart';
import 'package:app_agendado/Telas/TelaEditar.dart';
import 'package:app_agendado/model/Evento.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WidgetEvento extends StatelessWidget {
  final double largura;
  final double altura;
  final Evento evento;
  final bool listar;

  WidgetEvento(
      {this.largura = double.infinity,
      @required this.altura,
      @required this.evento,
      @required this.listar});

  _openEventoEditor(BuildContext context, Evento e) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TelaEditar(
            evento: e,
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

  Future<void> deleteFromDatabase() {
    CollectionReference eventos =
        FirebaseFirestore.instance.collection('eventos');
    return eventos
        .doc(evento.id)
        .delete()
        .then((value) => print("Evento Deleted ${evento.id}"))
        .catchError((error) => print("Failed to delete event: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return evento != null
        ? FlatButton(
            onPressed: () => _openEventoEditor(context, evento),
            onLongPress: () =>
                _openEventoDelete(context, evento, deleteFromDatabase),
            child: listar
                ? Container(
                    width: largura,
                    height: altura,
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(color: Colors.black, width: 2.0),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 2)),
                            child: Text(
                              "${DateFormat('d - MM - yyyy - HH:mm:ss').format(evento.data)}",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                              child: Text("${evento.nome}",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white)))
                        ]))
                : Container(
                    width: largura,
                    height: altura,
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(color: Colors.black, width: 2.0),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 2)),
                            child: Text(
                              "${DateFormat('d - MM - yyyy').format(evento.data)}",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                              child: Text("${evento.nome}",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white)))
                        ])),
          )
        : Container(
            width: largura,
            height: altura,
            alignment: Alignment.center,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(color: Colors.black, width: 2.0),
            ),
            child: Text("Você não possuí nenhum evento marcado",
                style: TextStyle(fontSize: 20, color: Colors.white)));
  }
}
