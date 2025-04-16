import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/user/user_profile/user_profile_bloc.dart';
import 'package:frontend_appflowershop/bloc/user/user_profile/user_profile_event.dart';
import 'package:frontend_appflowershop/bloc/user/user_profile/user_profile_state.dart';
import 'package:frontend_appflowershop/views/screens/login_screen.dart';
import 'package:frontend_appflowershop/views/widgets/user/user_details_screen.dart';

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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: user.avatar != null
                              ? NetworkImage(user.avatar!)
                              : const AssetImage(
                                      'assets/images/default_avatar.png')
                                  as ImageProvider,
                          backgroundColor: Colors.grey[200],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UserDetailsScreen(user: user),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      user.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios,
                                        size: 16),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.phoneNumber ?? 'Chưa có số điện thoại',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: user.phoneNumber != null
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  // Các mục thông tin
                  ListTile(
                    leading: const Icon(Icons.account_balance_wallet,
                        color: Colors.red),
                    title: const Text('Tích lũy hiện tại'),
                    trailing: const Text('0đ'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.star, color: Colors.red),
                    title: const Text('Hạng thành viên'),
                    trailing: const Text('Chưa xếp hạng'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.receipt, color: Colors.red),
                    title: const Text('Đơn hàng của tui'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.red),
                    title: const Text('Số địa chỉ'),
                    trailing: const Text('0'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.favorite, color: Colors.red),
                    title: const Text('Sản phẩm yêu thích'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.star_border, color: Colors.red),
                    title: const Text('Nhận xét của tui'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.card_giftcard, color: Colors.red),
                    title: const Text('Vouchers của tui'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.mood, color: Colors.red),
                    title: const Text('Niềm vui của tui'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.info, color: Colors.red),
                    title: const Text('Chính sách giao hàng'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info, color: Colors.red),
                    title: const Text('Chính sách đổi trả và hoàn tiền'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info, color: Colors.red),
                    title: const Text('Chính sách bảo mật thông tin'),
                  ),
                  const SizedBox(height: 16),
                  // Nút đăng xuất
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<UserProfileBloc>().add(LogoutEvent());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Đăng xuất'),
                    ),
                  ),
                  const SizedBox(height: 16),
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
