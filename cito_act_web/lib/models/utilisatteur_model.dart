class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String role;
  final String imageUrl;


  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.role,
    required this.imageUrl,

  });

  // Factory method pour créer un objet UserModel à partir d'un document Firestore
  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      uid: documentId,
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      phone: data['phone'] ?? '',
      role: data['role'] ?? '',
      imageUrl: data['imageUrl'] ?? '',

    );
  }

  // Méthode pour convertir un objet UserModel en Map (utile pour l'ajout ou la mise à jour dans Firestore)
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'role': role,
      'imageUrl': imageUrl,
    };
  }
}
