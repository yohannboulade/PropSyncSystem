import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/keys.dart';

class Contact {
  //Propriétés Stockées
  DocumentReference reference; //Chemin vers le document
  String id; // Id Unique du document
  Map<String, dynamic> map; //Champs

  //Constructeur
  Contact({required this.reference, required this.id, required this.map});

  String get contactPhone => map[contactPhoneKey] ?? "";
  String get contactType => map[contactTypeKey] ?? "";
  String get contactHousing => map[contactHousingKey] ?? "";
  String get contactName => map[contactNameKey] ?? "";
  String get contactMail => map[contactMailKey] ?? "";
  String get contactMember => map[contactMemberKey] ?? "";



/*
   */
}
