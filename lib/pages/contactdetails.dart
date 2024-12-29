import 'dart:io';

import 'package:contactsproject/store/contacts.dart';
import 'package:flutter/material.dart';
import 'package:contactsproject/Models/contacts.dart';
import 'package:contactsproject/Widgets/appBar.dart';
import 'package:url_launcher/url_launcher.dart';

class contact_details extends StatefulWidget {
  String title;
  final int id;

  contact_details(this.title, this.id);

  @override
  State<contact_details> createState() => _allcontacts();
}

class _allcontacts extends State<contact_details> {
  late Contact currentContact;

  void _launchCaller(String mobileNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: mobileNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $mobileNumber';
    }
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch email client for $email';
    }
  }

  void _sendTextMessage(String mobileNumber) async {
    final Uri smsUri = Uri(scheme: 'sms', path: mobileNumber);
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      throw 'Could not send a text to $mobileNumber';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchContact();
  }

  Future<void> _fetchContact() async {
    final contactMap = await DatabaseHelper.instance.queryContact(widget.id);
    setState(() {
      currentContact = Contact.fromMap(contactMap[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: InnerAppbar('Contact Details', context,
            actionButton: IconButton(
                onPressed: () => {
                      if (currentContact.isFavorite)
                        {
                          currentContact.isFavorite = false,
                          DatabaseHelper.instance.updateContact(currentContact),
                        }
                      else
                        {
                          currentContact.isFavorite = true,
                          DatabaseHelper.instance.updateContact(currentContact),
                        },
                      _fetchContact()
                    },
                icon: !currentContact.isFavorite
                    ? const Icon(Icons.favorite_border)
                    : const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ))),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: const AlignmentDirectional(0, 0),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: (currentContact.avatar != null)
                      ? Image.file(
                          File(currentContact.avatar!),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/default-avatar.jpg',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
              child: Text(
                currentContact.name,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
              child: currentContact.numbers['mob'] != null
                  ? Container(
                      width: MediaQuery.sizeOf(context).width,
                      decoration: const BoxDecoration(),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Mobile',
                                ),
                                Text(
                                  currentContact.numbers['mob']!,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 4, 0),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.message,
                                      color: Color(0xFF746A6A),
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      _sendTextMessage(
                                          currentContact.numbers['mob']!);
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.phone,
                                    color: Color(0xFF7C7C7C),
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    _launchCaller(
                                        currentContact.numbers['mob']!);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : null,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              child: currentContact.numbers['home'] != null
                  ? Container(
                      width: MediaQuery.sizeOf(context).width,
                      decoration: const BoxDecoration(),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Home',
                                ),
                                Text(
                                  currentContact.numbers['home']!,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.phone,
                                    color: Color(0xFF7C7C7C),
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    _launchCaller(
                                        currentContact.numbers['home']!);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : null,
            ),
            Container(
              width: MediaQuery.sizeOf(context).width,
              decoration: const BoxDecoration(),
              child: currentContact.email != null
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Email',
                              ),
                              Text(currentContact.email!),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 4, 0),
                                child: GestureDetector(
                                  child: const Icon(
                                    Icons.attach_email,
                                    color: Color(0xFF746A6A),
                                    size: 24,
                                  ),
                                  onTap: () {
                                    _launchEmail(currentContact.email!);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
