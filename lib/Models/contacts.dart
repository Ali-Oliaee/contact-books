import 'dart:convert';

class Contact {
  int id;
  String name;
  Map<String, String> numbers;
  bool isFavorite = false;
  String? email = '';
  String? avatar = '';

  Contact(
      {required this.id,
      required this.name,
      required this.numbers,
      required this.isFavorite,
      this.avatar,
      this.email});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'numbers': json.encode(numbers),
      'is_favorite': isFavorite ? 1 : 0,
      'email': email,
      'avatar': avatar,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
        id: map['id'],
        name: map['name'],
        email: map['email'],
        avatar: map['avatar'],
        isFavorite: map['is_favorite'] == 0 ? false : true,
        numbers: _decodeNumbers(map['numbers']));
  }

  static Map<String, String> _decodeNumbers(String numbersJson) {
    String validJsonString = numbersJson
        .replaceAll(RegExp(r'(\w+):'), r'"$1":')
        .replaceAll(RegExp(r': (\d+)'), r': "$1"');

    return (json.decode(validJsonString) as Map<String, dynamic>).map(
      (key, value) => MapEntry(key, value.toString()),
    );
  }
}
