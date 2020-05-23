class Contact {
  final String name;
  final String nicNumber;
  final String mainRoad;
  final String street;
  final String houseNo;
  final List<String> landmarks;
  final String contactNumber;
  final bool isDeleted;
  final String userID;

  Contact(this.name, this.nicNumber, this.mainRoad, this.street, this.houseNo,
      this.landmarks, this.contactNumber, this.isDeleted, this.userID);

  Contact.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        nicNumber = json['nicNumber'],
        mainRoad = json['mainRoad'],
        street = json['street'],
        houseNo = json['houseNo'],
        landmarks = json['landmarks'] as List,
        contactNumber = json['contactNumber'],
        isDeleted = json['isDeleted'],
        userID = json['userID'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'nicNumber': nicNumber,
        'mainRoad': mainRoad,
        'street': street,
        'houseNo': houseNo,
        'landmarks': landmarks,
        'contactNumber': contactNumber,
        'isDeleted': isDeleted,
        'userID': userID,
      };
}
