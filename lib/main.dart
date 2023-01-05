import 'dart:convert';

import 'package:call_api/form.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model/montre.dart';

void main() {
  runApp(const MyApp());
}

List<Montre> parseMontres(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Montre>((json) => Montre.fromJson(json)).toList();
}

Future<List<Montre>> fetchAllMontre() async {
  final response = await http.get(Uri.parse('https://my-json-server.typicode.com/AntoineBrevet/MontresJson/montres'));
  if (response.statusCode == 200) {
    return compute(parseMontres, response.body);
  } else {
    throw Exception('J\'ai pas reussi frère ');
  }
}

Future<Montre> fetchMontre() async {
  final response = await http.get(Uri.parse('https://my-json-server.typicode.com/AntoineBrevet/MontresJson/montres/1'));
  if (response.statusCode == 200) {
    return Montre.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('J\'ai pas reussi frère ');
  }
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Les montres'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Montre> futureMontre;

  @override
  void initState() {
    super.initState();
    futureMontre = fetchMontre();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const FormWidget()),);
          },
          child: const Icon(
            Icons.add_box_outlined,
          ),
        ),
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<Montre>>(
          future: fetchAllMontre(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('J\'ai pas reussi frère'),
              );
            } else if (snapshot.hasData) {
              return MontreList(montre: snapshot.data!);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
class MontreDetailView extends StatelessWidget {
  const MontreDetailView({required this.montre});

  final Montre montre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(montre.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.network(montre.image),
            Text(montre.price),
            Text(montre.description),
          ],
        ),
      ),
    );
  }
}


class MontreList extends StatelessWidget {
  const MontreList({required this.montre});

  final List<Montre> montre;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemCount: montre.length,
      itemBuilder: (context, index) {
        return InkWell(
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(montre[index].title), // Titre de la montre
                Text(montre[index].price), // Prix de la montre
                Image.network(montre[index].image), // Image de la montre
              ],
            ),
          ),
          onTap: () {
            // Lorsque l'utilisateur appuie sur la carte, naviguez vers la vue détaillée de la montre
            Navigator.push(context, MaterialPageRoute(builder: (context) => MontreDetailView(montre: montre[index])),);
          },
        );
      },
    );
  }
}



