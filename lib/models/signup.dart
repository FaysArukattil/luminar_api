// ignore_for_file: no_leading_underscores_for_local_identifiers

class Signup {
  String? status;
  String? msg;
  Errors? errors;

  Signup({this.status, this.msg, this.errors});

  Signup.fromJson(Map<String, dynamic> json) {
    if (json["Status"] is String) {
      status = json["Status"];
    }
    if (json["Msg"] is String) {
      msg = json["Msg"];
    }
    if (json["Errors"] is Map) {
      errors = json["Errors"] == null ? null : Errors.fromJson(json["Errors"]);
    }
  }

  static List<Signup> fromList(List<Map<String, dynamic>> list) {
    return list.map(Signup.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["Status"] = status;
    _data["Msg"] = msg;
    if (errors != null) {
      _data["Errors"] = errors?.toJson();
    }
    return _data;
  }
}

class Errors {
  List<String>? phone;
  List<String>? pincode;
  List<String>? email;

  Errors({this.phone, this.pincode, this.email});

  Errors.fromJson(Map<String, dynamic> json) {
    if (json["phone"] is List) {
      phone = json["phone"] == null ? null : List<String>.from(json["phone"]);
    }
    if (json["pincode"] is List) {
      pincode = json["pincode"] == null
          ? null
          : List<String>.from(json["pincode"]);
    }
    if (json["email"] is List) {
      email = json["email"] == null ? null : List<String>.from(json["email"]);
    }
  }

  static List<Errors> fromList(List<Map<String, dynamic>> list) {
    return list.map(Errors.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (phone != null) {
      _data["phone"] = phone;
    }
    if (pincode != null) {
      _data["pincode"] = pincode;
    }
    if (email != null) {
      _data["email"] = email;
    }
    return _data;
  }
}
