import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:notes/ults/error.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';

class Post extends StatefulWidget {
  const Post({Key? key}) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  File? image;
  String imageUrl = "";
  bool loading = false;
  final database = FirebaseDatabase.instance.ref('Post');
  final postcontroller = TextEditingController();
  final _date = TextEditingController();
  final _time = TextEditingController();
  Reference referenceroot = FirebaseStorage.instance.ref();

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    try {
      if (pickedImage != null) {
        final imageTempory = File(pickedImage.path);
        setState(() {
          image = imageTempory;
        });
        Navigator.of(context).pop();
      }
    } on PlatformException catch (e) {
      print(" Error is " + e.toString());
    }
  }

  Future<void> getImageDownloadURL() async {
    String uniqueId = DateTime.now().microsecondsSinceEpoch.toString();
    Reference referenceDirImages = referenceroot.child('images');
    Reference referenceImage = referenceDirImages.child(uniqueId);
    try {
      await referenceImage.putFile(image!.absolute);
      imageUrl = await referenceImage.getDownloadURL();
      print('Image uploaded successfully. Download URL: $imageUrl');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  ADDdata() async {
    setState(() {
      loading = true;
    });
    database
        .child(DateTime.now().microsecondsSinceEpoch.toString())
        .set({
      'id': DateTime.now().microsecondsSinceEpoch.toString(),
      'data': postcontroller.toString(),
    }).then((value) {
      errorMessage().loadError("Post Added");
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      errorMessage().loadError(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("POST SCREEN "),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(child: Text("Add Image")),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.red,
                  width: 2.0,
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: 90,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 25.0, 8, 0),
                              child: GestureDetector(
                                  onTap: () => _pickImage(ImageSource.camera),
                                  child: Text("Camera")),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8.0, 8, 0),
                              child: GestureDetector(
                                  onTap: () =>
                                      _pickImage(ImageSource.gallery),
                                  child: Text("Gallery")),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: ClipOval(
                  child: image != null
                      ? Image.file(image!,
                      width: 160, height: 160, fit: BoxFit.cover)
                      : Image.asset(
                    'lib/Asserts/Images/flutter.png',
                    width: 160,
                    height: 160,
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                      child: Icon(Icons.calendar_month), onTap: Setdate),
                  SizedBox(width: 10.0), // Optional spacing between icon and text field
                  Expanded(
                    child: TextField(
                      controller: _date,
                      readOnly: true,
                      decoration: const InputDecoration(
                        hintText: 'Entered Date',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                      child: Icon(Icons.access_time), onTap: setTime),
                  SizedBox(width: 10.0), // Optional spacing between icon and text field
                  Expanded(
                    child: TextField(
                      controller: _time,
                      readOnly: true,
                      decoration: const InputDecoration(
                        hintText: 'Entered Time ',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: "Enter Text",
                  labelText: "Enter Text",
                  prefixIcon: Icon(Icons.textsms),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Plz Enter the  Password";
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  postcontroller.text = value;
                  setState(() {});
                  print(postcontroller.text);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  String uniqueId =
                  DateTime.now().microsecondsSinceEpoch.toString();
                  Reference referenceDirImages =
                  referenceroot.child('images');
                  Reference referenceImage =
                  referenceDirImages.child(uniqueId);
                  try {
                    await referenceImage.putFile(image!.absolute);
                    imageUrl = await referenceImage.getDownloadURL();
                    print('Image uploaded successfully. Download URL: $imageUrl');
                  } catch (e) {
                    print('Error uploading image: $e');
                  }
                  String id=DateTime.now().microsecondsSinceEpoch.toString();
                  database
                      .child(id)
                      .set({
                    'id': id,
                    'date': _date.text.toString(),
                    'time': _time.text.toString(),
                    'Image': imageUrl.toString(),
                    'data': postcontroller.text.toString(),
                  }).then((value) {
                    errorMessage().loadError("Post Added");
                    setState(() {
                      loading = false;
                    });
                  }).onError((error, stackTrace) {
                    errorMessage().loadError(error.toString());
                    setState(() {
                      loading = false;
                    });
                  });
                },
                child: loading == false
                    ? Text("Add")
                    : Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.yellow,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void Setdate() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(3000))
        .then((value) {
      setState(() {
        _date.text = "${value!.day}/${value!.month}/${value!.year}";
      });
    }).onError((error, stackTrace) {});
  }

  void setTime() {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) {
      setState(() {
        _time.text = value!.format(context).toString();
      });
    }).onError((error, stackTrace) {});
  }
}
