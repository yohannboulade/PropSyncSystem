import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:propsync_system/const.dart';
import '../../models/member_model.dart';
import '../../models/housing_model.dart';
import '../../services/firestore.dart';
import '../../services/keys.dart';
import '../../widgets/column_spacing.dart';
import '../../widgets/text_field_style.dart';


class AddContactForm extends StatefulWidget {
  final Member member;
  const AddContactForm({Key? key, required this.member}) : super(key: key);
  @override
  AddContactFormState createState() => AddContactFormState();
}

class AddContactFormState extends State<AddContactForm> {
  late List<String> typeOptions;
  late String typeController;
  late Map<String, String> housingOptions = {"NA":"Contact non associer"};
  late String housingController = '';

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController mailController;

  Future<void> initData() async {
    try {
      QuerySnapshot housingSnapshot =
      await FirestoreService().housingForUser(widget.member.id).first;

      List<Housing> housing = housingSnapshot.docs
          .map((doc) => Housing(
        reference: doc.reference,
        id: doc.id,
        map: doc.data() as Map<String, dynamic>,
      ))
          .toList();

      Map<String, String> options = {};

      options['NA'] = "Contact non associer";
      for (int i = 0; i < housing.length; i++) {
        options[housing[i].id] = housing[i].name;
      }

      if (mounted) {
        setState(() {
          housingOptions = options;
          if (options.isNotEmpty) {
            housingController = options.keys.first;
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

    // Liste des métiers du bâtiment
    typeOptions = Const.jobs;
    typeController = Const.jobs[0];

    nameController = TextEditingController();
    phoneController = TextEditingController();
    mailController = TextEditingController();

    initData();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    mailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Ajouter un contact"),
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
          padding: const EdgeInsets.all(16.0),
          height: screenHeight,
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
              DropdownButtonFormField<String>(
                value: housingOptions.containsKey(housingController) ? housingController : null,
                onChanged: (String? newValue) {
                  if (newValue != null && housingOptions.containsKey(newValue)) {
                    setState(() {
                      housingController = newValue;
                    });
                  }
                },
                items: housingOptions.keys.map<DropdownMenuItem<String>>((String key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(housingOptions[key]!),
                  );
                }).toList(),
              ),
              const ColumnSpacing(),
              TextField(
                controller: nameController,
                decoration: const TextFieldStyle(hint: "Nom"),
              ),
              const ColumnSpacing(),
              TextField(
                controller: mailController,
                decoration: const TextFieldStyle(hint: "Email"),
              ),
              const ColumnSpacing(),
              TextField(
                controller: phoneController,
                decoration: const TextFieldStyle(hint: "Téléphone"),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _onValidate() async {
    FocusScope.of(context).requestFocus(FocusNode());
    final member = widget.member;
    final Map<String, dynamic> data = {
      contactMemberKey: member.id,
      contactHousingKey: housingController,
      contactTypeKey: typeController,
      contactNameKey: nameController.text,
      contactMailKey: mailController.text,
      contactPhoneKey: phoneController.text,
    };
    try {
      var result = await FirestoreService().addContact(memberId: member.id, data: data);
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