import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:propsync_system/models/member_model.dart';
import 'package:propsync_system/const.dart';
import 'package:propsync_system/widgets/column_spacing.dart';
import 'package:propsync_system/widgets/text_field_style.dart';
import 'package:propsync_system/services/firestore.dart';
import 'package:propsync_system/services/keys.dart';

import '../../models/contact_model.dart';
import '../../models/housing_model.dart';

class UpdateContactPage extends StatefulWidget {
  final Member member;
  final Contact contact;

  const UpdateContactPage({Key? key, required this.contact, required this.member}) : super(key: key);

  @override
  UpdateState createState() => UpdateState();
}

class UpdateState extends State<UpdateContactPage> {
  late List<String> typeOptions;
  late String typeController;
  late TextEditingController contactNameController;
  late TextEditingController contactMailController;
  late TextEditingController contactPhoneController;
  late TextEditingController housingController;
  late Map<String, String> housingOptions;

  Future<void> _getHousingOptions(String? selectedValue) async {
    try {
      QuerySnapshot housingSnapshot = await FirestoreService().housingForUser(widget.member.id).first;

      List<Housing> housingList = housingSnapshot.docs
          .map((doc) => Housing(
        reference: doc.reference,
        id: doc.id,
        map: doc.data() as Map<String, dynamic>,
      ))
          .toList();

      Map<String, String> options = {};

      options['NA'] = "Contact non associée";
      for (int i = 0; i < housingList.length; i++) {
        options[housingList[i].id] = housingList[i].name;
      }

      if (mounted) {
        setState(() {
          housingOptions = options;
          if (selectedValue != null && options.containsKey(selectedValue)) {
            // Si selectedValue n'est pas null et existe dans options, l'utiliser
            housingController.text = selectedValue;
          } else {
            // Sinon, utiliser 'NA' par défaut
            housingController.text = 'NA';
          }
        });
      }
    } catch (e) {
      // Gérer les erreurs si nécessaire
      print("Error loading housing data: $e");
    }
  }


  @override
  void initState() {
    super.initState();
    typeOptions =  Const.jobs;
    typeController = widget.contact.contactType;
    contactNameController = TextEditingController(text: widget.contact.contactName);
    contactMailController = TextEditingController(text: widget.contact.contactMail);
    contactPhoneController = TextEditingController(text: widget.contact.contactPhone);
    housingController = TextEditingController(text: widget.contact.contactHousing);

    _getHousingOptions(housingController.text); // Appel de la fonction pour obtenir la liste des logements
  }

  @override
  void dispose() {
    contactNameController.dispose();
    contactMailController.dispose();
    contactPhoneController.dispose();
    housingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Modifier le contact"),
        actions: [
          ElevatedButton(
            onPressed: () {
              _onValidate();
              Navigator.pop(context);
            },
            child: const Text("Valider"),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            children: [
              Card(
                child: Container(
                  margin: const EdgeInsets.all(24),
                  child: Column(
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
                      DropdownButtonFormField<String>(
                        value: housingController.text,
                        onChanged: (String? newValue) {
                          if (newValue != null && housingOptions.containsKey(newValue)) {
                            setState(() {
                              housingController.text = newValue;
                            });
                          }
                        },
                        items: _getHousingDropdownItems(), // Utilisez la fonction pour obtenir les éléments de la liste des logements
                      ),
                      const ColumnSpacing(),
                      TextField(
                        controller: contactNameController,
                        decoration: const TextFieldStyle(hint: "Nom"),
                      ),
                      const ColumnSpacing(),
                      TextField(
                        controller: contactMailController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const TextFieldStyle(hint: "Email"),
                      ),
                      const ColumnSpacing(),
                      TextField(
                        controller: contactPhoneController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const TextFieldStyle(hint: "Téléphone"),
                      ),
                      const ColumnSpacing(),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Êtes-vous sûr de vouloir supprimer le contact"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              FirestoreService().deleteContact(memberId: widget.member.id,contactId: widget.contact.id).then((value) => Navigator.pop(context));
                            },
                            child: const Text("OUI"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("NON"),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  "Supprimer le contact",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _getHousingDropdownItems() {
    return housingOptions.keys.map<DropdownMenuItem<String>>((String key) {
      return DropdownMenuItem<String>(
        value: key,
        child: Text(housingOptions[key]!),
      );
    }).toList();
  }

  _onValidate() {
    FocusScope.of(context).requestFocus(FocusNode());
    Map<String, dynamic> map = {};
    final contact = widget.contact;

    if (contactNameController.text.isNotEmpty &&
        contactNameController.text != contact.contactName) {
      map[contactNameKey] = contactNameController.text;
    }
    if (contactMailController.text.isNotEmpty &&
        contactMailController.text != contact.contactMail) {
      map[contactMailKey] = contactMailController.text;
    }
    if (contactPhoneController.text.isNotEmpty &&
        contactPhoneController.text != contact.contactPhone) {
      map[contactPhoneKey] = contactPhoneController.text;
    }
    map[contactTypeKey] = typeController;
    map[contactHousingKey] = housingController.text;

    try {
      FirestoreService().updateContact(memberId: widget.member.id,contactId: contact.id, data: map);
      print(map);
    } catch (e) {
      // Gérer les erreurs si nécessaire
      print("Error loading housing data: $e");
    }
  }
}

