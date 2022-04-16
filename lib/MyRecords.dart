import 'dart:convert';
import 'package:eindopdracht/AddRecord.dart';
import 'package:eindopdracht/DetailsPage.dart';
import 'package:flutter/material.dart';
import 'Record.dart';
import 'FileHandler.dart';
import 'main.dart';

class MyRecords extends StatefulWidget {
  const MyRecords({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyRecordsState();
}

class _MyRecordsState extends State<MyRecords> {
  late Future<Record> records;
  FileHandler handler = FileHandler();

  @override
  void initState() {
    records = fetchRecords();
    super.initState();
  }

  Future<bool> saveData(Record records) async {
    var file = await handler.writeRun(jsonEncode(records.toJson()));
    return await file.exists();
  }

  Future<Record> fetchRecords() async {
    return await getRecords();
  }

  Future<Record> getRecords() async {
    String json = "";
    // attempt to load from disk
    String? data = await handler.readRuns();
    print("data $data");
    if (data != null) {
      json = data;
      print("json $json");
      print(jsonDecode(json));
      var records = Record.fromJson(jsonDecode(json));
      print("records $records");
      return records;
    }

    throw Exception("no records were found");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Latest Speedrun"),
      ),
      body: FutureBuilder<Record>(
        future: records,
        builder: (context, snapshot) {
          print("snapshot ${snapshot.data}");
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
                                  snapshot.data?.data?.elementAt(index)),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(snapshot.data!.data?.elementAt(index).time
                                as String),
                            Text(snapshot.data!.data?.elementAt(index).username
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
                title: const Text("Your latest record"),
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
