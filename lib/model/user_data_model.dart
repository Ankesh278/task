// File: user_model.dart

class userdata {
  final int id;
  final int age;
  final String image;
  final String fullname;
  final String demography;
  final String designation;
  final String location;

  userdata({
    required this.id,
    required this.age,
    required this.image,
    required this.fullname,
    required this.demography,
    required this.designation,
    required this.location,
  });

  factory userdata.fromJson(Map<String, dynamic> json) {
    return userdata(
      id: json['id'] ?? 0,
      age: json['age'] ?? 0,
      image: json['image'] ?? 'https://pravatar.cc/150',
      fullname: '${json['firstName'] ?? ''} ${json['lastName'] ?? ''}',
      demography: json['gender'] ?? 'Unknown',
      designation: json['company']?['title'] ?? 'Unknown',
      location: json['address']?['city'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'age': age,
      'image': image,
      'name': fullname,
      'demography': demography,
      'designation': designation,
      'location': location,
    };
  }
}
