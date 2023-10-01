import 'package:flutter/material.dart';
import 'package:verzel_app/app/layers/presenter/screens/logged_in/order/lista.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ordenar'),
      ),
      body: ListView.separated(
        itemCount: lista.length,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
        itemBuilder: (BuildContext context, int index) {
          var item = lista[index];
          return ListTile(
            onTap: () {
              Navigator.pop(context, item);
            },
            title: Text(item['titulo'].toString()),
          );
        },
      ),
    );
  }
}

