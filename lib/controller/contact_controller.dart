import 'package:get/get.dart';
import '../model/contact.dart';

class ContactController extends GetxController {
  RxList<Contact> contactList=<Contact>[].obs;
  Rx<Contact> contact=Contact().obs;

  void addContact(Map<String, dynamic> parsedJson) {
    Contact newContact=Contact.fromJSON(parsedJson["data"]);
    contactList.insert(0, newContact);
    Get.snackbar(
      "Created Successfully",
      "${contact.value.firstName} added to PhoneBook",
      snackPosition: SnackPosition.BOTTOM
    );
  }

  void updateContactList(Map<String, dynamic> parsedJson) {
    contactList.clear();
    for (Map<String, dynamic> contact in parsedJson["data"]) {
      contactList.insert(0, Contact.fromJSON(contact));
    }
  }

  // void viewContact(Map<String, dynamic> parsedJson) {
  //   contact.value=Contact.fromJSON(parsedJson["data"]);
  // }

  void updateContact(Map<String, dynamic> parsedJson) {
    // viewContact(parsedJson);
    contact.value=Contact.fromJSON(parsedJson["data"]);
    for (int i=0; i<contactList.length; i++) {
      if (contactList[i].id==contact.value.id) {
        contactList[i]=contact.value;
        Get.snackbar(
            "Updated Successfully",
            "${contact.value.firstName} added to PhoneBook",
            snackPosition: SnackPosition.BOTTOM
        );
        break;
      }
    }
  }

  void removeContact(String id) {
    for (Contact cont in contactList) {
      if (cont.id==id) {
        contactList.remove(cont);
        Get.snackbar(
            "Removed Successfully",
            "${cont.firstName} removed from PhoneBook",
            snackPosition: SnackPosition.BOTTOM
        );
        break;
      }
    }
  }

  void clearContact() {
    contact.value=Contact();
  }
}