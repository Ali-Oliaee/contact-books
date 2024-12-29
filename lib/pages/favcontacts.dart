import 'package:contactsproject/Models/contacts.dart';
import 'package:contactsproject/store/contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:contactsproject/Widgets/searchInput.dart';
import 'package:contactsproject/pages/addeditcontact.dart';
import 'package:contactsproject/pages/contactdetails.dart';

class favcontacts extends StatefulWidget {
  @override
  State<favcontacts> createState() => _favcontacts();
}

class _favcontacts extends State<favcontacts> {
  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    final contactMaps = await DatabaseHelper.instance.queryAllFavContacts();
    setState(() {
      _contacts =
          contactMaps.map((contactMap) => Contact.fromMap(contactMap)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Fav Contacts',
              textAlign: TextAlign.start,
            ),
            centerTitle: false,
            elevation: 2,
          ),
          body: Column(children: [
            Container(
              alignment: Alignment.bottomLeft,
              child: const Padding(
                  padding: EdgeInsets.only(left: 16, bottom: 12, top: 24),
                  child: Text(
                    'Fav Contacts',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: _contacts.length,
                  padding: const EdgeInsets.only(right: 16, left: 16),
                  itemBuilder: (context, index) {
                    var contact = _contacts[index];
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
                              clipBehavior: Clip.antiAliasWithSaveLayer,
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
                                                  ? Image.network(
                                                      contact.avatar!,
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
                                                  if (_contacts
                                                      .contains(contact))
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
                                            icon: !_contacts.contains(contact)
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
