class Status {
  final String name;
  final String districtId;

  Status(this.name, this.districtId);

  Status.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        districtId = json['districtId'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'districtId': districtId,
      };
}
