import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:propsync_system/pages/app.dart';
import 'package:propsync_system/pages/auth/login_view.dart';
import 'package:provider/provider.dart';

import 'models/member_model.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user != null) {
      // Utilisateur connecté
      return StreamBuilder<Member?>(
        stream: Provider.of<Stream<Member?>>(context), // Utilisez le flux directement
        builder: (BuildContext context, AsyncSnapshot<Member?> memberSnapshot) {
          if (memberSnapshot.connectionState == ConnectionState.active) {
            final member = memberSnapshot.data;

            if (member != null) {
              // Utilisateur et membre existent, retournez votre écran principal ici
              return const Skeleton();
            } else {
              // Charge en cours pour le membre
              return const CircularProgressIndicator();
            }
          } else {
            // Connexion en cours
            return const CircularProgressIndicator();
          }
        },
      );
    } else {
      // Utilisateur non connecté
      return const LoginPage();
    }
  }
}
