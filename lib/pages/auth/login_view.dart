import 'package:flutter/material.dart';
import 'package:propsync_system/pages/auth/forgotten_password_view.dart';
import 'package:propsync_system/pages/auth/login_mail_view.dart';
import 'package:propsync_system/pages/auth/singin_view.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.amberAccent.shade100,
                  Colors.amberAccent.shade200,
                  Colors.orange.shade800,
                ],
              ),
            ),
            child: Column(
            children: [
              const SizedBox(height:50),
              Image.asset('assets/images/logo.png', height: 120),
              Image.asset('assets/images/name.png', height: 75),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(0),
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          const Text(
                            'CONNEXION',
                            style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 20),
                          ),
                          const SizedBox(height:20),
                          ConstrainedBox(
                              constraints: const BoxConstraints.tightFor(
                                width: double.infinity,
                                height: 47,
                              ),
                              child: ElevatedButton(
                                onPressed: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoginEmailPage()),
                                  )
                                },
                                child: const Text("Connexion Email")
                              ),
                            ),
                          const SizedBox(height:20),
                          ConstrainedBox(
                              constraints: const BoxConstraints.tightFor(
                                width: double.infinity,
                                height: 47,
                              ),
                              child: ElevatedButton(
                                onPressed: () => {},
                                child: const Text("Connexion Google")
                              ),
                          ),
                          const SizedBox(height:20),
                          ConstrainedBox(
                              constraints: const BoxConstraints.tightFor(
                                width: double.infinity,
                                height: 47,
                              ),
                              child: ElevatedButton(
                                onPressed: () => {},
                                child: const Text("Connexion Apple")
                              ),
                          )
                          ],
                        ),
                        const SizedBox(height:20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ForgottenPassword()),
                                  );
                                },
                              child: const Text("Mot de passe oublier")
                            ),
                            TextButton(
                              child: const Text("Je crée un compte"),
                              onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SinginPage()),
                                  );
                                },
                            ),
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
}