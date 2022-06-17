class Employe{
  String id;
  String firstName;
  String lastName;

  Employe({required this.id, required this.firstName, required this.lastName});

  factory Employe.fromJson(Map<String, dynamic> json){
    return Employe(
        id: json['id'] as String,
        firstName: json['first_name'] as String,
        lastName: json['last_name'] as String
    );
  }
}