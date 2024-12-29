import 'dart:io';

import 'package:contactsproject/Models/contacts.dart';
import 'package:contactsproject/Widgets/imagePicker.dart';
import 'package:contactsproject/store/contacts.dart';
import 'package:flutter/material.dart';
import 'package:contactsproject/Widgets/appBar.dart';
import 'package:contactsproject/Widgets/appInput.dart';
import 'dart:math';

class addeditpage extends StatefulWidget {
  String mode;
  final int? id;

  addeditpage(this.mode, this.id, {super.key});

  @override
  State<addeditpage> createState() => _addpage();
}

class _addpage extends State<addeditpage> {
  late Contact currentContact;
  final _formKey = GlobalKey<FormState>();
  String? _newAvatarPath;
  TextEditingController nameInputController = TextEditingController();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController phoneInputController = TextEditingController();
  TextEditingController homeInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.mode == 'edit') _fetchContact();
  }

  Future<void> _fetchContact() async {
    final contactMap = await DatabaseHelper.instance.queryContact(widget.id!);
    setState(() {
      currentContact = Contact.fromMap(contactMap[0]);
      nameInputController.text = Contact.fromMap(contactMap[0]).name;
      emailInputController.text = Contact.fromMap(contactMap[0]).email ?? '';
      phoneInputController.text =
          Contact.fromMap(contactMap[0]).numbers['mob'] ?? '';
      homeInputController.text =
          Contact.fromMap(contactMap[0]).numbers['home'] ?? '';
    });
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    final phoneRegExp = RegExp(r'^[0-9]{10}$');
    if (!phoneRegExp.hasMatch(value)) {
      return 'Please enter a valid phone number (10 digits)';
    }
    return null;
  }

  String? validateHome(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a home address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: InnerAppbar(
            widget.mode == 'add' ? 'Add Contact' : 'Edit Contact', context),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                      child:
                          widget.mode == 'add' || currentContact.avatar == null
                              ? UserImagePicker(
                                  onImagePicked: (path) {
                                    setState(() {
                                      _newAvatarPath = path;
                                    });
                                  },
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.file(
                                    File(currentContact.avatar!),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                    ),
                  ),
                  AppInput(
                      'Name', Icons.person, nameInputController, validateName),
                  AppInput('Email', Icons.email, emailInputController,
                      validateEmail),
                  AppInput('Phone', Icons.phone, phoneInputController,
                      validatePhone),
                  AppInput('Home', Icons.home_work_outlined,
                      homeInputController, validateHome),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        var newContact = Contact(
                          id: widget.mode == 'add'
                              ? Random().nextInt(10000)
                              : currentContact.id,
                          name: nameInputController.text,
                          email: emailInputController.text,
                          numbers: {
                            "mob": phoneInputController.text,
                            "home": homeInputController.text
                          },
                          isFavorite: widget.mode == 'add'
                              ? false
                              : currentContact.isFavorite,
                          avatar: _newAvatarPath,
                        );
                        if (widget.mode == 'add') {
                          DatabaseHelper.instance.insertContact(newContact);
                        } else {
                          DatabaseHelper.instance.updateContact(newContact);
                        }
                        Navigator.pop(context);
                      }
                    },
                    style: IconButton.styleFrom(),
                    child: Text(widget.mode == "add" ? 'Add' : 'Save'),
                  ),
                ],
              ),
            ))),
      ),
    );
  }
}
