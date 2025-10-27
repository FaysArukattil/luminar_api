class User {
  String? refresh;
  String? access;
  int? id;
  String? name;
  String? place;
  String? email;

  User({this.refresh, this.access, this.id, this.name, this.place, this.email});

  User.fromJson(Map<String, dynamic> json) {
    if (json["refresh"] is String) {
      refresh = json["refresh"];
    }
    if (json["access"] is String) {
      access = json["access"];
    }
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["place"] is String) {
      place = json["place"];
    }
    if (json["email"] is String) {
      email = json["email"];
    }
  }

  static List<User> fromList(List<Map<String, dynamic>> list) {
    return list.map(User.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["refresh"] = refresh;
    data["access"] = access;
    data["id"] = id;
    data["name"] = name;
    data["place"] = place;
    data["email"] = email;
    return data;
  }
}
