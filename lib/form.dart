import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model/montre.dart';

// Form to create a new montre

Future<Montre> createMontre(
    String title, String image, String prix, String description) async {
  final response = await http.post(
      Uri.parse(
          'https://my-json-server.typicode.com/maxencelgy/my-json-montres/montres/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'image': image,
        'price': prix.toString(),
        'description': description,
      }));
  if (response.statusCode == 201) {
    return Montre.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Arrive pas ');
  }
}

class FormWidget extends StatefulWidget {
  const FormWidget({Key? key}) : super(key: key);

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final TextEditingController _controller_title = TextEditingController();
  final TextEditingController _controller_image = TextEditingController();
  final TextEditingController _controller_price = TextEditingController();
  final TextEditingController _controller_description = TextEditingController();
  Future<Montre>? _futureMontre;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulaire',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.popUntil(
                  context, ModalRoute.withName(Navigator.defaultRouteName));
            },
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: (_futureMontre == null) ? buildColumn() : buildFutureBuilder(),

        ),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Ajouter une montre',
          style: TextStyle(fontSize: 24),
        ),
        TextField(
          controller: _controller_title,
          decoration: const InputDecoration(hintText: 'Entre un titre'),
        ),
        TextField(
          controller: _controller_image,
          decoration: const InputDecoration(hintText: 'Entre un image'),
        ),
        TextField(
          controller: _controller_price,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Entre un prix'),
        ),
        TextField(
          controller: _controller_description,
          decoration: const InputDecoration(hintText: 'Description'),
        ),
        ElevatedButton(
            onPressed: () => {
                  setState(() {
                    _futureMontre = createMontre(
                        _controller_title.text,
                        _controller_image.text,
                        _controller_price.text,
                        _controller_description.text);
                  })
                },
            child: const Text('Insert une Montre'))
      ],
    );
  }

  FutureBuilder<Montre> buildFutureBuilder() {
    return FutureBuilder<Montre>(
        future: _futureMontre,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.title);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        });
  }
}
