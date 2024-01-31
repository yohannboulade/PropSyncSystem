import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/keys.dart';

class Housing {
  //Propriétés Stockées
  DocumentReference reference; //Chemin vers le document
  String id; // Id Unique du document
  Map<String, dynamic> map; //Champs

  //Constructeur
  Housing({required this.reference, required this.id, required this.map});

  //Propriétés calculées
  String get name => map[nameKey] ?? "";
  String get adress => map[adressKey] ?? "";
  String get zip => map[zipKey] ?? "";
  String get city => map[cityKey] ?? "";
  String get type => map[typeKey] ?? "";
  get rent => map[rentKey] ?? 0;
  get charge => map[chargeKey] ?? 0;
  get rented => map[rentedKey] ?? false;
  String get libreryPictures => map[libreryPicturesKey] ?? "";
  String get description => map[descriptionKey] ?? "";
  get purchasePrice => map[purchasePricekey] ?? 0.0;
  get monthlyLoanPayment => map[monthlyLoanPaymentkey] ?? 0.0;
  /*
    début du prêt
    fin du prêt
    mensualité du prêt
    DPE
    GES
    nb de pièces
    nb chambre
    jardin bool
    garage bool
    ...
    m² habitable
    m² terrain
    année de construction
    id du locataire
    id de la location (faire une autre table de location)
  */
}
