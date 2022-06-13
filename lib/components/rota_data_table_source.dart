import 'dart:js';

import 'package:cadastrorotas/components/alert_dialog.dart';
import 'package:cadastrorotas/models/rotas.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class RotasDataTableSource extends DataTableSource {
  RotasDataTableSource({
    required List<Rotas> rotas,
  })  : _rotasData = rotas,
        assert(rotas != null);
  final List<Rotas> _rotasData;

  @override
  DataRow? getRow(int index) {
    final rotas = _rotasData[index];

    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text('${rotas.id}')),
        DataCell(Text('${rotas.dataEmissao}')),
        DataCell(Text('${rotas.codigoRota}')),
        DataCell(Text('${rotas.destinoRota}')),
        DataCell(Text('${rotas.numeroManifesto}')),
        DataCell(Text('${rotas.numeroCelularMotorista}')),
        DataCell(Text('${rotas.nomeMotorista}')),
        // DataCell(Text('${rotas.nomeResponsavelInterno}')),
        // DataCell(Text('${rotas.contatoResponsavelInterno}')),
        // DataCell(Text('${rotas.gerenteExterno}')),
        // DataCell(Text('${rotas.contatoGerenteExterno}')),
        // DataCell(Text('${rotas.despesasRota}')),
        // DataCell(Text('${rotas.valorRota}')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _rotasData.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
