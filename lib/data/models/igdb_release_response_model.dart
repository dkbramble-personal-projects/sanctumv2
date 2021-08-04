// User.fromJson(Map<String, dynamic> json)
// : name = json['name'],
// email = json['email'];

class IDGBGameRelease {
  final String name;
  int? firstReleaseDate;

  IDGBGameRelease(this.name, this.firstReleaseDate);

  IDGBGameRelease.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        firstReleaseDate = json['first_release_date'];

  // Map<String, dynamic> toJson() => {
  //   'name': name,
  //   'email': email,
  // };
}