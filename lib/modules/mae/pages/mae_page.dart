import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:maternidade/entities/mae.dart';
import 'package:maternidade/config/api.dart';

class MaePage extends StatefulWidget {
  const MaePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MaePageState();
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

class _MaePageState extends State<MaePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<List<MaeData>> futureMaes;

  @override
  void initState() {
    super.initState();
    futureMaes = _fetchMaes();
  }

  void submit(String action, MaeData maeData) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (maeData.nome == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o nome!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (maeData.cep == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o CEP!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (maeData.logradouro == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o logradouro!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (maeData.numero == null) {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o número!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (maeData.bairro == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o bairro!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (maeData.cidade == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe a cidade!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (maeData.fixo == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o fixo!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (maeData.celular == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o celular!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (maeData.comercial == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o comercial!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (maeData.data_nascimento == null) {
        Fluttertoast.showToast(
            msg: 'Por favor, informe a data de nascimento!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else {
        if (action == "adicionar") {
          _adicionarMae(maeData);
        } else {
          _editarMae(maeData);
        }
      }
    }
  }

  void _adicionarMae(MaeData maeData) async {
    const url = '$baseURL/maes';
    var body = jsonEncode({
      'nome': maeData.nome,
      'numero': maeData.numero,
      'cep': maeData.cep,
      'logradouro': maeData.logradouro,
      'bairro': maeData.bairro,
      'cidade': maeData.cidade,
      'fixo': maeData.fixo,
      'celular': maeData.celular,
      'comercial': maeData.comercial,
      'data_nascimento': maeData.data_nascimento.toString().split(" ").first
    });
    try {
      final response = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body);
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: 'Mãe Adicionada!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            fontSize: 20.0);
      } else {
        Fluttertoast.showToast(
            msg: 'Erro ao inserir a mãe!',
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

  void _editarMae(MaeData maeData) async {
    var id = maeData.id;
    var url = '$baseURL/maes/$id';
    var body = jsonEncode({
      'nome': maeData.nome,
      'numero': maeData.numero,
      'cep': maeData.cep,
      'logradouro': maeData.logradouro,
      'bairro': maeData.bairro,
      'cidade': maeData.cidade,
      'fixo': maeData.fixo,
      'celular': maeData.celular,
      'comercial': maeData.comercial,
      'data_nascimento': maeData.data_nascimento.toString().split(" ").first
    });
    try {
      final response = await http.put(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body);
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: 'Mãe Editada!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            fontSize: 20.0);
      } else {
        Fluttertoast.showToast(
            msg: 'Erro ao editar a mãe!',
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

  Future<void> _excluirMae(int id) async {
    var url = '$baseURL/maes/$id';
    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: 'Mãe Excluída!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            fontSize: 20.0);
      } else {
        Fluttertoast.showToast(
            msg: 'Erro ao excluir a mãe!',
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

  Future<void> _adicionarOuEditarMae(MaeData maeData) async {
    String action = 'adicionar';
    if (maeData.id != null) {
      action = 'editar';
    }
    var dfE = DateFormat('dd/MM/yyyy');
    var dfS = DateFormat('yyyy-MM-dd');
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext ctx) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                        scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        decoration: const InputDecoration(
                            hintText: 'Nome', labelText: 'Nome'),
                        initialValue: maeData.nome,
                        onSaved: (String? value) {
                          maeData.nome = value!;
                        }),
                    TextFormField(
                        scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            hintText: 'CEP', labelText: 'CEP'),
                        initialValue: maeData.cep,
                        onSaved: (String? value) {
                          maeData.cep = value!;
                        }),
                    TextFormField(
                        scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        decoration: const InputDecoration(
                            hintText: 'Logradouro', labelText: 'Logradouro'),
                        initialValue: maeData.logradouro,
                        onSaved: (String? value) {
                          maeData.logradouro = value!;
                        }),
                    TextFormField(
                        scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            hintText: 'Número', labelText: 'Número'),
                        initialValue: maeData.numero != null ? maeData.numero.toString() : "",
                        onSaved: (String? value) {
                          maeData.numero = value != "" ? int.parse(value!) : null;
                        }),
                    TextFormField(
                        scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        decoration: const InputDecoration(
                            hintText: 'Bairro', labelText: 'Bairro'),
                        initialValue: maeData.bairro,
                        onSaved: (String? value) {
                          maeData.bairro = value!;
                        }),
                    TextFormField(
                        scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        decoration: const InputDecoration(
                            hintText: 'Cidade', labelText: 'Cidade'),
                        initialValue: maeData.cidade,
                        onSaved: (String? value) {
                          maeData.cidade = value!;
                        }),
                    TextFormField(
                        scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            hintText: 'Fixo', labelText: 'Fixo'),
                        initialValue: maeData.fixo,
                        onSaved: (String? value) {
                          maeData.fixo = value!;
                        }),
                    TextFormField(
                        scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            hintText: 'Celular', labelText: 'Celular'),
                        initialValue: maeData.celular,
                        onSaved: (String? value) {
                          maeData.celular = value!;
                        }),
                    TextFormField(
                        scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            hintText: 'Comercial', labelText: 'Comercial'),
                        initialValue: maeData.comercial,
                        onSaved: (String? value) {
                          maeData.comercial = value!;
                        }),
                    TextFormField(
                        scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        keyboardType: TextInputType.datetime,
                        decoration: const InputDecoration(
                            hintText: 'Data Nascimento', labelText: 'Data Nascimento'),
                        initialValue: maeData.data_nascimento != null ? dfE.format(maeData.data_nascimento!) : "",
                        onSaved: (String? value) {
                          maeData.data_nascimento = value != "" ? dfS.parse(dfS.format(dfE.parse(value!))) : null;
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      child: Text(action == 'adicionar' ? 'Adicionar' : 'Editar'),
                      onPressed: () {
                        submit(action, maeData);
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Mães'),
      ),
      body: Center(
        child: FutureBuilder<List<MaeData>>(
          future: futureMaes,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<MaeData> _mae = snapshot.data!;
              return ListView.builder(
                  itemCount: _mae.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(_mae[index].nome!),
                        subtitle: Text(_mae[index].celular!),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      _adicionarOuEditarMae(_mae[index])
                                          .whenComplete(() {
                                        setState(() {
                                          futureMaes = _fetchMaes();
                                        });
                                      })),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  if (await confirm(
                                    context,
                                    title: const Text('Confirmar Exclusão'),
                                    content: Text(
                                        'Você deseja excluir a mãe "' +
                                            _mae[index].nome! +
                                            '"?'),
                                    textOK: const Text('Sim'),
                                    textCancel: const Text('Não'),
                                  )) {
                                    _excluirMae(_mae[index].id!)
                                        .whenComplete(() {
                                      setState(() {
                                        futureMaes = _fetchMaes();
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
              return const Text("Sem mães");
            }
            // By default show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),

      // Ícone para dicionar uma nova mãe
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _adicionarOuEditarMae(MaeData()).whenComplete(() {
          setState(() {
            futureMaes = _fetchMaes();
          });
        }),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
