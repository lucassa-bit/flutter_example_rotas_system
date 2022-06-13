import 'package:cadastrorotas/options/http_options.dart';
import 'package:cadastrorotas/screens/controle_usuario/tela_inicial.dart';
import 'package:cadastrorotas/screens/login/login.dart';
import 'package:cadastrorotas/screens/prefabs/prefabsScreen.dart';
import 'package:cadastrorotas/screens/relatorio/relatorios_screen.dart';
import 'package:cadastrorotas/screens/servicos_cadastrados/mostrar_servicos_cadastrados_funcionario.dart';
import 'package:cadastrorotas/screens/servicos_cadastrados/mostrar_servicos_cadastrados_gerente.dart';
import 'package:cadastrorotas/screens/servicos_concluidos/mostrar_servicos_concluidos.dart';
import 'package:cadastrorotas/screens/servicos_extras/escolher_cadastro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cadastrorotas/screens/cadastrar_rotas/cadastrar.dart';
import 'package:get_it/get_it.dart';

class NavigationDrawerWidget extends StatelessWidget {
  httpOptions get instanceHttp => GetIt.instance<httpOptions>();

  final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Color.fromRGBO(52, 140, 227, 1),
        child: ListView(
          padding: padding,
          children: <Widget>[
            BuildHeader(
              name: instanceHttp.nome,
              cargo: instanceHttp.cargo,
            ),
            if (instanceHttp.cargo == 'Administrador' ||
                instanceHttp.cargo == 'Gerente externo')
              buildMenuItem(
                  text: 'Cadastrar rotas',
                  icon: Icons.addchart,
                  onClicked: () => selectedItem(context, 1)),
            if (instanceHttp.cargo == 'Administrador' ||
                instanceHttp.cargo == 'Gerente externo')
              const SizedBox(height: 16),
            if (instanceHttp.cargo == 'Responsavel interno')
              buildMenuItem(
                  text: 'Cadastrar manifesto',
                  icon: Icons.article_outlined,
                  onClicked: () => selectedItem(context, 2)),
            if (instanceHttp.cargo == 'Responsavel interno')
              const SizedBox(height: 16),
            if (instanceHttp.cargo == 'Administrador' ||
                instanceHttp.cargo == 'Gerente externo')
              buildMenuItem(
                  text: 'Aprovar rotas',
                  icon: Icons.assignment_turned_in_outlined,
                  onClicked: () => selectedItem(context, 3)),
            if (instanceHttp.cargo == 'Administrador' ||
                instanceHttp.cargo == 'Gerente externo')
              const SizedBox(height: 16),
            if (instanceHttp.cargo == 'Administrador')
              buildMenuItem(
                  text: 'Rotas concluídas',
                  icon: Icons.view_list_rounded,
                  onClicked: () => selectedItem(context, 4)),
            if (instanceHttp.cargo == 'Administrador')
              const SizedBox(height: 16),
            if (instanceHttp.cargo == 'Administrador')
              buildMenuItem(
                  text: 'Cadastro de extras',
                  icon: Icons.add_business_rounded,
                  onClicked: () => selectedItem(context, 5)),
            if (instanceHttp.cargo == 'Administrador')
              const SizedBox(height: 16),
            if (instanceHttp.cargo == 'Administrador')
              buildMenuItem(
                  text: 'Controle de usuários',
                  icon: Icons.supervised_user_circle_sharp,
                  onClicked: () => selectedItem(context, 6)),
            if (instanceHttp.cargo == 'Administrador')
              const SizedBox(height: 16),
            if (instanceHttp.cargo == 'Administrador' ||
                instanceHttp.cargo == 'Gerente externo')
              buildMenuItem(
                  text: 'Solicitação de relatório',
                  icon: Icons.assignment,
                  onClicked: () => selectedItem(context, 7)),
            if (instanceHttp.cargo == 'Administrador' ||
                instanceHttp.cargo == 'Gerente externo')
              const SizedBox(height: 16),
            if (instanceHttp.cargo == 'Administrador' ||
                instanceHttp.cargo == 'Gerente externo')
              buildMenuItem(
                  text: 'Cadastro de presets',
                  icon: Icons.addchart,
                  onClicked: () => selectedItem(context, 8)),
            if (instanceHttp.cargo == 'Administrador' ||
                instanceHttp.cargo == 'Gerente externo')
              const SizedBox(height: 16),
            Divider(
              color: Colors.white70,
              thickness: 2,
            ),
            const SizedBox(height: 24),
            buildMenuItem(
                text: 'logout',
                icon: Icons.logout,
                onClicked: () => selectedItem(context, 9)),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget BuildHeader({required String name, required String cargo}) => InkWell(
        onTap: () {},
        child: Container(
          padding:
              padding.add(EdgeInsets.symmetric(vertical: 50, horizontal: -20)),
          child: Row(children: <Widget>[
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage("assets/images/avatar.png"),
            ),
            SizedBox(width: 20),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    cargo,
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ]),
        ),
      );

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 1:
        {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => cadastrarRotas()));
        }
        break;
      case 2:
        {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => mostrarCadastrarManifesto()));
        }
        break;
      case 3:
        {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => mostrarAprovarRota()));
        }
        break;
      case 4:
        {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MostrarRotasConcluidas()));
        }
        break;
      case 5:
        {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => escolherCadastro()));
        }
        break;
      case 6:
        {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => telaInicial()));
        }
        break;
      case 7:
        {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => relatoriosScreen()));
        }
        break;
      case 8:
        {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => prefabsScreen()));
        }
        break;
      case 9:
        {
          instanceHttp.deleteToken();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false);
        }
        break;
    }
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white70;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        text,
        style: TextStyle(color: color),
      ),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }
}
