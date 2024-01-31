import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/keys.dart';

class Tenant {
  //Propriétés Stockées
  DocumentReference reference; //Chemin vers le document
  String id; // Id Unique du document
  Map<String, dynamic> map; //Champs

  //Constructeur
  Tenant({required this.reference, required this.id, required this.map});

  get financeAmount => map[financeAmountKey] ?? 0;
  String get tenantType => map[tenantTypeKey] ?? "";
  String get tenantName => map[tenantNameKey] ?? "";
  String get tenantSurname => map[tenantSurnameKey] ?? "";
  String get tenantCivilite => map[tenantCiviliteKey] ?? "";
  String get tenantMail => map[tenantMailKey] ?? "";
  String get tenantPhone => map[tenantPhoneKey] ?? "";
  String get tenantHousing => map[tenantHousingKey] ?? "";


}
