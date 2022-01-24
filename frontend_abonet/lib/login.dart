import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

const url = 'localhost:50255';
dynamic usuarioData;
dynamic usuarioPass;
dynamic res;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Homework Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final userText = TextEditingController();
  final passText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: Text('Please wait its loading...'));
      } else {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Abonet',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 50,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Login',
                  style: TextStyle(color: Colors.grey, fontSize: 30),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: userText,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Correo electronico',
                        hintText: 'Ingrese un usuario valido'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: passText,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Contraseña',
                        hintText: 'Ingrese su contraseña'),
                  ),
                ),
                Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () {
                      //usuarioData = userText.text;
                      //usuarioPass = passText.text;
                      login(userText.text, passText.text);
                      showDialog(
                        context: context,
                        builder: (context) {
                          if (userText.text == "rarivera@outlook.com" &&
                              passText.text == "12345") {
                            return AlertDialog(
                              content: Text('Accesso Exitoso'),
                            );
                          } else {
                            return AlertDialog(
                              content: Text('Acceso Denegado'),
                            );
                          }
                          ;
                        },
                      );
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
  }
}

Future<void> login(String email, String password) async {
  usuarioData = email;
  usuarioPass = password;
  print("entro");
  var response = await http.get(Uri.http(url, '/auth/login/'));
  if (response.statusCode == 200) {
    print("Todo OK");
  } else {
    print("Todo no OK");
  }
}
