import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../util/contact.dart';
import '../../controller/contact_controller.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  final ContactController contactController=Get.find();
  final _formKey=GlobalKey<FormState>();

  void showInputDialog(String header) {
    Get.defaultDialog(
        title: header,
        content: Container(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
            children: [
              TextFormField(
                initialValue: contactController.contact.value.firstName,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.first_page_outlined),
                    labelText: "First Name",
                    border: OutlineInputBorder(
                      gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                    )
                ),
                validator: (newValue) {
                  if (newValue==null || newValue.isEmpty) {
                    return "First name required";
                  }
                  return null;
                },
                onSaved: (updatedValue) {
                  contactController.contact.value.firstName=updatedValue;
                },
              ),
              const SizedBox(height: 10.0,),
              TextFormField(
                initialValue: contactController.contact.value.lastName,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.last_page_outlined),
                  labelText: "Last Name",
                  border: OutlineInputBorder(
                      gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                  )
                ),
                onSaved: (updatedValue) {
                  contactController.contact.value.lastName=updatedValue;
                },
              ),
              const SizedBox(height: 10.0,),
              TextFormField(
                initialValue: contactController.contact.value.contactNumber==0?"":contactController.contact.value.contactNumber.toString(),
                maxLength: 10,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone_outlined),
                    labelText: "Mobile Number",
                    border: OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                    )
                ),
                validator: (newValue) {
                  if (newValue==null || newValue.isEmpty) {
                    return "This is a required field";
                  }
                  if (newValue.length!=10) {
                    return "Invalid Mobile Number";
                  }
                  if (int.parse(newValue)<7000000000) {
                    return "Invalid Mobile Number";
                  }
                  return null;
                },
                onSaved: (updatedValue) {
                  contactController.contact.value.contactNumber=int.parse(updatedValue!);
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      int status=0;
                      if (contactController.contact.value.id!="") {
                        status=await updateContact(contactController.contact.value);
                      } else {
                        status=await createContact(contactController.contact.value);
                      }
                      if (status==201 || status==200) {
                        Navigator.of(Get.overlayContext!).pop();
                      } else {
                        Get.snackbar("An error occurred", "Unable to process request", snackPosition: SnackPosition.BOTTOM);
                      }
                    }
                  },
                  child: const Text("Done")
              )
            ],
          ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("☎ PhoneBook"),
        centerTitle: true,
      ),
      body: Row(
        children: [
          Expanded(
              flex: 3,
              child: Container()
          ),
          Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text("Contacts", style: headingStyle())),
                        ElevatedButton(onPressed: () {
                          contactController.clearContact();
                          showInputDialog("Add Contact");
                        }, child: Text("+ Add Contact", style: subtitleStyle(),),
                        )
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.015,),
                    CupertinoSearchTextField(
                      placeholder: "Search for contact...",
                      onChanged: (newValue) async {
                        getContacts(q: newValue);
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.015,),
                    Expanded(
                        child: FutureBuilder(
                            future: getContacts(),
                            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                              if (snapshot.hasData) {
                                return SizedBox(
                                  height: MediaQuery.of(context).size.height*0.6,
                                  child: Obx(() => ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: contactController.contactList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return ListTile(
                                        title: Text(
                                            "${contactController.contactList[index].firstName!} ${contactController.contactList[index].lastName!}".trim(),
                                          style: titleStyle(),
                                        ),
                                        subtitle: Text(
                                            "📞 ${contactController.contactList[index].contactNumber!.toString().substring(0, 5)}-${contactController.contactList[index].contactNumber!.toString().substring(5, 10)}",
                                          style: subtitleStyle(),
                                        ),
                                        trailing: IconButton(onPressed: () async {
                                          await deleteContact(contactController.contactList[index].id.toString());
                                        }, icon: const Icon(Icons.delete_forever_outlined, size: 28.0, color: Colors.red,), splashRadius: 20.0,),
                                        onTap: () {
                                          contactController.contact.value=contactController.contactList[index];
                                          showInputDialog("Update Contact");
                                        },
                                      );
                                    },
                                    separatorBuilder: (BuildContext context, int index)=>const Divider(),
                                  )),
                                );
                              }
                              return Center(child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 10.0,),
                                  Text("Fetching Contacts...")
                                ],
                              ));
                            }
                        )
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.015,),
                    Text("Crafted with ❤ by CRYP73R", style: creditStyle(),),
                    Text("* Loading might be slow as application is running on Free Tier", style: messageStyle(),)
                  ],
                ),
              )
          ),
          Expanded(
              flex: 3,
              child: Container()
          )
        ],
      ),
    );
  }

  TextStyle headingStyle() {
    return const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 25.0
    );
  }

  TextStyle titleStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w100,
      fontSize: 20.0
    );
  }

  TextStyle subtitleStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 16.0
    );
  }

  TextStyle creditStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 13.0
    );
  }

  TextStyle messageStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w200,
      fontSize: 12.0
    );
  }
}
