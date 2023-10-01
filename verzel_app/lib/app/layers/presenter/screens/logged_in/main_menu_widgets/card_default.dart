import 'package:flutter/material.dart';
import 'package:verzel_app/app/common/styles/app_styles.dart';
import 'package:verzel_app/app/common/widget/app_widgets.dart';
import 'package:verzel_app/app/layers/presenter/screens/logged_in/main_menu_widgets/circular_widget.dart';
import 'package:verzel_app/app/layers/presenter/screens/logged_in/register/register_screen.dart';
import 'package:verzel_app/navigation.dart';

class CardDefault extends StatelessWidget {
  final Map<String, dynamic> item;

  final AppStyles appStyles;
  final AppWidgets appWidgets;
  const CardDefault({
    Key? key,
    required this.item,
    required this.appStyles,
    required this.appWidgets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => push(
        context,
        RegisterScreen(
          registerCar: item,
        ),
      ),
      child: Card(
        elevation: 2,
        child: Column(
          children: [
            SizedBox(
              height: 175,
              child: appWidgets.buildWithImage(
                context,
                item,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item['nome'],
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const CircularWidget(),
                      Text(
                        item['marca'],
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        item['ano'].toString(),
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const CircularWidget(),
                      Text(
                        item['cidade_brasileira'],
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const CircularWidget(),
                      Text(
                        item['kilometragem'].toString(),
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Text(
                        'R\$',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        item['valor'].toString(),
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
