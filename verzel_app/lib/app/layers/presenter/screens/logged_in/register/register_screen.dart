import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verzel_app/app/common/styles/app_styles.dart';
import 'package:verzel_app/app/common/widget/app_widgets.dart';
import 'package:verzel_app/app/common/widget/input_text.dart';
import 'package:verzel_app/app/layers/presenter/providers/data_provider.dart';

class RegisterScreen extends StatefulWidget {
  final Map<String, dynamic>? registerCar;
  const RegisterScreen({
    Key? key,
    this.registerCar,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Map<String, dynamic>? register;
  final appStyles = AppStyles();
  final appWidgets = AppWidgets();
  TextEditingController nome = TextEditingController();
  TextEditingController marca = TextEditingController();
  TextEditingController modelo = TextEditingController();
  TextEditingController ano = TextEditingController();
  TextEditingController cidadeBrasileira = TextEditingController();
  TextEditingController kilometragem = TextEditingController();
  TextEditingController valor = TextEditingController();

  late DataProvider dataProvider;
  late Future<void> future;

  Future<void> initScreen() async {
    dataProvider = Provider.of<DataProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 200));
    if (widget.registerCar == null) {
      register = {};
    } else {
      register = widget.registerCar;
      nome = TextEditingController(text: register!['nome']);
      marca = TextEditingController(text: register!['marca']);
      modelo = TextEditingController(text: register!['modelo']);
      ano = TextEditingController(text: register!['ano'].toString());
      cidadeBrasileira =
          TextEditingController(text: register!['cidade_brasileira']);
      kilometragem =
          TextEditingController(text: register!['kilometragem'].toString());
      valor = TextEditingController(text: register!['valor'].toString());
    }
  }

  @override
  void initState() {
    super.initState();
    future = initScreen();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.registerCar != null
                  ? 'Registro: ${register!['id']}'
                  : 'Novo registro'),
              actions: [
                IconButton(
                  onPressed: () async {
                    await dataProvider.deleteCar(context, register!['id']);
                  },
                  icon: const Icon(
                    Icons.delete,
                  ),
                ),
              ],
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        widget.registerCar != null
                            ? SizedBox(
                                height: 175,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black54, width: 0.3),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image:
                                              MemoryImage(register!['bytes']),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(
                                height: 175,
                                child: Center(
                                  child: Icon(
                                    Icons.photo_camera,
                                    size: 150,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                        InputText(
                          controller: nome,
                          labeltext: 'Nome',
                        ),
                        InputText(
                          controller: marca,
                          labeltext: 'Marca',
                        ),
                        InputText(
                          controller: modelo,
                          labeltext: 'Modelo',
                        ),
                        InputText(
                          controller: ano,
                          labeltext: 'Ano',
                          typeKeyboard: TextInputType.number,
                        ),
                        InputText(
                          controller: cidadeBrasileira,
                          labeltext: 'Cidade',
                        ),
                        InputText(
                          controller: kilometragem,
                          labeltext: 'Kilometragem',
                          typeKeyboard: TextInputType.number,
                        ),
                        InputText(
                          controller: valor,
                          labeltext: 'Valor',
                          typeKeyboard: TextInputType.number,
                        ),
                        appWidgets.buildPrimaryButton(
                          () async {
                            register = {
                              "id": register!['id'],
                              "nome": nome.text,
                              "marca": marca.text,
                              "modelo": modelo.text,
                              "foto_base64": "",
                              "ano": ano.text,
                              "cidade_brasileira": cidadeBrasileira.text,
                              "kilometragem": kilometragem.text,
                              "valor": valor.text,
                              "local_imagem": ""
                            };

                            if (widget.registerCar == null) {
                              await dataProvider.newCar(context, register!);
                            } else {
                              await dataProvider.editCar(context, register!);
                            }
                          },
                          label: "SALVAR",
                          enable: true,
                          buttonColor: appStyles.primaryColor,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
