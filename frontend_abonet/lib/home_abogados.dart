import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:prueba/models/Abogado.dart';
import 'dart:convert' as convert;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:math';

const url = 'localhost:8181';
dynamic idUsuarioActual;
dynamic idAbogadoSeleccionado;
dynamic infoAbogadoUser;
dynamic _abogados;
dynamic calificaciones;

var star = Icon(
  Icons.star,
  color: Colors.amber,
  size: 10.0,
  semanticLabel: 'Text to announce in accessibility modes',
);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MostrarAbogado(title: 'Principal'),
    );
  }
}

class MostrarAbogado extends StatefulWidget {
  final String title;
  const MostrarAbogado({
    Key? key,
    required this.title,
  }) : super(key: key);
  @override
  _MostrarAbogadoState createState() => _MostrarAbogadoState();
}

class _MostrarAbogadoState extends State<MostrarAbogado> {
  @override
  void initState() {
    super.initState();
    _abogados = _getAbogados();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Abogado>>(
        future: _abogados, // function where you call your api
        builder: (BuildContext context, AsyncSnapshot<List<Abogado>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Scaffold(
              appBar: AppBar(title: const Text('Home')),
              drawer: Drawer(
                  child: ListView(padding: EdgeInsets.zero, children: <Widget>[
                Container(
                    height: 70,
                    child: DrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: Text('ABONET',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)))),
                ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text('Log Out')),
                ListTile(
                    leading: Icon(Icons.search), title: Text('Buscar Abogados'))
              ])),
              body: Center(
                child: Container(
                  padding: const EdgeInsets.all(30.0),
                  child: ListView(children: _listAbogados(snapshot.data)),
                ),
              ),
            );
          }
        });
  }

  List<Widget> _listAbogados(data) {
    List<Widget> abogados = [];
    abogados.add(Text(
      'ABOGADOS DISPONIBLES',
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
    ));
    abogados.add(Text(
      'Puedes comunicarte con cualquier abogado consultando su perfil.',
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 15.0),
    ));
    for (var abogado in data) {
      Random random = new Random();
      abogados.add(Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white70,
              minRadius: 60.0,
              child: CircleAvatar(
                radius: 40.0,
                backgroundImage: NetworkImage(abogado.imagen),
              ),
            ),
            Text('Nombres: ' + abogado.nombres),
            Text('Apellidos: ' + abogado.apellidos),
            Text('Dirección: ' + abogado.direccion),
            RatingBar.builder(
              initialRating: random.nextInt(4) + 1,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
            TextButton(
              child: const Text('Ver Perfil'),
              onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text("Perfil del abogado"),
                  );
                },
              ),
            )
          ],
        ),
      ));
    }
    return abogados;
  }
}

Future<List<Abogado>> _getAbogados() async {
  List<Abogado> listaAbogados = [];

  var response = await http.get(Uri.http(url, '/usuario'));
  if (response.statusCode == 200) {
    String body = convert.utf8.decode(response.bodyBytes);
    final jsonData = convert.jsonDecode(body);
    for (var abogado in jsonData['result']) {
      listaAbogados.add(Abogado(
          abogado['id_abogado'],
          abogado['nombres'],
          abogado['apellidos'],
          abogado['bufete'],
          abogado['linkedin'],
          abogado['especializacion'],
          abogado['imagen'],
          abogado['telefono'],
          abogado['direccion'],
          abogado['email'],
          abogado['usuario']));
    }
    return listaAbogados;
  } else {
    throw Exception("Falló la conexión");
  }
}
