/// Domain Entity: User
///
/// Represents a user/creator in the application.
/// This is a pure Dart class with no external dependencies.
class UserEntity {
  final String name;
  final String avatarUrl;

  const UserEntity({required this.name, required this.avatarUrl});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
