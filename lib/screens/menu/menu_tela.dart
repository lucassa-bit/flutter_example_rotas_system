import 'package:cadastrorotas/components/navigation_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:cadastrorotas/components/background.dart';

class MenuScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(title: Text('Tela inicial'),),
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 130),
            ),
          ],
        ),
      ),
    );
  }
}
