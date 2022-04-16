class Record {
  String? response;
  String? error;
  List<Data>? data;

  Record({this.response, this.error, this.data});

  Record.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    error = json['error'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response'] = this.response;
    data['error'] = this.error;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? image;
  String? game;
  String? time;
  String? description;
  String? username;

  Data(
      {this.id,
        this.image,
        this.game,
        this.time,
        this.description,
        this.username});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    game = json['game'];
    time = json['time'];
    description = json['description'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['game'] = this.game;
    data['time'] = this.time;
    data['description'] = this.description;
    data['username'] = this.username;
    return data;
  }
}