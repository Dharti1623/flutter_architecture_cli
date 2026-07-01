class UserResponse {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? website;

  UserResponse({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.website,
  });

  UserResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    email = json['email'] as String?;
    phone = json['phone'] as String?;
    website = json['website'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['website'] = website;
    return data;
  }
}
