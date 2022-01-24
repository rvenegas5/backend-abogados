import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

const url = 'localhost:8181';
dynamic idUsuarioActual;
dynamic idAbogadoSeleccionado;
dynamic infoAbogadoUser;
dynamic infoAbogado;
dynamic calificaciones;
dynamic calificacionUsuario;
dynamic textoRating;
dynamic rating;

var star = Icon(
  Icons.star,
  color: Colors.amber,
  size: 30.0,
  semanticLabel: 'Text to announce in accessibility modes',
);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        //brightness: Brightness.dark,
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
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getInfoAbogado(), // function where you call your api
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text('Please wait its loading...'));
          } else {
            return Scaffold(
                appBar: AppBar(),
                drawer: Drawer(
                    child:
                        ListView(padding: EdgeInsets.zero, children: <Widget>[
                  Container(
                      height: 70,
                      child: DrawerHeader(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                          ),
                          child: Text('ABONET',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20)))),
                  ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text('Log Out')),
                  ListTile(
                      leading: Icon(Icons.search),
                      title: Text('Buscar Abogados'))
                ])),
                body: Center(
                  child: ListView(
                    children: <Widget>[
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                CircleAvatar(
                                    backgroundColor: Colors.blueGrey,
                                    minRadius: 35.0),
                                CircleAvatar(
                                  backgroundColor: Colors.white70,
                                  minRadius: 60.0,
                                  child: CircleAvatar(
                                    radius: 50.0,
                                    backgroundImage:
                                        NetworkImage(infoAbogado['imagen']),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () => {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                // Retrieve the text the that user has entered by using the
                                                // TextEditingController.
                                                content: Text(
                                                    "Se abre el chat con el abogado"),
                                              );
                                            },
                                          )
                                        },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.blue.shade300,
                                      minRadius: 35.0,
                                      child: Icon(
                                        Icons.message,
                                        size: 30.0,
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              infoAbogadoUser['nombres'] +
                                  " " +
                                  infoAbogadoUser['apellidos'],
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                                    onTap: () => {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                // Retrieve the text the that user has entered by using the
                                                // TextEditingController.
                                                content: Text(
                                                    "Se abrirá ventana emergente para dar o actualizar una calificación"),
                                              );
                                            },
                                          )
                                        },
                                    child: RatingBar.builder(
                                      ignoreGestures:true,
                                initialRating: rating,
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  putOrPostCalificaciones();
                                 
                                },
                              )),
                              Text(
                              textoRating,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                            
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                'Email',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                infoAbogadoUser['email'],
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Divider(),
                            ListTile(
                              title: Text(
                                'Dirección',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                infoAbogadoUser['direccion'],
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Divider(),
                            ListTile(
                              title: Text(
                                'Linkedin',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                infoAbogado['linkedin'],
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Divider(),
                            ListTile(
                              title: Text(
                                'Teléfono',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                infoAbogadoUser['telefono'],
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Divider(),
                            ListTile(
                              title: Text(
                                'Especialización',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                infoAbogado['especializacion'],
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Divider(),
                            ListTile(
                              title: Text(
                                'Bufete',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                infoAbogado['bufete'],
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ));
          }
        });
  }
}

Future<String> getInfoAbogado() async {
  print("entramos");
  idAbogadoSeleccionado = 1;
  dynamic idUsuarioAbogado;
  var response = await http
      .get(Uri.http(url, '/abogado/' + idAbogadoSeleccionado.toString()));
  if (response.statusCode == 200) {
    
    var jsonResponse = convert.jsonDecode(response.body);
    infoAbogado = jsonResponse;
    print('Infoabogado: $infoAbogado.');
    idUsuarioAbogado = infoAbogado["id_usuario"];
    print(idUsuarioAbogado);
  } else {
    
    print('Request failed with status: ${response.statusCode}.');
  }
  var response2 =
      await http.get(Uri.http(url, '/usuario/' + idUsuarioAbogado.toString()));
  if (response2.statusCode == 200) {
    var jsonResponse2 = convert.jsonDecode(response2.body);
    infoAbogadoUser = jsonResponse2;
    print('InfoabogadoUser: $infoAbogadoUser.');
  } else {
    print('Request failed with status: ${response2.statusCode}.');
  }
  return getCalificaciones(idAbogadoSeleccionado);
  
}

Future<String> getCalificaciones(int abogado) async {
  idAbogadoSeleccionado = abogado;
  var response3 =
      await http.get(Uri.http(url, '/calificacion/' + idAbogadoSeleccionado.toString()));
  if (response3.statusCode == 200) {
    var jsonResponse3 = convert.jsonDecode(response3.body);
    calificaciones = jsonResponse3;
    print('calificaciones: $calificaciones.');
    if(calificaciones.toString()=="[]"){
      rating=0.0;
      print("mostrar calificacion");
      textoRating="Aún no hay calificaciones, se el primero en calificar!";
      }
  else{
    print("esta entrando");
    var prom=0.0;
    var ncal=0;
    for(var c in calificaciones){
      
      print(c['estrellas'].runtimeType);
      print(c['estrellas']);
      prom=prom+double.parse(c['estrellas']);     
      ncal++;    
    }
    
    rating=prom/ncal;
    
    textoRating="numero de calificaciones: "+ncal.toString();

  }return "todo piola";
  } else {
    print('Request failed with status: ${response3.statusCode}.');
    return "f";
  }
  
}



Future<String> putOrPostCalificaciones() async {
  idAbogadoSeleccionado = 1;
  idUsuarioActual = 2;
    if(calificaciones.toString()=="[]"){
      print("aqui va un post de calificacion");
      return "calif añadida"; 
      }
    for(var c in calificaciones){
      if(c['id_usuario']==idUsuarioActual){
        print("aqui va un put");
        return "calif actualizada";
      }  
    };

    print("aqui va un post de calificacion");
    return "calif añadida"; 
  
}
