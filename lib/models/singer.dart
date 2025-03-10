class Singer {
  final int id;
  final String name;
  final String? image;
  
  Singer({
    required this.id,
    required this.name,
    this.image,
  });
  
  factory Singer.fromJson(Map<String, dynamic> json) {
    return Singer(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}