import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/cart/cart_bloc.dart';
import 'package:frontend_appflowershop/bloc/user/avatar/avatar_bloc.dart';
import 'package:frontend_appflowershop/bloc/user/avatar/avatar_event.dart';
import 'package:frontend_appflowershop/bloc/user/avatar/avatar_state.dart';
import 'package:frontend_appflowershop/bloc/user/user_profile/user_profile_bloc.dart';
import 'package:frontend_appflowershop/bloc/user/user_profile/user_profile_event.dart';
import 'package:frontend_appflowershop/bloc/user/user_profile/user_profile_state.dart';
import 'package:frontend_appflowershop/data/models/user.dart';
import 'package:frontend_appflowershop/data/services/user/api_service.dart';
import 'package:frontend_appflowershop/utils/preference_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserDetailsScreen extends StatefulWidget {
  final UserModel user;

  const UserDetailsScreen({super.key, required this.user});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  File? _selectedImage;
  String? _avatarUrl;
  bool _isPickingImage = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    phoneController =
        TextEditingController(text: widget.user.phoneNumber ?? '');
    emailController = TextEditingController(text: widget.user.email);
    addressController = TextEditingController(text: widget.user.address ?? '');
    _avatarUrl = widget.user.avatar;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_isPickingImage) return;

    setState(() {
      _isPickingImage = true;
    });

    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });

        context.read<AvatarBloc>().add(UpdateAvatar(pickedFile.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi chọn ảnh: $e')),
      );
    } finally {
      setState(() {
        _isPickingImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserProfileBloc(
        context.read<ApiService>(),
        PreferenceService(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Thông tin chi tiết'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<UserProfileBloc, UserProfileState>(
              listener: (context, state) {
                if (state is UserDetailUpdating) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state is UserProfileLoaded) {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Thông tin đã được cập nhật')),
                  );
                } else if (state is UserDetailUpdateFailure) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi: ${state.error}')),
                  );
                }
              },
            ),
            BlocListener<AvatarBloc, AvatarState>(
              listener: (context, state) {
                if (state is AvatarUpdating) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state is AvatarUpdated) {
                  Navigator.pop(context);
                  setState(() {
                    _avatarUrl = state.avatarUrl;
                    _selectedImage = null;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Avatar đã được cập nhật')),
                  );
                  Navigator.pop(context, true);
                } else if (state is AvatarUpdateFailure) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi: ${state.error}')),
                  );
                  setState(() {
                    _selectedImage = null;
                  });
                }
              },
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Avatar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: GestureDetector(
                      onTap: _isPickingImage ? null : _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : _avatarUrl != null
                                ? NetworkImage(
                                    '$_avatarUrl?t=${DateTime.now().millisecondsSinceEpoch}')
                                : const AssetImage(
                                        'assets/images/default_avatar.png')
                                    as ImageProvider,
                        backgroundColor: Colors.grey[200],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Họ và tên',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(hintText: 'Nhập họ và tên'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Số điện thoại',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                        hintText: 'Liên kết với số điện thoại'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Email',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(hintText: 'Nhập email'),
                    keyboardType: TextInputType.emailAddress,
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Địa chỉ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(hintText: 'Nhập địa chỉ'),
                    keyboardType: TextInputType.streetAddress,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          minimumSize: const Size(150, 50),
                        ),
                        child: const Text('Hủy'),
                      ),
                      BlocBuilder<UserProfileBloc, UserProfileState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: state is UserDetailUpdating
                                ? null
                                : () {
                                    context.read<UserProfileBloc>().add(
                                          UpdateUserProfile(
                                            name: nameController.text,
                                            email: emailController.text,
                                            phoneNumber: phoneController.text,
                                            address: addressController.text,
                                          ),
                                        );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(150, 50),
                            ),
                            child: state is UserDetailUpdating
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : const Text('Lưu thay đổi'),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
