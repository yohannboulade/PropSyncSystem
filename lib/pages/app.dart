import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:propsync_system/models/member_model.dart';
import 'package:propsync_system/pages/contact/contacts.dart';
import 'package:propsync_system/pages/dashboard.dart';
import 'package:propsync_system/pages/housing/housing.dart';
import 'package:propsync_system/pages/profile.dart';
import 'package:propsync_system/pages/tenant/tenant.dart';
import 'package:propsync_system/widgets/column_spacing.dart';
import '../services/authrntification.dart';
import '../services/firestore.dart';
import '../widgets/avatar.dart';
import '../widgets/empty.dart';
import 'finance/finances.dart';

class Skeleton extends StatefulWidget {
  const Skeleton({super.key});

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final memberId = AuthService().myId;
    return (memberId == null)
        ? const EmptyScaffold()
        : StreamBuilder<DocumentSnapshot>(
        stream: FirestoreService().specificUser(memberId),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            final Member member = Member(
                reference: data.reference,
                id: data.id,
                map: data.data() as Map<String, dynamic>
            );

            // Liste des widget fonctionel
            final List<Map <String, dynamic>> widgetOptions = [
              {
                'widget': DashboardPage(),
                'title': 'Tableau de bord',
                'icon': const Icon(Icons.dashboard),
              },
              {
                'widget': HousingPage(member: member),
                'title': 'Logements',
                'icon': const Icon(Icons.holiday_village),
              },
              {
                'widget': FinancePage(member: member),
                'title': 'Finances',
                'icon': const Icon(Icons.euro),
              },
              {
                'widget': ContactPage(member: member),
                'title': 'Contacts',
                'icon': const Icon(Icons.contact_mail),
              },
              {
                'widget': TenantPage(member: member),
                'title': 'Locataires',
                'icon': const Icon(Icons.people),
              },
              {
                'widget': ProfilePage(member: member),
                'title': 'Profil',
                'icon': const Icon(Icons.person),
              }
            ];

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Text(widgetOptions[_selectedIndex]['title'] as String),
              ),
              body: Center(
                child: widgetOptions[_selectedIndex]['widget'],
              ),
              drawer: Drawer(
                // Add a ListView to the drawer. This ensures the user can scroll
                // through the options in the drawer if there isn't enough vertical
                // space to fit everything.
                child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Avatar(
                                radius: 30,
                                url: member.profilePicture
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  member.fullName.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  '${AuthService().myEmail}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: widgetOptions.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                titleTextStyle: const TextStyle(color: Colors.black ,fontSize: 18, fontWeight: FontWeight.w500),
                                leading: widgetOptions[index]['icon'],
                                title: Text(widgetOptions[index]['title']),
                                selected: _selectedIndex == widgetOptions[index]['widget'],
                                onTap: () {
                                  _onItemTapped(index);
                                  Navigator.pop(context);
                                },
                              );
                            },
                        )
                      ),
                    ]
                ),
              ),
            );
          }
          else {
            return const EmptyScaffold();
          }
        }
    );
  }
}