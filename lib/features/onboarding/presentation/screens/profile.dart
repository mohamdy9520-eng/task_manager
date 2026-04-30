import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:task_manager_app/core/services/firestore_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;
  File? localImage;

  final TextEditingController nameController = TextEditingController();
  final FirestoreService firestore = FirestoreService();

  void _setNameOnce(String name) {
    if (nameController.text.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        nameController.text = name;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);

    final picked = await ImagePicker().pickImage(source: source);
    if (picked == null) return;

    setState(() {
      localImage = File(picked.path);
      isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_photos/${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg');

      await ref.putFile(localImage!);

      final photoUrl = await ref.getDownloadURL();

      await firestore.updateProfilePhoto(photoUrl);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated")),
      );
    } catch (e) {
      if (e.toString().contains('object-not-found')) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showPicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Gallery"),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            ListTile(
              title: const Text("Camera"),
              onTap: () => _pickImage(ImageSource.camera),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await firestore.updateUserName(nameController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Name updated")),
    );
  }

  Widget _avatar(String? url) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          child: ClipOval(
            child: localImage != null
                ? Image.file(
              localImage!,
              width: 120.w,
              height: 120.h,
              fit: BoxFit.cover,
            )
                : (url != null && url.isNotEmpty)
                ? Image.network(
              url,
              width: 120.w,
              height: 120.h,
              fit: BoxFit.cover,

              errorBuilder: (_, __, ___) {
                return Icon(Icons.person, size: 60.sp);
              },
            )
                : Icon(Icons.person, size: 60.sp),
          ),
        ),

        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _showPicker,
            child: CircleAvatar(
              radius: 18.r,
              backgroundColor: Colors.blue,
              child: Icon(Icons.camera_alt, color: Colors.white, size: 18.sp),
            ),
          ),
        ),

        if (isLoading)
          const Positioned.fill(
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: firestore.getUserProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text("No user data"));
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;

            final name = data["name"] ?? "User";
            final email = data["email"] ?? user?.email ?? "";
            final photo = data["photoUrl"];

            _setNameOnce(name);

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(height: 20.h),

                  _avatar(photo),

                  SizedBox(height: 30.h),

                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  ElevatedButton(
                    onPressed: _saveName,
                    child: const Text("Save Name"),
                  ),

                  SizedBox(height: 20.h),

                  ListTile(
                    title: const Text("Email"),
                    subtitle: Text(email),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}