import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:propsync_system/pages/contact/contact_add.dart';
import 'package:propsync_system/pages/contact/update_contact.dart';
import 'package:propsync_system/widgets/column_spacing.dart';
import '../../models/contact_model.dart';
import '../../models/member_model.dart';
import '../../services/firestore.dart';
import '../../widgets/empty.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key, required this.member}) : super(key: key);
  final Member member;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ColumnSpacing(),
          ElevatedButton(onPressed: (){}, child: const Text('Aller sur travaux.com')),
          const ColumnSpacing(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Text(
              'Publiez votre projet travaux chez notre partenaire travaux.com et recevez tout vos devis en quelques clic',
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirestoreService().contactForUser(member.id),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  final doc = data.docs;
                  return ListView.builder(
                    itemCount: doc.length,
                    itemBuilder: (context, index) {
                      final d = doc[index];
                      final contact = Contact(
                        reference: d.reference,
                        id: d.id,
                        map: d.data() as Map<String, dynamic>,
                      );
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Métier : ${contact.contactType}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('${contact.contactName} : ${contact.contactPhone}'),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('${contact.contactMail}'),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.message),
                                    onPressed: () {
                                      //final page = UpdateContactPage(Contact: contact, member: member,);
                                      //final route = MaterialPageRoute(builder: ((context) => page));
                                      //Navigator.of(context).push(route);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.phone),
                                    onPressed: () {
                                      call(contact.contactPhone);
                                      //final route = MaterialPageRoute(builder: ((context) => page));
                                      //Navigator.of(context).push(route);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.mail),
                                    onPressed: () {
                                      envoyerMail(contact.contactMail);
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit_note),
                            onPressed: () {
                              final page = UpdateContactPage(contact: contact, member: member,);
                              final route = MaterialPageRoute(builder: ((context) => page));
                              Navigator.of(context).push(route);
                            },
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const EmptyBody();
                }
              },
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final page = AddContactForm(member: member);
          final route = MaterialPageRoute(builder: ((context) => page));
          Navigator.of(context).push(route);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Future <void> envoyerMail(String email) async {
    // Vérifie si le schéma "mailto" est pris en charge
    if (email != '') {
      // Lance l'application de messagerie avec l'email du contact en destinataire
      await launchUrl(
        Uri(
          scheme: 'mailto',
          path: email,
          query: encodeQueryParameters(<String, String>{
            'subject': 'Envoyer depuis Propsync System',
          }),
        )
      );
    } else {
      // Affiche une erreur si le schéma "mailto" n'est pas pris en charge
      throw 'Impossible d\'envoyer un mail à $email';
    }
  }


  Future <void> call(String phone) async {
    // Vérifie si le schéma "mailto" est pris en charge
    if (await canLaunchUrl(
        Uri(
          scheme: 'tel',
          path: phone,
        )
    )) {
      // Lance l'application de messagerie avec l'email du contact en destinataire
      await launchUrl(
          Uri(
            scheme: 'tel',
            path: phone,
          )
      );
    } else {
      // Affiche une erreur si le schéma "mailto" n'est pas pris en charge
      throw 'Impossible d\'envoyer un mail à $phone';
    }
  }
}