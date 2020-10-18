import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static String tag = '/home';

  @override
  Widget build(BuildContext context) {
    var snapshots = FirebaseFirestore.instance
        .collection('ongs')
        .orderBy('date')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text('Crud Firebase'),
      ),
      body: StreamBuilder(
          stream: snapshots,
          builder: (
            BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot,
          ) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.data.docs.length == 0) {
              return Center(child: Text('Nenhum dado encontrado'));
            }

            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int i) {
                var item = snapshot.data.docs[i].data();
                return ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.check_box),
                    onPressed: null,
                  ),
                  title: Text(item['name']),
                  subtitle: Text(item['description']),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: null,
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => null,
        tooltip: 'Add new',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
