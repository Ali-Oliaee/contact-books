import 'dart:io';

import 'package:contactsproject/Models/contacts.dart';
import 'package:contactsproject/store/contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:contactsproject/Widgets/searchInput.dart';
import 'package:contactsproject/pages/addeditcontact.dart';
import 'package:contactsproject/pages/contactdetails.dart';
import 'package:contactsproject/pages/favcontacts.dart';
import 'package:contactsproject/pages/setting.dart';

class allcontacts extends StatefulWidget {
  @override
  State<allcontacts> createState() => _allcontacts();
}

class _allcontacts extends State<allcontacts> {
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchContacts();
    searchController.addListener(_filterContacts);
  }

  Future<void> _fetchContacts() async {
    final contactMaps = await DatabaseHelper.instance.queryAllContacts();
    setState(() {
      _contacts =
          contactMaps.map((contactMap) => Contact.fromMap(contactMap)).toList();
      _filteredContacts = _contacts;
    });
  }

  void _filterContacts() {
    final query = searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _contacts.where((contact) {
        return contact.name.toLowerCase().contains(query) ||
            (contact.numbers['mob'] ?? '').contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'My Contacts',
              textAlign: TextAlign.start,
            ),
            actions: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.settings_sharp,
                      size: 24,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => setting()),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.star_outline,
                      size: 24,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => favcontacts()),
                      );
                    },
                  ),
                ],
              ),
            ],
            centerTitle: false,
            elevation: 2,
          ),
          body: Column(children: [
            SearchInput(searchController),
            Container(
              alignment: Alignment.bottomLeft,
              child: const Padding(
                  padding: EdgeInsets.only(left: 16, bottom: 12, top: 24),
                  child: Text(
                    'Contacts',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: _filteredContacts.length,
                  padding: const EdgeInsets.only(right: 16, left: 16),
                  itemBuilder: (context, index) {
                    var contact = _filteredContacts[index];
                    return Dismissible(
                        key: UniqueKey(),
                        background: Container(color: Colors.red),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          DatabaseHelper.instance.deleteContact(contact.id);
                          _fetchContacts();
                        },
                        child: GestureDetector(
                            onTap: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => contact_details(
                                            'Contact Details', contact.id)),
                                  )
                                },
                            child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(-1, 0),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: contact.avatar != null
                                                  ? Image.file(
                                                      File(contact.avatar!),
                                                      width: 60,
                                                      height: 60,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.asset(
                                                      'assets/images/default-avatar.jpg',
                                                      width: 60,
                                                      height: 60,
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(-1, 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        -1, 0),
                                                child: Text(
                                                  contact.name,
                                                  textAlign: TextAlign.start,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        0, 2),
                                                child: Text(
                                                  contact.numbers['mob'] ?? '',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                            color: Colors.grey,
                                            onPressed: () => {
                                                  if (contact.isFavorite)
                                                    {
                                                      contact.isFavorite =
                                                          false,
                                                      DatabaseHelper.instance
                                                          .updateContact(
                                                              contact),
                                                    }
                                                  else
                                                    {
                                                      contact.isFavorite = true,
                                                      DatabaseHelper.instance
                                                          .updateContact(
                                                              contact),
                                                    },
                                                  _fetchContacts()
                                                },
                                            icon: !contact.isFavorite
                                                ? const Icon(
                                                    Icons.favorite_border)
                                                : const Icon(
                                                    Icons.favorite,
                                                    color: Colors.red,
                                                  )),
                                        IconButton(
                                          onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    addeditpage(
                                                        'edit', contact.id)),
                                          ),
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                            )));
                  }),
            ),
          ]),
          floatingActionButton: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => addeditpage('add', null)),
              );
            },
            backgroundColor: Colors.blueAccent,
            elevation: 8,
            child: const Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 24,
            ),
          )),
    );
  }
}
