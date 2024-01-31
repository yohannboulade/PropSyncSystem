import 'package:flutter/material.dart';
import 'package:propsync_system/widgets/column_spacing.dart';
import 'package:propsync_system/widgets/text_field_style.dart';

import '../../services/authrntification.dart';


class SinginEmailPage extends StatefulWidget {
  const SinginEmailPage({super.key});

  @override
  State<SinginEmailPage> createState() => _SinginEmailPageState();
}

class _SinginEmailPageState extends State<SinginEmailPage> {

  late TextEditingController mailController;
  late TextEditingController passwordController;
  late TextEditingController surnameController;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    mailController = TextEditingController();
    passwordController = TextEditingController();
    surnameController = TextEditingController();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    mailController.dispose();
    passwordController.dispose();
    surnameController.dispose();
    nameController.dispose();
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', height: 50),
              Image.asset('assets/images/name.png', height: 50),
            ],
          ),
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
                        'INSCRIPTION',
                        style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 20),
                      ),
                      const ColumnSpacing(),
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
                      const ColumnSpacing(),
                      TextField(
                        controller: surnameController,
                        decoration: const TextFieldStyle(hint: "Prénom"),
                      ),
                      const ColumnSpacing(),
                      TextField(
                        controller: nameController,
                        decoration: const TextFieldStyle(hint: "Nom"),
                      ),
                      const ColumnSpacing(),
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
                            child: const Text("Inscription")
                          ),
                        ),
                      const ColumnSpacing(),
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
    final result = await AuthService().createAccountWithMail(
        email: mailController.text,
        password: passwordController.text,
        surname: surnameController.text,
        name: nameController.text
    );
    return result;
  }
}

