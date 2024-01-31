import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../services/firestore.dart';
import '../services/keys.dart';

class Member with ChangeNotifier {
  // Propriétés Stockées
  DocumentReference? reference; // Chemin vers le document
  String id;
  Map<String, dynamic> map; // Champs

  // Constructeur
  Member({required this.id, required this.map, this.reference});

  // Propriétés calculées
  String get name => map[nameKey] ?? "";
  String get surname => map[surnameKey] ?? "";
  String get adress => map[adressKey] ?? "";
  String get zip => map[zipKey] ?? "";
  String get city => map[cityKey] ?? "";
  String get profilePicture => map[profilePictureKey] ?? "";
  String get coverPicture => map[coverPictureKey] ?? "";
  String get description => map[descriptionKey] ?? "";
  String get fullName => "$surname $name";

  // Fonction pour mettre à jour les données du membre
  Future<void> updateMemberData() async {
    try {
      if (reference != null) {
        DocumentSnapshot snapshot = await reference!.get();
        if (snapshot.exists) {
          map = snapshot.data() as Map<String, dynamic>;
          notifyListeners();
          print('Member data updated successfully');
        }
      }
    } catch (e) {
      print("Error updating member data: $e");
    }
  }

  static Future<Member?> fromUserId(String id) async {
    print('ID is $id');
    try {
      DocumentSnapshot snapshot = await FirestoreService().specificUser(id).first;
      if (snapshot.exists) {
        return Member(
          reference: snapshot.reference,
          id: snapshot.id,
          map: snapshot.data() as Map<String, dynamic>,
        );
      }
      print('Member data create successfully');
    } catch (e) {
      print("Error getting member for user: $e");
    }
    return null;
  }
}
