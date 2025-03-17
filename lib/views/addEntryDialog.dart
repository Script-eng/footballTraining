import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEntryDialog extends StatefulWidget {
  final String role;
  const AddEntryDialog({Key? key, required this.role}) : super(key: key);

  @override
  _AddEntryDialogState createState() => _AddEntryDialogState();
}

class _AddEntryDialogState extends State<AddEntryDialog> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  String roleDescription = "";
  File? _imageFile;
  String? _uploadedImageUrl;
  bool _isUploading = false;

  bool get isCoach => widget.role == "coach"; // Only for coaches

  // Pick image function (Only for Coaches)
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Upload image to Cloudinary (Only for Coaches)
  Future<void> _uploadToCloudinary() async {
    if (_imageFile == null) return;

    setState(() {
      _isUploading = true;
    });

    String cloudName = "dycj9nypi"; // Your Cloudinary cloud name
    String uploadPreset = "unsigned_preset"; // Set this in Cloudinary settings

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload'),
    );

    request.fields['upload_preset'] = uploadPreset;
    request.files
        .add(await http.MultipartFile.fromPath('file', _imageFile!.path));

    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    var jsonData = json.decode(responseData);

    if (response.statusCode == 200) {
      setState(() {
        _uploadedImageUrl = jsonData['secure_url']; // Get Cloudinary URL
        _isUploading = false;
      });
      print("Image uploaded: $_uploadedImageUrl");
    } else {
      print("Upload failed: ${jsonData['error']['message']}");
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Add Coach"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: "Name"),
              validator: (value) => value!.isEmpty ? "Enter a name" : null,
              onChanged: (value) => name = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Role Description"),
              validator: (value) =>
                  value!.isEmpty ? "Enter role description" : null,
              onChanged: (value) => roleDescription = value,
            ),

            const SizedBox(height: 10),

            // Show Image Picker Only for Coaches
            if (isCoach) ...[
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      _imageFile != null ? FileImage(_imageFile!) : null,
                  child: _imageFile == null
                      ? Icon(Icons.camera_alt, size: 30, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _uploadToCloudinary,
                child: _isUploading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Upload Image"),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: Text("Add"),
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFF27121)),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              if (isCoach && _uploadedImageUrl == null) {
                // If Coach, ensure an image is uploaded
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("Please upload an image for the Coach")),
                );
                return;
              }

              await FirebaseFirestore.instance.collection('users').add({
                "name": name,
                "role": "coach", // Auto-set role as coach
                "role_description": roleDescription,
                "picture": isCoach
                    ? _uploadedImageUrl ??
                        "https://example.com/default.jpg" // Default image if no upload
                    : "", // Other roles don't need an image
              });

              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
