class UserModel {
  final String id;
  final String name;
  final String phone;
  final String avatar;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'phone': phone, 'avatar': avatar};
  }

  factory UserModel.empty() {
    return UserModel(id: '', name: '', phone: '', avatar: '');
  }
}
