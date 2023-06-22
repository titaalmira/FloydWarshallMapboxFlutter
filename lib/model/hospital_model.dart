class Hospital {
  final String pictureUrl;
  final String name;
  final String address;
  final String category;
  final String phoneNumber;
  final String openingTime;
  final String closingTime;
  final String openingDays;
  final double latitude;
  final double longitude;
  final List<Doctor> doctors;
  final List<String> politeknik;

  Hospital({
    required this.pictureUrl,
    required this.name,
    required this.address,
    required this.category,
    required this.phoneNumber,
    required this.openingTime,
    required this.closingTime,
    required this.openingDays,
    required this.latitude,
    required this.longitude,
    required this.doctors,
    required this.politeknik
  });


  factory Hospital.fromJson(Map<String, dynamic> json) {
    List<String> daftarPoliteknik = [
      "Politeknik","Politeknk"
    ];
    return Hospital(
      pictureUrl: json['pictureUrl'],
      name: json['name'],
      address: json['address'],
      category: json['category'],
      phoneNumber: json['phoneNumber'],
      openingTime: json['openingTime'],
      closingTime: json['closingTime'],
      openingDays: json['openingDays'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      doctors: (json['doctors'] as List<dynamic>).map((docJson) => Doctor.fromJson(docJson)).toList(),
      politeknik: daftarPoliteknik,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pictureUrl': pictureUrl,
      'name': name,
      'address': address,
      'category': category,
      'phoneNumber': phoneNumber,
      'openingTime': openingTime,
      'openingDays': openingDays,
      'latitude': latitude,
      'longitude': longitude,
      'doctors': doctors.map((doctor) => doctor.toJson()).toList(),
    };
  }
}

class Doctor {
  final String name;
  final String specialty;
  final String profilePictureUrl;

  Doctor({
    required this.name,
    required this.specialty,
    required this.profilePictureUrl,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      name: json['name'],
      specialty: json['specialty'],
      profilePictureUrl: json['profilePictureUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'specialty': specialty,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}