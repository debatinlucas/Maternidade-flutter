import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:maternidade/entities/medico.dart';
import 'package:maternidade/config/api.dart';

class MedicoPage extends StatefulWidget {
  const MedicoPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MedicoPageState();
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

class _MedicoPageState extends State<MedicoPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<List<MedicoData>> futureMedicos;

  @override
  void initState() {
    super.initState();
    futureMedicos = _fetchMedicos();
  }

  void submit(String action, MedicoData medicoData) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (medicoData.nome == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o nome!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (medicoData.especialidade == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe a especialidade!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (medicoData.celular == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o celular!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else {
        if (action == "adicionar") {
          _adicionarMedico(medicoData);
        } else {
          _editarMedico(medicoData);
        }
      }
    }
  }

  void _adicionarMedico(MedicoData medicoData) async {
    const url = '$baseURL/medicos';
    var body = jsonEncode({
      'nome': medicoData.nome,
      'especialidade': medicoData.especialidade,
      'celular': medicoData.celular
    });
    try {
      final response = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body);
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: 'Médico Adicionado!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            fontSize: 20.0);
      } else {
        Fluttertoast.showToast(
            msg: 'Erro ao inserir o médico!',
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

  void _editarMedico(MedicoData medicoData) async {
    var crm = medicoData.crm;
    var url = '$baseURL/medicos/$crm';
    var body = jsonEncode({
      'nome': medicoData.nome,
      'especialidade': medicoData.especialidade,
      'celular': medicoData.celular
    });
    try {
      final response = await http.put(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body);
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: 'Médico Editado!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            fontSize: 20.0);
      } else {
        Fluttertoast.showToast(
            msg: 'Erro ao editar o médico!',
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

  Future<void> _excluirMedico(int crm) async {
    var url = '$baseURL/medicos/$crm';
    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: 'Médico Excluído!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            fontSize: 20.0);
      } else {
        Fluttertoast.showToast(
            msg: 'Erro ao excluir o médico!',
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

  Future<void> _adicionarOuEditarMedico(MedicoData medicoData) async {
    String action = 'adicionar';
    if (medicoData.crm != null) {
      action = 'editar';
    }
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
                        initialValue: medicoData.nome,
                        onSaved: (String? value) {
                          medicoData.nome = value!;
                        }),
                    TextFormField(
                        scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        decoration: const InputDecoration(
                            hintText: 'Especialidade', labelText: 'Especialidade'),
                        initialValue: medicoData.especialidade,
                        onSaved: (String? value) {
                          medicoData.especialidade = value!;
                        }),
                    TextFormField(
                        scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            hintText: 'Celular', labelText: 'Celular'),
                        initialValue: medicoData.celular,
                        onSaved: (String? value) {
                          medicoData.celular = value!;
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      child: Text(action == 'adicionar' ? 'Adicionar' : 'Editar'),
                      onPressed: () {
                        submit(action, medicoData);
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
        title: const Text('Gerenciar Médicos'),
      ),
      body: Center(
        child: FutureBuilder<List<MedicoData>>(
          future: futureMedicos,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<MedicoData> _medico = snapshot.data!;
              return ListView.builder(
                  itemCount: _medico.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(_medico[index].nome!),
                        subtitle: Text(_medico[index].celular!),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      _adicionarOuEditarMedico(_medico[index])
                                          .whenComplete(() {
                                        setState(() {
                                          futureMedicos = _fetchMedicos();
                                        });
                                      })),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  if (await confirm(
                                    context,
                                    title: const Text('Confirmar Exclusão'),
                                    content: Text(
                                        'Você deseja excluir o médico "' +
                                            _medico[index].nome! +
                                            '"?'),
                                    textOK: const Text('Sim'),
                                    textCancel: const Text('Não'),
                                  )) {
                                    _excluirMedico(_medico[index].crm!)
                                        .whenComplete(() {
                                      setState(() {
                                        futureMedicos = _fetchMedicos();
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
              return const Text("Sem médicos");
            }
            // By default show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),

      // Ícone para dicionar um novo médico
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _adicionarOuEditarMedico(MedicoData()).whenComplete(() {
              setState(() {
                futureMedicos = _fetchMedicos();
              });
            }),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
