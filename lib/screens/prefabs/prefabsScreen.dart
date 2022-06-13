import 'package:cadastrorotas/components/background.dart';
import 'package:cadastrorotas/components/cadastrar_caminhao/multi_form.dart';
import 'package:cadastrorotas/components/cadastrar_motoristas/multi_form.dart';
import 'package:cadastrorotas/components/cadastrar_numero_rota/multi_form.dart';
import 'package:cadastrorotas/models/caminhao.dart';
import 'package:cadastrorotas/models/motorista.dart';
import 'package:cadastrorotas/models/numero_rotas.dart';
import 'package:cadastrorotas/screens/prefabs/cadastrar_caminhoes.dart';
import 'package:cadastrorotas/screens/prefabs/cadastrar_motorista.dart';
import 'package:cadastrorotas/screens/prefabs/cadastrar_numero_rota.dart';
import 'package:flutter/material.dart';

class prefabsScreen extends StatefulWidget {
  const prefabsScreen({Key? key}) : super(key: key);

  @override
  State<prefabsScreen> createState() => _prefabsScreenState();
}

class _prefabsScreenState extends State<prefabsScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar prefabs'),
      ),
      bottomNavigationBar: BottomNavigationBar(items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.perm_contact_cal_sharp),
          label: 'Motorista',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.call_split_rounded),
          label: 'Número de rotas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.airport_shuttle),
          label: 'Caminhão',
        ),
      ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        hoverColor: Colors.grey,
        backgroundColor: Colors.grey,
        onPressed: () {
          if (_selectedIndex == 0) {
            Navigator.of(context).push(MaterialPageRoute(
               builder: (context) => MultiFormMotorista(Motorista()))).then((value) async{
              setState(() {
                _selectedIndex = _selectedIndex == 1 ? 0 : 1;
              });
              await Future.delayed(const Duration(milliseconds: 300));
              setState(() {
                _selectedIndex = _selectedIndex == 1 ? 0 : 1;
              });
            });
          } else if(_selectedIndex == 1) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MultiFormNumeroRotas(NumeroRotas()))).then((value) async{
              setState(() {
                _selectedIndex = _selectedIndex == 1 ? 0 : 1;
              });
              await Future.delayed(const Duration(milliseconds: 300));
              setState(() {
                _selectedIndex = _selectedIndex == 1 ? 0 : 1;
              });
            });
          } else if(_selectedIndex == 2) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MultiFormCaminhao(Caminhao()))).then((value) async{
              setState(() {
                _selectedIndex = _selectedIndex == 1 ? 2 : 1;
              });
              await Future.delayed(const Duration(milliseconds: 300));
              setState(() {
                _selectedIndex = _selectedIndex == 1 ? 2 : 1;
              });
            });
          }
        },
        tooltip: 'Criar novo usuário',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Background(
          child: _selectedIndex == 0
      ? const CadastrarMotoristas() : _selectedIndex == 1 ? const CadastrarNumeroRotas() :
        CadastrarCaminhoes(),
    ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}