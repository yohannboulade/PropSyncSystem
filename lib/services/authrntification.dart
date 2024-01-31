import 'package:firebase_auth/firebase_auth.dart';
import 'package:propsync_system/services/firestore.dart';

import 'keys.dart';

class AuthService {
  //Récupérer une instance de auth
  final instance = FirebaseAuth.instance;

  //Signin
  Future<String?> signInWithMail({required String email, required String password}) async {
    try {
      final credential = await instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return credential.user?.uid;
    } on FirebaseAuthException catch (e) {
      return e.toString();
    } catch (e) {
      return e.toString();
    }
  }

  //Créer un compte
  Future<String?> createAccountWithMail({
    required String email,
    required String password,
    required String surname,
    required String name
  }) async {
    try {
      final credential = await instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      if (credential.user == null) {
        return "Aucun utilisateur";
      }
      //Créer un utilisateur dans Firestore
      final id = credential.user!.uid;
      final Map<String, dynamic> data = {
        nameKey: name,
        surnameKey: surname
      };
      FirestoreService().addUser(
          id: id,
          data: data
      );
      return "Nous avons ajouté un utilisateur";

    } on FirebaseAuthException catch (e) {
      return e.toString();
    } catch (e) {
      return e.toString();
    }
  }

  //SignOut
  Future<bool> signOut() async {
    await instance.signOut();
    return true;
  }

  //Récupérer l'id unique de l'utilisateur
  String? get myId => instance.currentUser?.uid;
  String? get myEmail => instance.currentUser?.email;

  //Voir si un utilisateur est nous
  bool isMe(String profileId) {
    if (myId == null) return false;
    return myId! == profileId;
  }
}