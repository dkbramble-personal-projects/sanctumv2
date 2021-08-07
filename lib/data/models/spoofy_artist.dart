class Artist {
  final String name;
  final String id;

  Artist(this.name, this.id);

  Artist.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'];
}