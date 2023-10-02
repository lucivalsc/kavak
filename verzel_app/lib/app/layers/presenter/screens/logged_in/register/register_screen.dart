import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
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
  List<Map<String, dynamic>> evidences = [];

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
                  onPressed: widget.registerCar != null
                      ? () async {
                          await dataProvider.deleteCar(
                              context, register!['id']);
                        }
                      : null,
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
                        buildWithImage(),
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
                            // Validar usuário aqui
                            await dataSave();
                          },
                          label: "SALVAR",
                          enable: nome.text.isNotEmpty &&
                              marca.text.isNotEmpty &&
                              modelo.text.isNotEmpty &&
                              ano.text.isNotEmpty &&
                              cidadeBrasileira.text.isNotEmpty &&
                              kilometragem.text.isNotEmpty &&
                              valor.text.isNotEmpty,
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

  dataSave() async {
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
      var value = await dataProvider.newCar(context, register!);
      if (value) {
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } else {
      var value = await dataProvider.editCar(context, register!);
      if (value) {
        if (mounted) {
          Navigator.pop(context);
        }
      }
    }
  }

  Widget buildWithImage() {
    Future<void> insertImage(ImageSource source) async {
      final xFile = await ImagePicker().pickImage(source: source);
      Navigator.pop(context);
      if (xFile != null) {
        final bytes = await xFile.readAsBytes().then((value) async {
          return await FlutterImageCompress.compressWithList(
            value,
            quality: 50,
          );
        });

        setState(() {
          register!['bytes'] = bytes;
          // evidences.add({'name': xFile.name, 'bytes': bytes});
        });
      }
    }

    return InkWell(
      onTap: () async {
        await showDialog(
          context: context,
          builder: (ctx) => buildAlertDialog(
            ctx,
            'CARREGAR FOTO',
            'De onde você deseja enviar a foto?',
            'Câmera',
            'Galeria',
            () async => await insertImage(ImageSource.camera),
            () async => await insertImage(ImageSource.gallery),
          ),
        );
      },
      onLongPress: () async {
        await showDialog(
          context: context,
          builder: (ctx) => buildAlertDialog(
            ctx,
            'REMOVER FOTO',
            'Confirmar remoção desta foto?',
            'SIM',
            'NÃO',
            () {
              setState(() {
                evidences.removeAt(0);
              });
              Navigator.of(ctx).pop();
            },
            () => Navigator.of(ctx).pop(),
          ),
        );
      },
      child: widget.registerCar != null
          ? SizedBox(
              height: 175,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54, width: 0.3),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: MemoryImage(register!['bytes']),
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
    );
  }

  Widget buildAlertDialog(
    BuildContext ctx,
    String title,
    String message,
    String leftButtonTitle,
    String rightButtonTitle,
    void Function() leftButtonFunction,
    void Function() rightButtonFunction,
  ) =>
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: appStyles.secondaryColor3, width: 1.0),
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 14),
              Text(
                title,
                style: TextStyle(
                    color: Colors.grey.shade700, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: TextStyle(color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: leftButtonFunction,
                      child: Text(leftButtonTitle)),
                  TextButton(
                      onPressed: rightButtonFunction,
                      child: Text(rightButtonTitle)),
                ],
              ),
            ],
          ),
        ),
      );
  Widget buildRoundedTextField({
    required String label,
    required TextEditingController controller,
    required Function(String) onChanged,
    double fontSize = 20,
    double? boxHeight,
    int? maxLines,
    bool? enabled,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black87, fontSize: 14.0),
        ),
        const SizedBox(height: 2.0),
        Container(
          height: boxHeight ?? fontSize + 10,
          width: double.infinity,
          decoration: BoxDecoration(
            color: enabled == false ? Colors.grey.shade400 : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            border: Border.all(color: Colors.black38, width: 1.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
          alignment: Alignment.centerLeft,
          child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: fontSize),
                  labelStyle: TextStyle(fontSize: fontSize)),
              onChanged: onChanged,
              maxLines: maxLines,
              enabled: enabled),
        ),
      ],
    );
  }
}
