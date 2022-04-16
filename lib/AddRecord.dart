import 'dart:io';

import 'package:eindopdracht/FileHandler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'MyRecords.dart';
import 'TimeTextInputFormatter.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddRecord extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddRecordState();
  FileHandler handler = new FileHandler();
}

class _AddRecordState extends State<AddRecord> {
  double get _deviceHeight {
    return (MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight));
  }

  TextEditingController _txtTimeController = TextEditingController();
  String? _game = "";
  String? _time = "";
  String? _description = "";
  String? _username = "";
  dynamic _image;
  String? imageName = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future _getImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: source);
    imageName = image?.name;
    // imageName = "/data/user/0/com.example.eindopdracht/cache/$imageName";
    File file = File(image!.path);

    setState(() {
      _image = image;
    });
  }

  Future<http.Response> sendHttp(String json) {
    return http.post(
      Uri.http("10.0.2.2:8080", "/record"),
      headers: <String, String>{'Content-Type': "application/json"},
      body: json,
    );
  }

  Future<http.StreamedResponse> sendPicture(XFile picture) async {
    File file = File(_image!.path);
    var request =
        http.MultipartRequest('POST', Uri.http("10.0.2.2:8080", "/uploadFile"));
    request.files.add(http.MultipartFile.fromBytes(
        'file', File(file.path).readAsBytesSync(),
        filename: file.path));
    var res = await request.send();
    return res;
  }

  Widget _buildGameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Game naam"),
      validator: (value) {
        if (value != null) {
          if (value.isEmpty) {
            return 'Game is required';
          }
        }
      },
      onSaved: (String? value) {
        _game = value;
      },
    );
  }

  Widget _buildTimeField() {
    return TextFormField(
      controller: _txtTimeController,
      keyboardType: TextInputType.numberWithOptions(decimal: false),
      decoration: InputDecoration(labelText: "tijd", hintText: '00:00:00'),
      inputFormatters: <TextInputFormatter>[TimeTextInputFormatter()],
      validator: (value) {
        if (value!.isEmpty) {
          return 'time is required';
        }
      },
      onSaved: (value) {
        _time = value;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Beschrijving"),
      validator: (value) {
        if (value != null) {
          if (value.isEmpty) {
            return 'Description is required';
          }
        }
      },
      onSaved: (value) {
        _description = value;
      },
    );
  }

  Widget _buildUserNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Gebruikersnaam"),
      validator: (value) {
        if (value != null) {
          if (value.isEmpty) {
            return 'Name is required';
          }
        }
      },
      onSaved: (value) {
        _username = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String data;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add speedrun"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildUserNameField(),
                _buildGameField(),
                _buildDescriptionField(),
                _buildTimeField(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        icon: Icon(Icons.photo_camera),
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () => {_getImage(ImageSource.camera)}),
                    IconButton(
                      icon: Icon(Icons.photo_library),
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () => {_getImage(ImageSource.gallery)},
                    )
                  ],
                ),
                // Image.file(_imageFile!),
                Padding(
                  padding: EdgeInsets.only(top: _deviceHeight * 0.1),
                  child: ElevatedButton(
                      child: Text("Submit"),
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            imageName!.length > 0) {
                          _formKey.currentState!.save();
                          data =
                              '{"image" : "$imageName", "game" : "$_game", "time" : "$_time", "description" : "$_description" , "username" : "$_username"}';

                          var dataLocalStorage =
                              '{"data" : [{"image" : "$imageName", "game" : "$_game", "time" : "$_time", "description" : "$_description" , "username" : "$_username"}]}';

                          await widget.handler.writeRun(dataLocalStorage);
                          await sendPicture(_image);
                          await sendHttp(data);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyRecords()));
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
