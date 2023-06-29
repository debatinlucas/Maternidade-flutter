import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:maternidade/entities/bebe.dart';
import 'package:maternidade/entities/medico.dart';
import 'package:maternidade/entities/mae.dart';
import 'package:maternidade/config/api.dart';

class BebePage extends StatefulWidget {
  const BebePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BebePageState();
}

Future<List<BebeData>> _fetchBebes() async {
  const url = '$baseURL/bebes?limit=10&offset=0';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    List jsonResponse = jsonDecode(utf8.decode(response.bodyBytes))['data'];
    return jsonResponse
        .map((bebe) => BebeData.fromJson(bebe))
        .toList();
  } else {
    Fluttertoast.showToast(
        msg: 'Erro ao listar os bebês!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        fontSize: 20.0);
    throw ('Sem bebês');
  }
}

Future<MaeData> _fetchMaeById(int id) async {
  var url = '$baseURL/maes/$id';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    return MaeData.fromJson(jsonResponse);
  } else {
    Fluttertoast.showToast(
        msg: 'Erro ao listar a mãe!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        fontSize: 20.0);
    throw ('Sem mãe');
  }
}

Future<List<MaeData>> _fetchMaes() async {
  const url = '$baseURL/maes?limit=10&offset=0';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    List jsonResponse = jsonDecode(utf8.decode(response.bodyBytes))['data'];
    return jsonResponse
        .map((mae) => MaeData.fromJson(mae))
        .toList();
  } else {
    Fluttertoast.showToast(
        msg: 'Erro ao listar as mães!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        fontSize: 20.0);
    throw ('Sem mães');
  }
}

Future<List<MedicoData>> _fetchMedicos() async {
  const url = '$baseURL/medicos?limit=10&offset=0';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    List jsonResponse = jsonDecode(utf8.decode(response.bodyBytes))['data'];
    return jsonResponse
        .map((medico) => MedicoData.fromJson(medico))
        .toList();
  } else {
    Fluttertoast.showToast(
        msg: 'Erro ao listar os médicos!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        fontSize: 20.0);
    throw ('Sem médicos');
  }
}

