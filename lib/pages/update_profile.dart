import 'package:flutter/material.dart';
import 'package:propsync_system/widgets/column_spacing.dart';
import 'package:propsync_system/widgets/text_field_style.dart';
import 'package:propsync_system/models/member_model.dart';
import 'package:propsync_system/services/authrntification.dart';
import 'package:propsync_system/services/firestore.dart';
import 'package:propsync_system/services/keys.dart';

class UpdateProfilePage extends StatefulWidget {
  final Member member;
  const UpdateProfilePage({super.key, required this.member});
  @override
  UpdateState createState() => UpdateState();
}

class UpdateState extends State<UpdateProfilePage> {
  late TextEditingController nameController;
  late TextEditingController surnameController;
  late TextEditingController descriptionController;
  late TextEditingController adressController;
  late TextEditingController zipController;
  late TextEditingController cityController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.member.name);
    surnameController = TextEditingController(text: widget.member.surname);
    widget.member.description.isNotEmpty
      ? descriptionController = TextEditingController(text: widget.member.description)
      : descriptionController = TextEditingController();
    widget.member.adress.isNotEmpty
        ? adressController = TextEditingController(text: widget.member.adress)
        : adressController = TextEditingController();
    widget.member.zip.isNotEmpty
        ? zipController = TextEditingController(text: widget.member.zip)
        : zipController = TextEditingController();
    widget.member.city.isNotEmpty
        ? cityController = TextEditingController(text: widget.member.city)
        : cityController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    descriptionController.dispose();
    adressController.dispose();
    zipController.dispose();
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Modifier le profil"),
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
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            children: [
              const ColumnSpacing(),
              TextField(
                controller: surnameController,
                decoration: const TextFieldStyle(hint: "Prénom"),
              ),
              const ColumnSpacing(),
              TextField(
                controller: nameController,
                decoration: const TextFieldStyle(hint: "Nom"),
              ),
              const ColumnSpacing(),
              TextField(
                controller: descriptionController,
                decoration: const TextFieldStyle(hint: "Description"),
              ),
              const ColumnSpacing(),
              TextField(
                controller: adressController,
                decoration: const TextFieldStyle(hint: "Adresse"),
              ),
              const ColumnSpacing(),
                TextField(
                  controller: zipController,
                  decoration: const TextFieldStyle(hint: "Code postal"),
                ),
              const ColumnSpacing(),
                TextField(
                  controller: cityController,
                  decoration: const TextFieldStyle(hint: "Vile"),
              ),
              const ColumnSpacing(),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Etes vous sur de vouloir vous déconnecter?"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    AuthService().signOut().then((value) => Navigator.pop(context));
                                  },
                                  child: const Text("OUI")
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("NON")
                              ),
                            ],
                          );
                        }
                    );
                  },
                  child: const Text("Se déconnecter")
              )
            ],
          ),
        ),
      ),
    );
  }

  _onValidate() {
    FocusScope.of(context).requestFocus(FocusNode());
    Map<String, dynamic> map = {};
    final member = widget.member;
    if (nameController.text.isNotEmpty && nameController.text != member.name) {
      map[nameKey] = nameController.text;
    }
    if (surnameController.text.isNotEmpty && surnameController.text != member.surname) {
      map[surnameKey] = surnameController.text;
    }
    if (descriptionController.text.isNotEmpty && descriptionController.text != member.description) {
      map[descriptionKey] = descriptionController.text;
    }
    if (adressController.text.isNotEmpty && adressController.text != member.adress) {
      map[adressKey] = adressController.text;
    }
    if (zipController.text.isNotEmpty && zipController.text != member.zip) {
      map[zipKey] = zipController.text;
    }
    if (cityController.text.isNotEmpty && cityController.text != member.city) {
      map[cityKey] = cityController.text;
    }
    FirestoreService().updateUser(id: member.id, data: map);
  }
}