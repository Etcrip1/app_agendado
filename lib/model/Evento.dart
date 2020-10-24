class Evento {
  final String _id;
  DateTime _data;
  String _nome;

  Evento(this._id, this._data, this._nome);

  String get id {
    return _id;
  }

  String get nome {
    return _nome;
  }

  get getEvento => null;

  void set nome(String nome) {
    _nome = nome;
  }

  DateTime get data {
    return _data;
  }

  void set data(DateTime data) {
    _data = data;
  }
}
