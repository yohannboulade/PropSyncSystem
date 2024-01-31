import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/keys.dart';

class Finance {
  //Propriétés Stockées
  DocumentReference reference; //Chemin vers le document
  String id; // Id Unique du document
  Map<String, dynamic> map; //Champs

  //Constructeur
  Finance({required this.reference, required this.id, required this.map});

  get financeAmount => map[financeAmountKey] ?? 0;
  String get financeType => map[financeTypeKey] ?? "";
  String get financeHousing => map[financeHousingKey] ?? "";
  String get financeLabel => map[financeLabelKey] ?? "";
  String get financeMember => map[financeMemberKey] ?? "";



/*
   */
}
