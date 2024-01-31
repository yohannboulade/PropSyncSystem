import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:propsync_system/pages/tenant/tenant_add.dart';
import 'package:propsync_system/pages/tenant/update_tenant.dart';
import '../../models/member_model.dart';
import '../../models/tenant_model.dart';
import '../../services/firestore.dart';
import '../../widgets/empty.dart';

class TenantPage extends StatelessWidget {
  const TenantPage({Key? key, required this.member}) : super(key: key);
  final Member member;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().tenantForUser(member.id),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            final doc = data.docs;
            return ListView.builder(
              itemCount: doc.length,
              itemBuilder: (context, index) {
                final d = doc[index];
                final tenant = Tenant(
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
                              'Location : ${tenant.tenantType}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('${tenant.tenantCivilite} ${tenant.tenantName} ${tenant.tenantSurname}')
                          ],
                        )
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit_note),
                      onPressed: () {
                        final page = UpdateTenantPage(tenant: tenant, member: member,);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final page = AddTenantForm(member: member);
          final route = MaterialPageRoute(builder: ((context) => page));
          Navigator.of(context).push(route);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}


