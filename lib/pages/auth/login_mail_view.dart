import 'package:flutter/material.dart';
import 'package:propsync_system/widgets/column_spacing.dart';
import 'package:propsync_system/widgets/text_field_style.dart';

import '../../services/authrntification.dart';


class LoginEmailPage extends StatefulWidget {
  const LoginEmailPage({super.key});

  @override
  State<LoginEmailPage> createState() => _LoginEmailPageState();
}

class _LoginEmailPageState extends State<LoginEmailPage> {

  late TextEditingController mailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    mailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    mailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      body: SingleChildScrollView(
        child: Column(
        children: [
          const SizedBox(height:50),
          Image.asset('assets/images/logo.png', height: 120),
          Image.asset('assets/images/name.png', height: 75),
          Card(
            color: Colors.amber,
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Column(
                    children: [
                      const Text(
                        'CONNEXION',
                        style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(height:20),
                      TextField(
                        controller: mailController,
                        decoration: const TextFieldStyle(hint: "Adresse email"),
                      ),
                      const ColumnSpacing(),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const TextFieldStyle(hint: "Mot de passe"),
                      ),
                      const SizedBox(height:20),
                      ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(
                            width: double.infinity,
                            height: 47,
                          ),
                          child: ElevatedButton(
                            onPressed: () => {
                            _handleHauth().then((value) {
                              Navigator.pop(context);
                              final SnackBar snackBar = SnackBar(content: Text(value ?? ""));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            })
                          },
                            child: const Text("Connexion")
                          ),
                        ),
                      const SizedBox(height:20),
                      ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(
                            width: double.infinity,
                            height: 47,
                          ),
                          child: TextButton(
                            onPressed: () => {Navigator.pop(context)},
                            child: const Text("Retour")
                          ),
                      )
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      )
      )
     );
  }
  Future<String?> _handleHauth() async {
    FocusScope.of(context).requestFocus(FocusNode());
    final result = await AuthService().signInWithMail(
        email: mailController.text,
        password: passwordController.text
    );
    return result;
  }
}

