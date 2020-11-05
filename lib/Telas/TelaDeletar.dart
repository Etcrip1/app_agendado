import 'package:app_agendado/Telas/TelaPrincipal.dart';
import 'package:app_agendado/model/Evento.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../commom/AppColors.dart';

class TelaDeletar extends StatelessWidget {
  final Function function;
  final Evento evento;

  TelaDeletar({@required this.function, @required this.evento});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                color: AppColors.primaryColor,
                width: double.infinity,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      evento.nome,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.tertiaryColor),
                    ),
                    Text(
                      DateFormat("d - MM - yyyy").format(evento.data),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                  ],
                )),
            Text(
              "Você deseja deletar o evento selecionado?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: EdgeInsets.all(40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FlatButton(
                    color: AppColors.primaryColor,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TelaPrincipal()));
                      return function();
                    },
                    child: Container(
                      child: Text(
                        "Confirmar",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  FlatButton(
                    color: AppColors.primaryColor,
                    onPressed: () => Navigator.pop(context),
                    child: Container(
                      child: Text(
                        "Cancelar",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
