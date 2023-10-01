import 'package:flutter/material.dart';
import 'package:verzel_app/app/common/styles/app_styles.dart';
import 'package:verzel_app/app/common/widget/app_widgets.dart';
import 'package:verzel_app/app/common/widget/input_text.dart';
import 'package:verzel_app/app/layers/presenter/providers/auth_provider.dart';
import 'package:verzel_app/app/layers/presenter/providers/config_provider.dart';
import 'package:verzel_app/functions.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  static const String route = "login";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final appStyles = AppStyles();
  final appWidgets = AppWidgets();
  bool isScreenLocked = false;
  bool password = true;
  late AuthProvider authProvider;
  late ConfigProvider configProvider;
  late Future<void> future;
  TextEditingController userLogger = TextEditingController();
  TextEditingController passwordLogger = TextEditingController();
  Future<void> initScreen() async {
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    configProvider = Provider.of<ConfigProvider>(context, listen: false);

    await Future.delayed(const Duration(milliseconds: 200));

    userLogger.text = await configProvider.loadLastLoggedEmail();
    passwordLogger.text = await configProvider.loadLastLoggedPassword();
  }

  @override
  void initState() {
    super.initState();
    future = initScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        reverse: true,
        physics: const BouncingScrollPhysics(),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(
              appStyles.logoPath,
              width: MediaQuery.of(context).size.width * 0.4,
            ),
            const Column(children: []),
            const SizedBox(height: 100),
            InputText(
              controller: userLogger,
              labeltext: 'Usuário',
              typeKeyboard: TextInputType.emailAddress,
            ),
            InputText.password(
              controller: passwordLogger,
              labeltext: 'Senha',
              icon: password ? Icons.visibility : Icons.visibility_off,
              funcIcon: () {
                setState(() {
                  password = !password;
                });
              },
              password: password,
            ),
            appWidgets.buildPrimaryButton(
              () async {
                if (userLogger.text == '') {
                  showFlushbar(
                    context,
                    'Atenção!',
                    'Usuário é um campo obrigatório',
                    3,
                  );
                  return;
                }
                if (passwordLogger.text == '') {
                  showFlushbar(
                    context,
                    'Atenção!',
                    'Senha é um campo obrigatório',
                    3,
                  );
                  return;
                }
                setState(() => isScreenLocked = true);
                FocusManager.instance.primaryFocus?.unfocus();
                await authProvider.signIn(
                  context,
                  mounted,
                  userLogger.text,
                  passwordLogger.text,
                );
                setState(() => isScreenLocked = false);
              },
              label: "ENTRAR",
              enable: true,
              processing: isScreenLocked,
              buttonColor: appStyles.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
