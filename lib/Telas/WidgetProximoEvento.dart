import 'package:app_agendado/model/Evento.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WidgetProximoEvento extends StatelessWidget {
  final String texto;
  final double largura;
  final double altura;
  Evento _evento;

  WidgetProximoEvento(
      {@required this.texto,
      this.largura = double.infinity,
      @required this.altura,
      @required Evento evento}) {
    _evento = evento;
  }

  @override
  Widget build(BuildContext context) {
    return _evento != null
        ? Container(
            width: largura,
            height: altura,
            alignment: Alignment.center,
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(color: Colors.black, width: 2.0),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2)),
                    child: Text(
                      "${DateFormat('d - MM - yyyy').format(_evento.data)}",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                      child: Text("${_evento.nome}",
                          style: TextStyle(fontSize: 20, color: Colors.white)))
                ]))
        : Container(
            height: altura,
            width: largura,
          );
  }
}
