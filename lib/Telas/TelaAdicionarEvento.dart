import 'package:app_agendado/Telas/TelaPrincipal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../commom/AppColors.dart';
import 'package:intl/intl.dart';

class TelaAdicionarEvento extends StatefulWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference eventos =
      FirebaseFirestore.instance.collection('eventos');

  Future<void> addEvento(String nome, DateTime data, BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TelaPrincipal()));
    return eventos
        .add({'nome': nome, 'data': data})
        .then((value) => print("Event Added"))
        .catchError((error) => print("Failed to add event: $error"));
  }

  @override
  _TelaAdicionarEventoState createState() => _TelaAdicionarEventoState();
}

class _TelaAdicionarEventoState extends State<TelaAdicionarEvento> {
  DateTime _dataEvento;
  TimeOfDay _horaEvento;
  DateTime _adicionarEvento;
  var _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Adicionar",
            style: TextStyle(color: AppColors.secondaryColor),
          ),
        ),
        body: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'Nome do evento',
                          )),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 160, 0, 0),
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
                    child: _adicionarEvento != null
                        ? Text(
                            DateFormat("d - MM - yyyy")
                                .format(_adicionarEvento),
                            style: TextStyle(fontSize: 18),
                          )
                        : Text("")),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 180, 0, 0),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: RaisedButton(
                      child: Text("Confirmar",
                          style: TextStyle(
                              color: AppColors.secondaryColor, fontSize: 24)),
                      color: Colors.blue,
                      onPressed: () => widget.addEvento(
                          _controller.text, _adicionarEvento, context)),
                )
              ],
            ),
          ),
        ));
  }
}
