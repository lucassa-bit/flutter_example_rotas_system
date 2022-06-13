import 'package:cadastrorotas/components/background.dart';
import 'package:cadastrorotas/components/cadastrar_servicos_extras/multi_form.dart';
import 'package:cadastrorotas/models/rotas.dart';
import 'package:cadastrorotas/models/servicos_extras.dart';
import 'package:cadastrorotas/screens/servicos_extras/cadastrar_rotas_extras.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/cadastrar_rotas_extras/multi_form.dart';
import 'cadastrar_servicos_extras.dart';

class escolherCadastro extends StatefulWidget {
  const escolherCadastro({Key? key}) : super(key: key);

  @override
  State<escolherCadastro> createState() => _escolherCadastroState();
}

class _escolherCadastroState extends State<escolherCadastro> {
  var format = DateFormat('dd/MM/yyyy');
  var dataInicial = DateTime.now().subtract(const Duration(days: 7));
  var dataFinal = DateTime.now();
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_selectedIndex == 0 ? 'Rota extra' : 'Serviço extra'),
          actions: [
            IconButton(
                icon: const Icon(Icons.date_range_rounded),
                onPressed: () {
                  showDateRangePicker(
                    helpText: 'Escolha o período de emissões',
                    context: context,
                    initialDateRange:
                        DateTimeRange(start: dataInicial, end: dataFinal),
                    firstDate: DateTime(2001),
                    lastDate: DateTime(2222),
                  ).then((value) async {
                    dataInicial = value!.start;
                    dataFinal = value.end;

                    setState(() {
                      _selectedIndex = _selectedIndex == 1 ? 0 : 1;
                    });
                    await Future.delayed(const Duration(milliseconds: 100));
                    setState(() {
                      _selectedIndex = _selectedIndex == 1 ? 0 : 1;
                    });
                  });
                })
          ],
        ),
        floatingActionButton: FloatingActionButton(
          hoverColor: Colors.grey,
          backgroundColor: Colors.grey,
          onPressed: () {
            if (_selectedIndex == 0) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MultiFormRotaExtra(Rotas()))).then((value) async{
                setState(() {
                  _selectedIndex = _selectedIndex == 1 ? 0 : 1;
                });
                await Future.delayed(const Duration(milliseconds: 100));
                setState(() {
                  _selectedIndex = _selectedIndex == 1 ? 0 : 1;
                });
              });
            } else {
              Navigator.of(context).push(MaterialPageRoute(
                 builder: (context) => MultiFormServicosExtras(ServicosExtras()))).then((_) async{
                setState(() {
                  _selectedIndex = _selectedIndex == 1 ? 0 : 1;
                });
                await Future.delayed(const Duration(milliseconds: 100));
                setState(() {
                  _selectedIndex = _selectedIndex == 1 ? 0 : 1;
                });
              });
            }
          },
          tooltip:
              _selectedIndex == 1 ? 'Criar serviço extra' : 'Criar rota extra',
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Background(
            child: _selectedIndex == 1
                ? cadastrarServicosExtras(
                    dataFinal: format.format(dataFinal),
                    dataInicial: format.format(dataInicial),
                  )
                : cadastrarRotasExtras(
                    dataFinal: format.format(dataFinal),
                    dataInicial: format.format(dataInicial),
                  )),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.call_split),
              label: 'Rotas extras',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_repair_service),
              label: 'Servicos extras',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
