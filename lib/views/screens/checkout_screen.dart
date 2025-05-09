import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/cart/cart_bloc.dart';
import 'package:frontend_appflowershop/bloc/cart/cart_event.dart';
import 'package:frontend_appflowershop/bloc/cart/cart_state.dart';
import 'package:frontend_appflowershop/bloc/checkout/checkout_bloc.dart';
import 'package:frontend_appflowershop/bloc/checkout/checkout_event.dart';
import 'package:frontend_appflowershop/bloc/checkout/checkout_state.dart';
import 'package:frontend_appflowershop/bloc/user/user_profile/user_profile_bloc.dart';
import 'package:frontend_appflowershop/bloc/user/user_profile/user_profile_event.dart';
import 'package:frontend_appflowershop/bloc/user/user_profile/user_profile_state.dart';
import 'package:frontend_appflowershop/views/screens/home_screen.dart';
import 'package:frontend_appflowershop/views/widgets/checkout/cart_items_widget.dart';
import 'package:frontend_appflowershop/views/widgets/checkout/customer_info_form_widget.dart';
import 'package:frontend_appflowershop/views/widgets/checkout/note_widget.dart';
import 'package:frontend_appflowershop/views/widgets/checkout/payment_method_widget.dart';
import 'package:frontend_appflowershop/views/widgets/checkout/place_order_button_widget.dart';
import 'package:frontend_appflowershop/views/widgets/checkout/promotion_widget.dart';
import 'package:frontend_appflowershop/views/widgets/checkout/summary_widget.dart';
import 'package:frontend_appflowershop/views/widgets/payment/vnpayview.dart';

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
  bool _isPaymentProcessing = false;
  double _discountedTotalPrice = 0.0;
  int? _appliedDiscountId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    context.read<UserProfileBloc>().add(FetchUserProfileEvent());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleDiscountApplied(double newPrice, int discountId) {
    setState(() {
      _discountedTotalPrice = newPrice;
      _appliedDiscountId = discountId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        if (state is CheckoutSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thanh toán đơn hàng thành công')),
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
          setState(() {
            _isPaymentProcessing = false;
          });
        } else if (state is CheckoutPaymentUrlLoaded) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VNPayWebView(
                paymentUrl: state.paymentUrl,
                onPaymentResult: (result) {
                  if (result['vnp_ResponseCode'] == '00' &&
                      result['vnp_TransactionStatus'] == '00') {
                    final cartState =
                        context.read<CartBloc>().state as CartLoaded;
                    context.read<CheckoutBloc>().add(
                          PlaceOrderEvent(
                            userId: int.parse((context
                                    .read<UserProfileBloc>()
                                    .state as UserProfileLoaded)
                                .user
                                .id
                                .toString()),
                            name: _nameController.text,
                            discount_Id: _appliedDiscountId,
                            email: _emailController.text,
                            phoneNumber: _phoneController.text,
                            address: _addressController.text,
                            paymentMethod: _paymentMethod,
                            cartItems: cartState.cartItems,
                          ),
                        );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Thanh toán VNPay thất bại hoặc bị hủy')),
                    );
                    setState(() {
                      _isPaymentProcessing = false;
                    });
                  }
                },
              ),
            ),
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
                  final displayedPrice = _discountedTotalPrice > 0
                      ? _discountedTotalPrice
                      : totalPrice;

                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Thanh toán'),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 0,
                    ),
                    body: _isPaymentProcessing
                        ? const Center(child: CircularProgressIndicator())
                        : SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    CartItemsWidget(cartItems: cartItems),
                                    SummaryWidget(totalPrice: displayedPrice),
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
                                          _paymentMethod = value ?? 'cash';
                                        });
                                      },
                                    ),
                                    PromotionWidget(
                                      id: user.id,
                                      orderTotal: totalPrice,
                                      onDiscountApplied: _handleDiscountApplied,
                                    ),
                                    PlaceOrderButtonWidget(
                                      formKey: _formKey,
                                      userId: user.id.toString(),
                                      nameController: _nameController,
                                      emailController: _emailController,
                                      phoneController: _phoneController,
                                      addressController: _addressController,
                                      paymentMethod: _paymentMethod,
                                      cartItems: cartItems,
                                      totalPrice: displayedPrice,
                                      discountId: _appliedDiscountId,
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
