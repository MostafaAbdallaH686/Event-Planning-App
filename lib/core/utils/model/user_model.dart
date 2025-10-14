// ToDo later ::Mostafa

// import 'package:to_do_app/core/network/api_keypoint.dart';

// class UserModel {
//   final String phone;
//   final String password;
//   final String? displayName;
//   final int? experienceYears;
//   final String? address;
//   final String? level;

//   // Fields only available from profile response:
//   final String? id;
//   final List<String>? roles;
//   final bool? active;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;

//   UserModel({
//     required this.phone,
//     required this.password,
//     this.displayName,
//     this.experienceYears,
//     this.address,
//     this.level,
//     this.id,
//     this.roles,
//     this.active,
//     this.createdAt,
//     this.updatedAt,
//   });

//   /// Used when registering (only selected fields)
//   Future<Map<String, dynamic>> toMap() async {
//     final data = <String, dynamic>{
//       ApiKeypoint.phone: phone,
//       ApiKeypoint.password: password,
//     };

//     if (experienceYears != null) {
//       data[ApiKeypoint.experienceYears] = experienceYears;
//     }
//     if (level != null) data[ApiKeypoint.level] = level;
//     if (displayName != null) data[ApiKeypoint.displayName] = displayName;
//     if (address != null) data[ApiKeypoint.address] = address;

//     return data;
//   }

//   /// Used when parsing from profile response
//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['_id'] ?? '',
//       displayName: json['displayName'] ?? '',
//       phone: json['username'] ?? '',
//       password: '', // not returned from backend
//       roles: List<String>.from(json['roles'] ?? []),
//       active: json['active'] ?? false,
//       experienceYears: json['experienceYears'] ?? 0,
//       address: json['address'] ?? '',
//       level: json['level'] ?? '',
//       createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
//       updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
//     );
//   }
// }
// ToDo:: Mostafa :: Do not Touch Please

class OrderModel {
  final String eventName;
  final String eventDate;
  final String eventTime;
  final String location;
  final double totalPrice;
  late final String paymentMethod;
  final int ticketCount;
  final String imageUrl;

  OrderModel({
    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    required this.location,
    required this.totalPrice,
    required this.paymentMethod,
    required this.ticketCount,
    required this.imageUrl,
  });




}
