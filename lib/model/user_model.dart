class Users {
  String userId;
  List<String> images;

  Users({
    required this.userId,
    required this.images,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        userId: json["userId"],
        images: List<String>.from(json["images"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "images": List<dynamic>.from(images.map((x) => x)),
      };
}
