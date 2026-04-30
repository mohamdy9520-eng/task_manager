import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  // ================= INIT =================
  void _setNameOnce(String name) {
    if (nameController.text.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        nameController.text = name;
      });
    }
  }

  // ================= PICK IMAGE =================
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

      /// ✅ اسم صورة unique
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_photos/${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg');

      await ref.putFile(localImage!);

      final photoUrl = await ref.getDownloadURL();

      /// 🔥 حفظ اللينك في Firestore
      await firestore.updateProfilePhoto(photoUrl);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated ✅")),
      );
    } catch (e) {
      /// ❌ تجاهل error object-not-found
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

  // ================= SAVE NAME =================
  Future<void> _saveName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await firestore.updateUserName(nameController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Name updated ✅")),
    );
  }

  // ================= AVATAR =================
  Widget _avatar(String? url) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          child: ClipOval(
            child: localImage != null
                ? Image.file(
              localImage!,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            )
                : (url != null && url.isNotEmpty)
                ? Image.network(
              url,
              width: 120,
              height: 120,
              fit: BoxFit.cover,

              /// ✅ يمنع الكراش
              errorBuilder: (_, __, ___) {
                return const Icon(Icons.person, size: 60);
              },
            )
                : const Icon(Icons.person, size: 60),
          ),
        ),

        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _showPicker,
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blue,
              child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
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

  // ================= BUILD =================
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
                  const SizedBox(height: 20),

                  _avatar(photo),

                  const SizedBox(height: 30),

                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: _saveName,
                    child: const Text("Save Name"),
                  ),

                  const SizedBox(height: 20),

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