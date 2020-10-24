import 'package:app_agendado/model/Evento.dart';
import 'package:flutter/material.dart';
import "../model/Evento.dart";
import "package:intl/intl.dart";
import '../commom/AppColors.dart';

class TelaEditar extends StatefulWidget {
  final Evento evento;
  final Function function;

  const TelaEditar({this.evento, this.function});

  @override
  _TelaEditarState createState() => _TelaEditarState();
}

class _TelaEditarState extends State<TelaEditar> {
  DateTime _dataEvento;
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
                      onPressed: () => print("ola"),
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
