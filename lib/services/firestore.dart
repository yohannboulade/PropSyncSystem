import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:propsync_system/models/housing_model.dart';
import 'package:propsync_system/services/keys.dart';
import 'package:propsync_system/services/storage.dart';

class FirestoreService {

  //Accès a la BDD
  static final instance = FirebaseFirestore.instance;

  //Accès spécifique collection
  final firestoreUser = instance.collection(memberCollectionKey);
  final firestorePost = instance.collection(postCollectionKey);
  final firestoreHousing = instance.collection(housingCollectionKey);
  final firestoreFinance = instance.collection(financeCollectionKey);
  final firestoreContact = instance.collection(contactCollectionKey);

  //Stream
  specificUser(String id) => firestoreUser.doc(id).snapshots();
  postForUser(String id) => firestorePost.where(memberIdKey, isEqualTo: id).snapshots();
  housingForUser(String id) => firestoreUser.doc(id).collection(housingCollectionKey).snapshots();
  financeForUser(String id) => firestoreUser.doc(id).collection(financeCollectionKey).snapshots();
  financeForUserAndHousing(String idMember, String idHousing) => firestoreUser.doc(idMember).collection(financeCollectionKey).where(financeHousingKey, isEqualTo: idHousing).snapshots();
  //financeForHousing(String id) => firestoreFinance.where(financeHousingKey, isEqualTo: id).snapshots();
  contactForUser(String id) => firestoreUser.doc(id).collection(contactCollectionKey).snapshots();
  contactForUserAndHousing(String idMember, String idHousing) => firestoreUser.doc(idMember).collection(contactCollectionKey).where(financeHousingKey, isEqualTo: idHousing).snapshots();
  tenantForUser(String id) => firestoreUser.doc(id).collection(tenantCollectionKey).snapshots();


  //Objets assync
  Future<List<Housing>> getHousingListForUser(String userId) async {
    try {
      QuerySnapshot housingSnapshot = await firestoreHousing.where(memberIdKey, isEqualTo: userId).get();

      return housingSnapshot.docs.map((doc) {
        return Housing(
          reference: doc.reference,
          id: doc.id,
          map: doc.data() as Map<String, dynamic>,
        );
      }).toList();
    } catch (e) {
      // Gérer les erreurs si nécessaire
      print("Error getting housing list for user: $e");
      return [];
    }
  }


  //Ajouter un utilisateur
  addUser({required String id, required Map<String, dynamic> data}) {
    firestoreUser.doc(id).set(data);
  }
  //Modifier user
  updateUser({required String id, required Map<String, dynamic> data}) {
    firestoreUser.doc(id).update(data);
  }

  //AddImage
  updateImage({required File file, required String folder, required String userId, required String imageName}) {
    StorageService().addImage(file: file, folder: folder, userId: userId, imageName: imageName).then((imageUrl) {
      updateUser(id: userId, data: {imageName: imageUrl});
    });
  }

  //Ajouter un logement
  addHousing({required String memberId,required Map<String, dynamic> data}){
    firestoreUser.doc(memberId).collection(housingCollectionKey).add(data);
  }
  //Modifier logement
  updateHousing({required String memberId, required String housingId, required Map<String, dynamic> data}) {
    firestoreUser.doc(memberId).collection(housingCollectionKey).doc(housingId).update(data);
  }
  //Delete logement
  deleteHousing({required String memberId, required String housingId}) {
    firestoreUser.doc(memberId).collection(housingCollectionKey).doc(housingId).delete();
  }

  //Ajouter un Finance
  addFinance({required String memberId, required Map<String, dynamic> data}){
    firestoreUser.doc(memberId).collection(financeCollectionKey).add(data);
  }
  //Modifier Finance
  updateFinance({required String memberId, required String financeId, required Map<String, dynamic> data}) {
    firestoreUser.doc(memberId).collection(financeCollectionKey).doc(financeId).update(data);
  }
  //Delete Finance
  deleteFinance({required String memberId, required String financeId}) {
    firestoreUser.doc(memberId).collection(financeCollectionKey).doc(financeId).delete();
  }

  //Ajouter un Contact
  addContact({required String memberId, required Map<String, dynamic> data}){
    firestoreUser.doc(memberId).collection(contactCollectionKey).add(data);
  }
  //Modifier Contact
  updateContact({required String memberId, required String contactId, required Map<String, dynamic> data}) {
    firestoreUser.doc(memberId).collection(contactCollectionKey).doc(contactId).update(data);
  }
  //Delete Contact
  deleteContact({required String memberId, required String contactId,}) {
    firestoreUser.doc(memberId).collection(contactCollectionKey).doc(contactId).delete();
  }
  //Ajouter un Locataire
  addTenant({required String memberId, required Map<String, dynamic> data}){
    firestoreUser.doc(memberId).collection(tenantCollectionKey).add(data);
  }
  //Modifier Contact
  updateTenant({required String memberId, required String tenantId, required Map<String, dynamic> data}) {
    firestoreUser.doc(memberId).collection(tenantCollectionKey).doc(tenantId).update(data);
  }
  //Delete Contact
  deleteTenant({required String memberId, required String tenantId,}) {
    firestoreUser.doc(memberId).collection(tenantCollectionKey).doc(tenantId).delete();
  }
}