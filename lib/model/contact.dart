class Contact {
  String? id;
  String? firstName;
  String? lastName;
  int? contactNumber;

  Contact({this.id="", this.firstName="", this.lastName="", this.contactNumber=0});

  Contact.fromJSON(Map<String, dynamic> parsedJson) {
    id=parsedJson["_id"];
    firstName=parsedJson["firstName"];
    lastName=parsedJson["lastName"];
    contactNumber=parsedJson["contactNumber"];
  }
}