import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  final nameController = TextEditingController();

  bool isUpdatingName = false;
  bool isUploadingImage = false;

  // =========================================================
  // GET CURRENT USER ID
  // =========================================================

  String? get userId {
    return context.read<AuthCubit>().state?.uid;
  }

  // =========================================================
  // PICK PROFILE IMAGE
  // =========================================================

  Future<void> pickProfileImage() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image == null) {
        return;
      }

      setState(() {
        isUploadingImage = true;
      });

      final result = await context.read<AuthCubit>().uploadProfileImage(image);

      if (!mounted) return;

      setState(() {
        isUploadingImage = false;
      });

      if (result == null) {
        showMessage('Could not upload profile image');
      } else if (result == 'not-logged-in') {
        showMessage('Please login again');
      } else if (result == 'upload-failed') {
        showMessage('Image upload failed');
      } else {
        showMessage('Profile image updated successfully');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isUploadingImage = false;
      });

      showMessage('Could not select image');

      print('IMAGE PICKER ERROR: $e');
    }
  }

  // =========================================================
  // EDIT NAME
  // =========================================================

  void openEditNameDialog(String currentName) {
    nameController.text = currentName;

    showDialog(
      context: context,
      builder: (dialogContext) {
        bool dialogLoading = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Name'),

              content: TextField(
                controller: nameController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  hintText: 'Enter your name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),

              actions: [
                TextButton(
                  onPressed: dialogLoading
                      ? null
                      : () {
                          Navigator.pop(dialogContext);
                        },
                  child: const Text('Cancel'),
                ),

                ElevatedButton(
                  onPressed: dialogLoading
                      ? null
                      : () async {
                          final name = nameController.text.trim();

                          if (name.isEmpty) {
                            showMessage('Name cannot be empty');
                            return;
                          }

                          setDialogState(() {
                            dialogLoading = true;
                          });

                          final error = await context
                              .read<AuthCubit>()
                              .updateProfileName(name);

                          if (!mounted) return;

                          if (error == null) {
                            Navigator.pop(dialogContext);

                            showMessage('Name updated successfully');
                          } else {
                            setDialogState(() {
                              dialogLoading = false;
                            });

                            showMessage('Could not update name');
                          }
                        },

                  child: dialogLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // =========================================================
  // SHOW MESSAGE
  // =========================================================

  void showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    nameController.dispose();

    super.dispose();
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final uid = userId;

    if (uid == null) {
      return const Scaffold(body: Center(child: Text('Please login first')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),

      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Could not load profile'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Profile not found'));
          }

          final data = snapshot.data!.data()!;

          final name = data['name'] ?? 'User';

          final email = data['email'] ?? '';

          final profileImageUrl = data['profileImageUrl'];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: Column(
              children: [
                // =================================================
                // PROFILE IMAGE
                // =================================================
                Stack(
                  alignment: Alignment.bottomRight,

                  children: [
                    CircleAvatar(
                      radius: 60,

                      backgroundColor: AppTheme.primaryColor,

                      backgroundImage:
                          profileImageUrl != null &&
                              profileImageUrl.toString().isNotEmpty
                          ? NetworkImage(profileImageUrl)
                          : null,

                      child:
                          profileImageUrl == null ||
                              profileImageUrl.toString().isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white,
                            )
                          : null,
                    ),

                    // Camera button
                    GestureDetector(
                      onTap: isUploadingImage ? null : pickProfileImage,

                      child: Container(
                        height: 42,
                        width: 42,

                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),

                        child: isUploadingImage
                            ? const Padding(
                                padding: EdgeInsets.all(10),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // =================================================
                // NAME
                // =================================================
                Text(
                  name.toString(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                const SizedBox(height: 8),

                // =================================================
                // EMAIL
                // =================================================
                Text(
                  email.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 35),

                // =================================================
                // NAME CARD
                // =================================================
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.person_outline,
                      color: AppTheme.primaryColor,
                    ),

                    title: const Text('Name'),

                    subtitle: Text(name.toString()),

                    trailing: IconButton(
                      icon: const Icon(Icons.edit),

                      onPressed: () {
                        openEditNameDialog(name.toString());
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // =================================================
                // EMAIL CARD
                // =================================================
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.email_outlined,
                      color: AppTheme.primaryColor,
                    ),

                    title: const Text('Email'),

                    subtitle: Text(email.toString()),
                  ),
                ),

                const SizedBox(height: 30),

                // =================================================
                // LOGOUT
                // =================================================
                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await context.read<AuthCubit>().logout();

                      if (!mounted) return;

                      Navigator.pop(context);
                    },

                    icon: const Icon(Icons.logout),

                    label: const Text('Logout'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
