import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

Future<String?> checkIfHeroIconExists(String path) async {
  try {
    await rootBundle.load(path);
    return path;
  } catch (e) {
    return null;
  }
}

String capitalize(String string) {
  string = string.trim();
  final exceptions = ["do", "dos", "da", "das", "de"];
  final fullUpperCase = ['ltda', 'cia', 'go', 'km'];
  if (string == '') {
    return '-';
  } else if (string.split(' ').length > 1) {
    return string
        .toLowerCase()
        .split(" ")
        .map((sub) {
          if (sub == '') {
            return sub;
          } else if (fullUpperCase.contains(sub)) {
            return sub.toUpperCase();
          } else if (!exceptions.contains(sub)) {
            return sub[0].toUpperCase() + sub.substring(1);
          } else {
            return sub;
          }
        })
        .toList()
        .join(" ");
  } else {
    return string.substring(0, 1).toUpperCase() + string.substring(1);
  }
}

Future<void> startHiveStuff() async {
  await getApplicationDocumentsDirectory()
      .then((directory) => Hive.init(directory.path));
}

String formatDatetime(String? date) => date != null
    ? DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.parse(date).toLocal())
    : '-';

String formatDate(String? date) => date != null
    ? DateFormat('dd/MM/yyyy').format(DateTime.parse(date).toLocal())
    : '-';

String formatNumber(double? number) =>
    number?.toStringAsFixed(2).replaceAll('.', ',') ?? '0,00';

String formatarValor(double valor) {
  final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: '');
  return formatador.format(valor);
}
