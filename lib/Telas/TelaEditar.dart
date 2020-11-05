import 'package:app_agendado/Telas/TelaPrincipal.dart';
import 'package:app_agendado/model/Evento.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "../model/Evento.dart";
import "package:intl/intl.dart";
import '../commom/AppColors.dart';

class TelaEditar extends StatefulWidget {
  final Evento evento;

  const TelaEditar({this.evento});

  @override
  _TelaEditarState createState() => _TelaEditarState();
}

class _TelaEditarState extends State<TelaEditar> {
  DateTime _dataEvento;
  TimeOfDay _horaEvento;
  DateTime _adicionarEvento;
  var _controller = TextEditingController();

  Future<void> updateFromDatabase(String nome, DateTime data) {
    CollectionReference eventos =
        FirebaseFirestore.instance.collection('eventos');
    return eventos
        .doc(widget.evento.id)
        .update({'data': data, 'nome': nome})
        .then((value) => print("Evento Updated ${widget.evento.id}"))
        .catchError((error) => print("Failed to update event: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    color: AppColors.primaryColor,
                    width: double.infinity,
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          widget.evento.nome,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.tertiaryColor),
                        ),
                        Text(
                          DateFormat("d - MM - yyyy")
                              .format(widget.evento.data),
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.tertiaryColor),
                        )
                      ],
                    )),
                TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Novo nome',
                    )),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: FlatButton(
                      child: Icon(
                        Icons.date_range,
                        size: 100,
                      ),
                      onPressed: () async {
                        _dataEvento = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2018),
                            lastDate: DateTime(2050));
                        setState(() {
                          _dataEvento = _dataEvento;
                        });
                        _horaEvento = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (_dataEvento != null && _horaEvento != null) {
                          setState(() {
                            _adicionarEvento = DateTime(
                                _dataEvento.year,
                                _dataEvento.month,
                                _dataEvento.day,
                                _horaEvento.hour,
                                _horaEvento.minute);
                          });
                        }
                      }),
                ),
                Container(
                  alignment: Alignment.center,
                  child: _dataEvento != null
                      ? Text(
                          DateFormat("d - MM - yyyy").format(_dataEvento),
                        )
                      : Text(
                          "Insira a nova data",
                          style: TextStyle(),
                        ),
                ),
                Container(
                    margin: EdgeInsets.all(25),
                    alignment: Alignment.center,
                    child: FlatButton(
                      onPressed: () {
                        if (_controller.text.isEmpty) {
                          setState(() {
                            _controller.text = widget.evento.nome;
                          });
                        }

                        if (_adicionarEvento == null) {
                          setState(() {
                            _adicionarEvento = widget.evento.data;
                          });
                        }
                        updateFromDatabase(_controller.text, _adicionarEvento);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TelaPrincipal()));
                      },
                      color: AppColors.primaryColor,
                      child: Text(
                        "Confirmar",
                        style: TextStyle(
                            color: AppColors.tertiaryColor, fontSize: 24),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
