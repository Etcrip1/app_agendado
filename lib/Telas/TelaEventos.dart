import 'package:app_agendado/Telas/TelaAdicionarEvento.dart';
import 'package:app_agendado/Telas/WidgetEvento.dart';
import 'package:app_agendado/model/Evento.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../commom/AppColors.dart';

class TelaEventos extends StatefulWidget {
  TelaEventos();

  @override
  _TelaEventosState createState() => _TelaEventosState();
}

class _TelaEventosState extends State<TelaEventos> {
  bool ordenar;

  _generateWidgetEventosOrderByDate() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('eventos')
            .where('data', isGreaterThan: DateTime.now())
            .orderBy('data')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<Widget> list = [];
          if (snapshot.hasData) {
            snapshot.data.docs.forEach((element) {
              list.add(WidgetEvento(
                  listar: false,
                  altura: 60,
                  evento: Evento(
                      element.id, element['data'].toDate(), element['nome'])));
            });

            if (list.isEmpty)
              return _generateAddButton();
            else
              return Column(children: list);
          } else {
            return Container();
          }
        });
  }

  _generateWidgetEventosOrderByName() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('eventos')
            .where('data', isGreaterThan: DateTime.now())
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<Widget> list = [];
          List<Evento> list2 = [];
          if (snapshot.hasData) {
            snapshot.data.docs.forEach((element) {
              list2.add(Evento(
                  element.id, element['data'].toDate(), element['nome']));
            });

            list2.sort((x, y) {
              return x.nome.toLowerCase().compareTo(y.nome.toLowerCase());
            });

            for (Evento evento in list2) {
              list.add(WidgetEvento(listar: false, altura: 60, evento: evento));
            }

            if (list2.isEmpty)
              return _generateAddButton();
            else
              return Column(children: list);
          } else {
            return Container();
          }
        });
  }

  _generateAddButton() {
    return Container(
      child: Column(children: [
        SizedBox(height: 220),
        Center(
          child: IconButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TelaAdicionarEvento(),
                )),
            icon: Icon(
              Icons.add,
              size: 60,
            ),
          ),
        ),
      ]),
    );
  }

  @override
  void initState() {
    setState(() {
      ordenar = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Eventos",
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
                        onPressed: () {
                          setState(() {
                            ordenar = false;
                          });
                        },
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.text_format,
                            size: 50,
                          ),
                          onPressed: () {
                            setState(() {
                              ordenar = true;
                            });
                          }),
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
              child: SingleChildScrollView(
                  child: ordenar
                      ? _generateWidgetEventosOrderByName()
                      : _generateWidgetEventosOrderByDate()),
            ),
          )
        ]));
  }
}