class _BebePageState extends State<BebePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<List<BebeData>> futureBebes;

  @override
  void initState() {
    super.initState();
    futureBebes = _fetchBebes();
  }

  void submit(String action, BebeData bebeData) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (bebeData.id_mae == null) {
        Fluttertoast.showToast(
            msg: 'Por favor, informe a mãe!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (bebeData.crm_medico == null) {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o médico!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (bebeData.nome == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o nome!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (bebeData.altura == null) {
        Fluttertoast.showToast(
            msg: 'Por favor, informe a altura!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (bebeData.peso == null) {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o peso!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (bebeData.data_nascimento == null) {
        Fluttertoast.showToast(
            msg: 'Por favor, informe a data de nascimento!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else {
        if (action == "adicionar") {
          _adicionarBebe(bebeData);
        } else {
          _editarBebe(bebeData);
        }
      }
    }
  }

  void _adicionarBebe(BebeData bebeData) async {
    const url = '$baseURL/bebes';
    var body = jsonEncode({
      'nome': bebeData.nome,
      'id_mae': bebeData.id_mae,
      'crm_medico': bebeData.crm_medico,
      'altura': bebeData.altura,
      'peso': bebeData.peso,
      'data_nascimento': bebeData.data_nascimento.toString().split(" ").first
    });
    try {
      final response = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body);
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: 'Bebê Adicionado!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            fontSize: 20.0);
      } else {
        Fluttertoast.showToast(
            msg: 'Erro ao inserir o bebê!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      }
    } on Object catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  void _editarBebe(BebeData bebeData) async {
    var id = bebeData.id;
    var url = '$baseURL/bebes/$id';
    var body = jsonEncode({
      'id_mae': bebeData.id_mae,
      'crm_medico': bebeData.crm_medico,
      'nome': bebeData.nome,
      'altura': bebeData.altura,
      'peso': bebeData.peso,
      'data_nascimento': bebeData.data_nascimento.toString().split(" ").first
    });
    try {
      final response = await http.put(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body);
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: 'Bebê Editado!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            fontSize: 20.0);
      } else {
        Fluttertoast.showToast(
            msg: 'Erro ao editar o bebê!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      }
    } on Object catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> _excluirBebe(int id) async {
    var url = '$baseURL/bebes/$id';
    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: 'Bebê Excluído!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            fontSize: 20.0);
      } else {
        Fluttertoast.showToast(
            msg: 'Erro ao excluir o bebê!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      }
    } on Object catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> _adicionarOuEditarBebe(BebeData bebeData) async {
    String action = 'adicionar';
    if (bebeData.id != null) {
      action = 'editar';
    }
    var dfE = DateFormat('dd/MM/yyyy');
    var dfS = DateFormat('yyyy-MM-dd');
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext ctx) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FutureBuilder(
                          future: Future.delayed(const Duration(seconds: 1))
                              .then((value) => _fetchMaes()),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              final List<MaeData> _maes = snapshot.data;
                              return DropdownButton<String>(
                                onChanged: (String? value) {
                                  setState(() {
                                    bebeData.id_mae = int.parse(value.toString());
                                  });
                                },
                                items: _maes.map((map) {
                                  return DropdownMenuItem(
                                    child: Text(map.nome!),
                                    value: map.id.toString(),
                                  );
                                }).toList(),
                                value: bebeData.id_mae?.toString(),
                                hint: const Text('Selecione uma mãe'),
                                isExpanded: true
                              );
                            } else {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    CircularProgressIndicator(),
                                    Text('Carregando mães'),
                                  ],
                                ),
                              );
                            }
                          }),
                      FutureBuilder(
                          future: Future.delayed(const Duration(seconds: 1))
                              .then((value) => _fetchMedicos()),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              final List<MedicoData> _medicos = snapshot.data;
                              return DropdownButton<String>(
                                onChanged: (String? value) {
                                  setState(() {
                                    bebeData.crm_medico = int.parse(value.toString());
                                  });
                                },
                                items: _medicos.map((map) {
                                  return DropdownMenuItem(
                                    child: Text(map.nome!),
                                    value: map.crm.toString(),
                                  );
                                }).toList(),
                                value: bebeData.crm_medico?.toString(),
                                hint: const Text('Selecione um médico'),
                                isExpanded: true
                              );
                            } else {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    CircularProgressIndicator(),
                                    Text('Carregando médicos'),
                                  ],
                                ),
                              );
                            }
                          }),
                      TextFormField(
                          scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                          decoration: const InputDecoration(
                              hintText: 'Nome', labelText: 'Nome'),
                          initialValue: bebeData.nome,
                          onSaved: (String? value) {
                            bebeData.nome = value!;
                          }),
                      TextFormField(
                          scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              hintText: 'Altura', labelText: 'Altura'),
                          initialValue: bebeData.altura != null ? bebeData.altura.toString() : "",
                          onSaved: (String? value) {
                            bebeData.altura = value != "" ? int.parse(value!) : null;
                          }),
                      TextFormField(
                          scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              hintText: 'Peso', labelText: 'Peso'),
                          initialValue: bebeData.peso != null ? bebeData.peso.toString() : "",
                          onSaved: (String? value) {
                            bebeData.peso = value != "" ? double.parse(value!) : null;
                          }),
                      TextFormField(
                          scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                          keyboardType: TextInputType.datetime,
                          decoration: const InputDecoration(
                              hintText: 'Data Nascimento', labelText: 'Data Nascimento'),
                          initialValue: bebeData.data_nascimento != null ? dfE.format(bebeData.data_nascimento!) : "",
                          onSaved: (String? value) {
                            bebeData.data_nascimento = value != "" ? dfS.parse(dfS.format(dfE.parse(value!))) : null;
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        child: Text(action == 'adicionar' ? 'Adicionar' : 'Editar'),
                        onPressed: () {
                          submit(action, bebeData);
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Bebês'),
      ),
      body: Center(
        child: FutureBuilder<List<BebeData>>(
          future: futureBebes,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<BebeData> _bebe = snapshot.data!;
              return ListView.builder(
                  itemCount: _bebe.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(_bebe[index].nome!),
                        subtitle: FutureBuilder(
                            future: Future.delayed(const Duration(seconds: 1))
                                .then((value) => _fetchMaeById(_bebe[index].id_mae!)),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                final MaeData _mae = snapshot.data;
                                return Text(_mae.nome!);
                              } else {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    CircularProgressIndicator()
                                  ],
                                );
                              }
                            }),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      _adicionarOuEditarBebe(_bebe[index])
                                          .whenComplete(() {
                                        setState(() {
                                          futureBebes = _fetchBebes();
                                        });
                                      })),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  if (await confirm(
                                    context,
                                    title: const Text('Confirmar Exclusão'),
                                    content: Text(
                                        'Você deseja excluir o bebê "' +
                                            _bebe[index].nome! +
                                            '"?'),
                                    textOK: const Text('Sim'),
                                    textCancel: const Text('Não'),
                                  )) {
                                    _excluirBebe(_bebe[index].id!)
                                        .whenComplete(() {
                                      setState(() {
                                        futureBebes = _fetchBebes();
                                      });
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return const Text("Sem bebês");
            }
            // By default show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),

      // Ícone para dicionar um novo bebê
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _adicionarOuEditarBebe(BebeData()).whenComplete(() {
              setState(() {
                futureBebes = _fetchBebes();
              });
            }),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
