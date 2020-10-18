import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './view/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Save the Day',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: HomePage.tag,
      routes: {
        HomePage.tag: (context) => HomePage(),
      },
    );
  }
}

// @override
//   void initState() {
//     super.initState();
//     Firebase.initializeApp().whenComplete(() {
//       FirebaseFirestore.instance.collection('ongs').get().then((value) {
//         value.docs.forEach((element) {
//           print(element.data());
//         });
//       });
//       setState(() {});
//     });
//   }
