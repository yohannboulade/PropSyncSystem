import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:propsync_system/const.dart';
import 'package:propsync_system/models/member_model.dart';
import 'package:propsync_system/pages/housing/update_housing.dart';
import 'package:propsync_system/widgets/column_spacing.dart';
import 'package:propsync_system/widgets/empty.dart';
import 'package:propsync_system/widgets/text_field_style.dart';

import '../../models/housing_model.dart';
import '../../services/firestore.dart';
import '../../services/keys.dart';
import 'package:propsync_system/pages/housing/analytics_housing.dart';
import 'package:propsync_system/pages/housing/tenant_housing.dart';
import 'package:propsync_system/pages/housing/balance_housing.dart';

class HousingPage extends StatelessWidget {
  const HousingPage({super.key, required this.member});
  final Member member;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().housingForUser(member.id),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData) {
            final data = snapshot.data!;
            final doc = data.docs;
            return ListView.builder(
              itemCount: doc.length,
              itemBuilder: (context, index) {
                final d = doc[index];
                final logement = Housing(
                  reference: d.reference,
                  id: d.id,
                  map: d.data() as Map<String, dynamic>
                );
                return Card(
                  color: Colors.amber.shade50,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          logement.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          logement.type,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(logement.city),
                        Text(
                          'Loyer hors charges: ${logement.rent}€ ${logement.rented == true ? '' : ''}',
                          style: logement.rented == true ?
                            TextStyle(color: Colors.green)
                            : TextStyle(color: Colors.red),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.data_thresholding_outlined),
                              onPressed: () {
                                final page = AnalyticsHousingPage(logement: logement,);
                                final route = MaterialPageRoute(builder: ((context) => page));
                                Navigator.of(context).push(route);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.bookmark_add_outlined),
                              onPressed: () {
                                final page = BalanceHousingPage(member: member,logement: logement,);
                                final route = MaterialPageRoute(builder: ((context) => page));
                                Navigator.of(context).push(route);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.co_present_outlined),
                              onPressed: () {
                                final page = TenantHousingPage(logement: logement,);
                                final route = MaterialPageRoute(builder: ((context) => page));
                                Navigator.of(context).push(route);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                final page = TenantHousingPage(logement: logement,);
                                final route = MaterialPageRoute(builder: ((context) => page));
                                Navigator.of(context).push(route);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                final page = TenantHousingPage(logement: logement,);
                                final route = MaterialPageRoute(builder: ((context) => page));
                                Navigator.of(context).push(route);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          iconSize: 40,
                          icon: const Icon(Icons.remove_red_eye),
                          onPressed: () {
                            final page = UpdateHousingPage(member: member, logement: logement,);
                            final route = MaterialPageRoute(builder: ((context) => page));
                            Navigator.of(context).push(route);
                          },
                        ),
                      ],
                    )

                  ),
                );
              },
            );
          } else {
            return const EmptyBody();
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final page = AddHousingForm(member: member);
          final route = MaterialPageRoute(builder: ((context) => page));
          Navigator.of(context).push(route);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddHousingForm extends StatefulWidget {
  final Member member;
  const AddHousingForm({super.key, required this.member});
  @override
  AddHousingFormState createState() => AddHousingFormState();
}

class AddHousingFormState extends State<AddHousingForm> {
  List<String> typeOptions = Const.logementTypes;
  String typeController = Const.logementTypes[0]; // Option par défaut

  late TextEditingController nameController;
  late TextEditingController adressController;
  late TextEditingController zipController;
  late TextEditingController cityController;
  late TextEditingController rentController;
  late TextEditingController chargeController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    adressController = TextEditingController();
    zipController = TextEditingController();
    cityController = TextEditingController();
    rentController = TextEditingController();
    chargeController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    adressController.dispose();
    zipController.dispose();
    cityController.dispose();
    rentController.dispose();
    chargeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text("Ajouté un logement"),
      actions: [
        ElevatedButton(
          onPressed: () {
            _onValidate();
            Navigator.pop(context);
          },
          child: const Text("Valider")
        )
      ],
    ),
    body : SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: screenHeight, // Définissez la hauteur de la modal sur toute la hauteur de l'écran
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: typeController,
              onChanged: (String? newValue) {
                setState(() {
                  typeController = newValue!;
                });
              },
              items: typeOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const ColumnSpacing(),
            TextField(
              controller: nameController,
              decoration: const TextFieldStyle(hint: "Nom du logement"),
            ),
            const ColumnSpacing(),
            TextField(
              controller: adressController,
              decoration: const TextFieldStyle(hint: "Adresse du logement"),
            ),
            const ColumnSpacing(),
            TextField(
              controller: zipController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: const TextFieldStyle(hint: "Code postal"),
            ),
            const ColumnSpacing(),
            TextField(
              controller: cityController,
              decoration: const TextFieldStyle(hint: "Vile"),
            ),
            const ColumnSpacing(),
            TextField(
              controller: rentController,
              decoration: const TextFieldStyle(hint: "Loyer HC"),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
            ),
            const ColumnSpacing(),
            TextField(
              controller: chargeController,
              decoration: const TextFieldStyle(hint: "Charges"),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
            ),
          ],
        ),
      ),
    )
    );
  }

  Future<String?> _onValidate() async {
    FocusScope.of(context).requestFocus(FocusNode());
    final member = widget.member;
    final Map<String, dynamic> data = {
      memberIdKey: member.id,
      nameKey: nameController.text,
      adressKey: adressController.text,
      zipKey: zipController.text,
      cityKey: cityController.text,
      typeKey: typeController,
      rentKey: rentController.text,
      chargeKey: chargeController.text
    };
    try {
      var result = await FirestoreService().addHousing(memberId: member.id, data: data);
      // Opération réussie, vous pouvez traiter 'result' ici
      return "Firestore operation successful: $result";
    } catch (e) {
      if (e is FirebaseException) {
        // Gérer les erreurs spécifiques à Firestore
        return "Firestore error code: ${e.code}";
      } else {
        // Gérer d'autres types d'erreurs
        return "An unexpected error occurred: $e";
      }
    }
  }
}
