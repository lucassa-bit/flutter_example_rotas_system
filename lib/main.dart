import 'dart:ui';

import 'package:cadastrorotas/options/http_options.dart';
import 'package:cadastrorotas/screens/menu/boas_vindas.dart';
import 'package:cadastrorotas/services/arquivo_service.dart';
import 'package:cadastrorotas/services/caminhao_service.dart';
import 'package:cadastrorotas/services/login_service.dart';
import 'package:cadastrorotas/services/motorista_service.dart';
import 'package:cadastrorotas/services/numero_rota_service.dart';
import 'package:cadastrorotas/services/relatorio_service.dart';
import 'package:cadastrorotas/services/rotas_extras_service.dart';
import 'package:cadastrorotas/services/rotas_service.dart';
import 'package:cadastrorotas/services/servicos_extras_services.dart';
import 'package:cadastrorotas/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

void setupLocator() {
  GetIt.instance.registerLazySingleton(() => usuariosService());
  GetIt.instance.registerLazySingleton(() => arquivoService());
  GetIt.instance.registerLazySingleton(() => rotasService());
  GetIt.instance.registerLazySingleton(() => caminhaoService());
  GetIt.instance.registerLazySingleton(() => loginService());
  GetIt.instance.registerLazySingleton(() => rotasExtrasService());
  GetIt.instance.registerLazySingleton(() => relatorioService());
  GetIt.instance.registerLazySingleton(() => servicosExtrasService());
  GetIt.instance.registerLazySingleton(() => motoristaService());
  GetIt.instance.registerLazySingleton(() => numeroRotasService());
  GetIt.instance.registerLazySingleton(() => httpOptions());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scrollBehavior: MaterialScrollBehavior().copyWith(
      dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown}),
      title: 'pe-express rotas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF2661FA),
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BoasVindasScreen(),

    );
  }
}
