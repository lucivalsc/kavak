import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:verzel_app/app/common/models/debouncer_model.dart';
import 'package:verzel_app/app/common/styles/app_styles.dart';
import 'package:verzel_app/app/common/widget/app_widgets.dart';
import 'package:verzel_app/app/common/widget/input_text.dart';
import 'package:verzel_app/app/layers/presenter/providers/data_provider.dart';
import 'package:verzel_app/app/layers/presenter/screens/logged_in/main_menu_widgets/card_default.dart';
import 'package:verzel_app/app/layers/presenter/screens/logged_in/order/lista.dart';
import 'package:verzel_app/app/layers/presenter/screens/logged_in/order/order_screen.dart';
import 'package:verzel_app/app/layers/presenter/screens/logged_in/register/register_screen.dart';
import 'package:verzel_app/navigation.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  static const String route = "main-menu";

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final appStyles = AppStyles();
  final appWidgets = AppWidgets();

  late DataProvider dataProvider;
  late Future<void> future;

  Map order = lista[2];

  List originals1 = [], filtered1 = [];
  bool isSearchBarFocused = false;
  String searchBarText = '';
  final _debouncer = Debouncer(milliseconds: 1000);

  //Paginação
  int offset = 1;
  final ScrollController scrollController = ScrollController();

  Future<void> initScreen() async {
    dataProvider = Provider.of<DataProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      var value = await dataProvider.responseDatas(context, offset, 10) ?? [];
      for (var i = 0; i < value.length; i++) {
        value[i]['bytes'] =
            appWidgets.base64ToUint8List(value[i]['foto_base64']);
        originals1.add(value[i]);
      }
      setState(() {});
    }
    filtered1 =
        await dataProvider.sortSyncedData(searchBarText, originals1, order);
  }

  void _scrollListener() {
    if (scrollController.position.pixels - 200 ==
        scrollController.position.maxScrollExtent - 200) {
      // O usuário chegou ao final da lista, carregue mais dados
      offset += 1;
      initScreen();
    }
  }

  @override
  void initState() {
    scrollController.addListener(_scrollListener);
    super.initState();
    future = initScreen();
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        setState(() => isSearchBarFocused = false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'KAVAK',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                ),
              ),
              const Expanded(child: SizedBox()),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {
                  push(context, const RegisterScreen());
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: FutureBuilder(
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                      child: Text(
                        'Carregando...',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.black38,
                        ),
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        Column(
                          children: [
                            Container(
                              color: appStyles.primaryColor,
                              height: 70,
                              child: InputText(
                                labeltext:
                                    'Busque por marca, modelo, ano, cor...',
                                icon: Icons.search,
                                funcIcon: () async {
                                  filtered1 = await dataProvider.sortSyncedData(
                                    searchBarText,
                                    originals1,
                                    order,
                                  );
                                },
                                onchanged: (text) async {
                                  searchBarText = text;
                                  _debouncer.run(() async {
                                    filtered1 =
                                        await dataProvider.sortSyncedData(
                                      searchBarText,
                                      originals1,
                                      order,
                                    );
                                    setState(() {});
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'CARROS USADOS',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${filtered1.length} Resultados',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const Expanded(child: SizedBox()),
                                      const Text('Ordenar: '),
                                      TextButton(
                                        onPressed: () async {
                                          order = await push(
                                              context, const OrderScreen());
                                          if (order.isNotEmpty) {
                                            if (order['type'] == 'DESC') {
                                              filtered1.sort((a, b) =>
                                                  b[order['value']].compareTo(
                                                      a[order['value']]));
                                            } else {
                                              filtered1.sort((a, b) =>
                                                  a[order['value']].compareTo(
                                                      b[order['value']]));
                                            }

                                            setState(() {});
                                          }
                                        },
                                        child: Text(order['titulo']),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: filtered1.isEmpty
                              ? appWidgets.buildEmptyInfo(
                                  'Hum... Nada aqui',
                                  'Nenhuma produção foi encontrada!',
                                )
                              : ListView.separated(
                                  controller: scrollController,
                                  shrinkWrap: true,
                                  itemCount: filtered1.length,
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .padding
                                          .bottom),
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 10),
                                  itemBuilder: (context, index) {
                                    final item = filtered1[index];

                                    return CardDefault(
                                      item: item,
                                      appStyles: appStyles,
                                      appWidgets: appWidgets,
                                    );
                                  },
                                ),
                        ),
                      ],
                    );
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
