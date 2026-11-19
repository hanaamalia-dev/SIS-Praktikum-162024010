import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

/// Model Post yang merepresentasikan data dari JSONPlaceholder
/// Menggunakan @JsonSerializable() untuk otomatisasi parsing JSON (Best Practice)
@JsonSerializable()
class Post {
  final int? userId;
  final int id;
  final String title;
  final String? body;

  Post({
    this.userId,
    required this.id,
    required this.title,
    this.body,
  });

  /// Factory method untuk deserialisasi (JSON String menjadi Map menjadi Objek Post)
  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  /// Method untuk serialisasi (Objek Post menjadi Map menjadi JSON String)
  Map<String, dynamic> toJson() => _$PostToJson(this);

  /// Helper copyWith untuk memudahkan update state lokal
  Post copyWith({
    int? userId,
    int? id,
    String? title,
    String? body,
  }) {
    return Post(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }
}