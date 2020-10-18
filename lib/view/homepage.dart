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
      backgroundColor: Colors.grey[200],
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
                var doc = snapshot.data.docs[i];
                var item = doc.data();
                var itemRef = doc.reference.id;

                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 3,
                            spreadRadius: 2)
                      ],
                      borderRadius: BorderRadius.circular(5)),
                  margin: EdgeInsets.all(5),
                  child: ListTile(
                    title: Text(item['name']),
                    subtitle: Text(item['description'] + itemRef),
                    trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('ongs')
                              .doc(itemRef)
                              .delete();
                        }),
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => modalCreate(context),
        tooltip: 'Add new',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  modalCreate(BuildContext context) {
    GlobalKey<FormState> form = GlobalKey<FormState>();

    var name = TextEditingController();
    var email = TextEditingController();
    var description = TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Cadastre sua ONG:'),
            content: Form(
              key: form,
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Nome da ONG'),
                      controller: name,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Campo vazio. Tente novamente';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(hintText: 'E-mail'),
                      controller: email,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Campo vazio. Tente novamente';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Descrição'),
                      controller: description,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Campo vazio. Tente novamente';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Fechar'),
              ),
              FlatButton(
                onPressed: () async {
                  if (form.currentState.validate()) {
                    await FirebaseFirestore.instance.collection('ongs').add({
                      'name': name.text,
                      'email': email.text,
                      'description': description.text,
                      'date': Timestamp.now(),
                    });
                  }
                  Navigator.pop(context);
                },
                textColor: Colors.white,
                color: Colors.red[400],
                child: Text('Salvar'),
              ),
            ],
          );
        });
  }
}
