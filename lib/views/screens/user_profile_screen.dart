import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/user/user_profile/user_profile_bloc.dart';
import 'package:frontend_appflowershop/bloc/user/user_profile/user_profile_event.dart';
import 'package:frontend_appflowershop/bloc/user/user_profile/user_profile_state.dart';
import 'package:frontend_appflowershop/views/widgets/home/login_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    
    context.read<UserProfileBloc>().add(FetchUserProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserProfileBloc, UserProfileState>(
      listener: (context, state) {
        if (state is UserProfileLoggedOut) {
         
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, state) {
          if (state is UserProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UserProfileError) {
            return Center(child: Text('Lỗi: ${state.message}'));
          }
          if (state is UserProfileLoaded) {
            final user = state.user;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user.avatar != null
                        ? NetworkImage(user.avatar!)
                        : const AssetImage('assets/images/default_avatar.png')
                            as ImageProvider,
                    backgroundColor: Colors.grey[200],
                  ),
                  const SizedBox(height: 16),
              
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Email
                  Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: Text(
                      user.phoneNumber ?? 'Chưa cập nhật số điện thoại',
                      style: TextStyle(
                        color: user.phoneNumber != null
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                  ),
                  
                  ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(
                      user.address ?? 'Chưa cập nhật địa chỉ',
                      style: TextStyle(
                        color:
                            user.address != null ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                 
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: Text(
                      'Đăng nhập cuối: ${user.lastLoginAt ?? 'Không có thông tin'}',
                    ),
                  ),
                  const SizedBox(height: 24),
                 
                  ElevatedButton(
                    onPressed: () {
                      context.read<UserProfileBloc>().add(LogoutEvent());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                    ),
                    child: const Text(
                      'Đăng xuất',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
