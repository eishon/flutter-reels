import 'package:reels_flutter/domain/entities/user_entity.dart';

/// Data model for User that extends UserEntity.
///
/// Adds serialization capabilities while inheriting
/// all properties from UserEntity.
class UserModel extends UserEntity {
  UserModel({required super.name, required super.avatarUrl});

  /// Creates a UserModel from JSON data.
  ///
  /// Handles the deserialization of user data from JSON structure.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['userName'] as String,
      avatarUrl: json['userAvatar'] as String,
    );
  }

  /// Converts this UserModel to a JSON map.
  Map<String, dynamic> toJson() {
    return {'userName': name, 'userAvatar': avatarUrl};
  }

  /// Creates a UserEntity from this model.
  UserEntity toEntity() {
    return UserEntity(name: name, avatarUrl: avatarUrl);
  }
}
