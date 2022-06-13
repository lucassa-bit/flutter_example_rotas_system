import 'package:cadastrorotas/models/api_response.dart';
import 'package:cadastrorotas/models/usuario.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:cadastrorotas/scripts/download.dart';
import 'package:cadastrorotas/services/relatorio_service.dart';
import 'package:cadastrorotas/services/usuarios_service.dart';
import 'package:flutter/foundation.dart';
import 'package:cadastrorotas/components/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class relatoriosScreen extends StatefulWidget {
  @override
  State<relatoriosScreen> createState() => _relatoriosScreenState();
}

class _relatoriosScreenState extends State<relatoriosScreen> {
  final TextEditingController _textController = TextEditingController();

  var format = DateFormat('dd/MM/yyyy');

  var dataInicial = DateTime.now().subtract(const Duration(days: 7));
  var dataFinal = DateTime.now();

  String url = '';

  relatorioService get instance => GetIt.instance<relatorioService>();
  usuariosService get instanceResponsavel => GetIt.instance<usuariosService>();
  httpOptions get instanceHttp => GetIt.instance<httpOptions>();

  @override
  void initState() {
    _textController.text = 'Link aqui';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resgate de relatório'),
        actions: [
          IconButton(
              icon: const Icon(Icons.date_range_rounded),
              onPressed: () {
                showDateRangePicker(
                  context: context,
                  initialDateRange:
                      DateTimeRange(start: dataInicial, end: dataFinal),
                  firstDate: DateTime(2001),
                  lastDate: DateTime(2222),
                ).then((value) async {
                  dataInicial = value!.start;
                  dataFinal = value.end;
                });
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _downloadType(context, false);
        },
        child: const Icon(Icons.download),
      ),
      body: Background(
          child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: [
            Center(
                child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: TextField(
                      enableInteractiveSelection: false,
                      controller: _textController,
                      decoration: InputDecoration(
                        icon: IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: _copyToClipboard,
                        ),
                      ),
                    ))),
            const Text(
              'Observação: caso, haja algum problema com relação ao botão para baixar o relatório\n'
              'clique no símbolo ao lado da caixa de texto e copie o link em outra janela para\n'
              'poder baixar o arquivo',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      )),
    );
  }

  Future<bool> _downloadType(context, bool isToCopy) async {
    bool returnValor = false;
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.event_available),
                    title: const Text('Aprovadas'),
                    onTap: () async {
                      if (isToCopy) {
                        _textController.text = await createURL(true);
                        Navigator.of(context).pop();
                      } else {
                        url = await createURL(true);
                        await downloadExcel(
                            "Relatório de rotas aprovadas - $dataInicial - $dataFinal");
                      }
                      if (kIsWeb && !isToCopy) Navigator.of(context).pop();
                      returnValor = true;
                    }),
                ListTile(
                  leading: const Icon(Icons.event_note),
                  title: const Text('Não aprovadas e aprovadas'),
                  onTap: () async {
                    if (isToCopy) {
                      _textController.text = await createURL(false);
                      Navigator.of(context).pop();
                    } else {
                      url = await createURL(false);
                      await downloadExcel(
                          "Relatório de rotas - $dataInicial - $dataFinal");
                    }
                    if (kIsWeb && !isToCopy) Navigator.of(context).pop();
                    returnValor = true;
                  },
                ),
                if(instanceHttp.cargo == 'Administrador')
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('aprovadas por responsável'),
                  onTap: () async {
                    if (isToCopy) {
                      _textController.text = await createURLByFuncionario();
                      Navigator.of(context).pop();
                    } else {
                      if (kIsWeb ||
                          await Permission.storage.request().isGranted) {
                        url = await createURLByFuncionario();
                        await downloadExcel(
                            "relatório funcionarios $dataInicial - $dataFinal");
                      }
                    }
                    if (kIsWeb && !isToCopy) Navigator.of(context).pop();
                    returnValor = true;
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.abc_rounded),
                  title: const Text('Resumo aprovadas'),
                  onTap: () async {
                    if (isToCopy) {
                      _textController.text = await createURLResumo();
                      Navigator.of(context).pop();
                    } else {
                      url = await createURLResumo();
                      await downloadExcel(
                          "Relatório resumido das rotas - $dataInicial - $dataFinal");
                    }
                    if (kIsWeb && !isToCopy) Navigator.of(context).pop();
                    returnValor = true;
                  },
                ),
              ],
            ),
          );
        });
    return returnValor;
  }

  // This function is triggered when the copy icon is pressed
  Future<void> _copyToClipboard() async {
    bool response = await _downloadType(context, true);
    if (response) {
      await Clipboard.setData(ClipboardData(text: _textController.text));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Copiado'),
      ));
    }
  }

  Future<String> createURL(bool isForAprovado) async {
    var responseToken =
        await instance.generateTemporaryToken(instanceHttp.token);
    return 'https://aedrotas.herokuapp.com/api/relatorio?'
        'data_inicial=${format.format(dataInicial)}&'
        'data_final=${format.format(dataFinal)}&'
        'temporaryToken=${responseToken.data}&'
        'isForAprovado=$isForAprovado';
  }

  Future<String> createURLResumo() async {
    var responseToken =
        await instance.generateTemporaryToken(instanceHttp.token);
    return 'https://aedrotas.herokuapp.com/api/relatorio/resumo?'
        'data_inicial=${format.format(dataInicial)}&'
        'data_final=${format.format(dataFinal)}&'
        'temporaryToken=${responseToken.data}';
  }

  Future<String> createURLByFuncionario() async {
    var responseToken =
        await instance.generateTemporaryToken(instanceHttp.token);
    return 'https://aedrotas.herokuapp.com/api/relatorio/funcionario?'
        'data_inicial=${format.format(dataInicial)}&'
        'data_final=${format.format(dataFinal)}&'
        'temporaryToken=${responseToken.data}&';
  }

  downloadExcel(String filename) async {
    if (kIsWeb || await Permission.storage.request().isGranted) {
      if (url.isNotEmpty) {
        await _downloadFile(filename);
      }
    }
  }

  Future<void> _downloadFile(String filename) async {
    DownloadService downloadService =
        kIsWeb ? WebDownloadService() : MobileDownloadService();
    await downloadService.download(
        url: url, context: context, fileName: filename);
  }
}
