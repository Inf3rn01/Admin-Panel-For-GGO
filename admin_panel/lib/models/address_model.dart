import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  String id;
  final String country;
  final String city;
  final String street;
  final String house;
  final String apartment;
  bool selectedAddress;

  AddressModel({
    required this.id,
    required this.country,
    required this.city,
    required this.street,
    required this.house,
    required this.apartment,
    this.selectedAddress = true,
  });
  
  static AddressModel empty() => AddressModel(id: '', country: '', city: '', street: '', house: '', apartment: '');

  Map<String, dynamic> toJson() {
    return {
      'Country': country,
      'City': city,
      'Street': street,
      'House': house,
      'Apartment': apartment,
      'SelectedAddress': selectedAddress,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> data) {
    return AddressModel(
      id: data['Id'] as String,
      country: data['Country'] as String,
      city: data['City'] as String,
      street: data['Street'] as String,
      house: data['House'] as String,
      apartment: data['Apartment'] as String,
      selectedAddress: data['SelectedAddress'] as bool,
    );
  }

  factory AddressModel.fromDocumentSnaphot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return AddressModel(
      id: snapshot.id,
      country: data['Country'] ?? '',
      city: data['City'] ?? '',
      street: data['Street'] ?? '',
      house: data['House'] ?? '',
      apartment: data['Apartment'] ?? '',
      selectedAddress: data['SelectedAddress'] as bool,
    );
  }

  @override
  String toString() {
    return '$country, $city, $street, $house, $apartment';
  }


}
