import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/cart/cart_bloc.dart';
import 'package:frontend_appflowershop/bloc/cart/cart_event.dart';
import 'package:frontend_appflowershop/bloc/cart/cart_state.dart';
import 'package:frontend_appflowershop/bloc/checkout/checkout_bloc.dart';
import 'package:frontend_appflowershop/bloc/checkout/checkout_event.dart';
import 'package:frontend_appflowershop/bloc/checkout/checkout_state.dart';
import 'package:frontend_appflowershop/bloc/user/user_profile/user_profile_bloc.dart';
import 'package:frontend_appflowershop/bloc/user/user_profile/user_profile_state.dart';
import 'package:frontend_appflowershop/views/screens/home_screen.dart';
import 'package:frontend_appflowershop/views/widgets/checkout/cart_items_widget.dart';
import 'package:frontend_appflowershop/views/widgets/checkout/customer_info_form_widget.dart';
import 'package:frontend_appflowershop/views/widgets/checkout/note_widget.dart';
import 'package:frontend_appflowershop/views/widgets/checkout/payment_method_widget.dart';
import 'package:frontend_appflowershop/views/widgets/checkout/place_order_button_widget.dart';
import 'package:frontend_appflowershop/views/widgets/checkout/promotion_widget.dart';
import 'package:frontend_appflowershop/views/widgets/checkout/summary_widget.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  String _paymentMethod = 'cash';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        if (state is CheckoutSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tạo đơn hàng thành công')),
          );
          context.read<CartBloc>().add(ClearCartEventall());
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        } else if (state is CheckoutError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, userState) {
          if (userState is UserProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (userState is UserProfileLoaded) {
            final user = userState.user;

            print('User ID from UserProfileBloc: ${user.id}');

            _nameController.text = user.name;
            _emailController.text = user.email;
            _phoneController.text = user.phoneNumber ?? '';
            _addressController.text = user.address ?? '';

            return BlocBuilder<CartBloc, CartState>(
              builder: (context, cartState) {
                if (cartState is CartLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (cartState is CartLoaded) {
                  final cartItems = cartState.cartItems;
                  final totalPrice = cartState.totalPrice;

                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Thanh toán'),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 0,
                    ),
                    body: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              CartItemsWidget(cartItems: cartItems),
                              SummaryWidget(totalPrice: totalPrice),
                              CustomerInfoFormWidget(
                                nameController: _nameController,
                                emailController: _emailController,
                                phoneController: _phoneController,
                                addressController: _addressController,
                              ),
                              PaymentMethodWidget(
                                paymentMethod: _paymentMethod,
                                onChanged: (value) {
                                  setState(() {
                                    _paymentMethod = value!;
                                  });
                                },
                              ),
                              const PromotionWidget(),
                              const NoteWidget(),
                              PlaceOrderButtonWidget(
                                formKey: _formKey,
                                userId: user.id.toString(),
                                nameController: _nameController,
                                emailController: _emailController,
                                phoneController: _phoneController,
                                addressController: _addressController,
                                paymentMethod: _paymentMethod,
                                cartItems: cartItems,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return const Center(child: Text('Có lỗi xảy ra'));
              },
            );
          }
          return const Center(
              child: Text('Không thể tải thông tin người dùng'));
        },
      ),
    );
  }
}
