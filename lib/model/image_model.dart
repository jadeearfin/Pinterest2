class Imagemodel {
  String title;
  String url;
  String description;

  Imagemodel({
    required this.title,
    required this.url,
    required this.description,
  });

  factory Imagemodel.fromJson(Map<String, dynamic> json) => Imagemodel(
        title: json["title"],
        url: json["url"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "url": url,
        "description": description,
      };
}
