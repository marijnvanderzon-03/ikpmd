import 'dart:convert';
import 'package:eindopdracht/AddRecord.dart';
import 'package:eindopdracht/DetailsPage.dart';
import 'package:eindopdracht/MyRecords.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Record.dart';
import 'FileHandler.dart';

void main() {
  runApp(
    MaterialApp(
      title: "Speedrunners",
      home: MyApp(),
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(primary: Colors.red.shade900),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Record> records;
  FileHandler handler = FileHandler();

  @override
  void initState() {
    records = fetchRecords();
    super.initState();
  }

  Future<Record> fetchRecords() async {
    return await getRecords();
  }

  Future<Record> getRecords() async {
    String json = "";
    final response = await http.get(Uri.http("10.0.2.2:8080", "/record"));
    if (response.statusCode == 200) {
      json = response.body;
    } else {
      throw Exception("failed to load records, try again later");
    }
    Record records = Record.fromJson(jsonDecode(json));

    return records;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Speedrunners"),
      ),
      body: FutureBuilder<Record>(
        future: records,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.data?.length,
              itemBuilder: (BuildContext ctx, int index) {
                return ListTile(
                  leading: Text((index + 1).toString()),
                  title: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(
                              detailRecord:
                                  snapshot.data?.data?.elementAt(index)
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(snapshot.data?.data?.elementAt(index).time
                                as String),
                            Text(snapshot.data?.data?.elementAt(index).username
                                as String),
                          ],
                        ),
                        const Divider(
                          thickness: 1,
                          height: 6,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Text("buiten switch");
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(),
              child: Text("Speedrunners"),
            ),
            ListTile(
                title: const Text("Alle records"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const MyApp()));
                }),
            ListTile(
                title: const Text("your latest record"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyRecords()));
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => AddRecord()));
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
