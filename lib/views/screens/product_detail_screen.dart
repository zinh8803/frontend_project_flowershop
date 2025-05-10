import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/product/product_detail/product_detail_bloc.dart';
import 'package:frontend_appflowershop/bloc/product/product_detail/product_detail_event.dart';
import 'package:frontend_appflowershop/bloc/product/product_detail/product_detail_state.dart';
import 'package:frontend_appflowershop/data/models/product.dart';
import 'package:frontend_appflowershop/data/models/size.dart';
import 'package:frontend_appflowershop/data/models/color.dart';
import 'package:frontend_appflowershop/data/services/Product/product_options_service.dart';
import 'package:frontend_appflowershop/data/services/cart/cart_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductOptionsService _optionsService = ProductOptionsService();
  SizeModel? _selectedSize;
  List<ColorModel> _selectedColors = [];
  double _currentPrice = 0;
  bool _canAddToCart = false;
  ProductModel? _product;
  // ProductDetailBloc? _productDetailBloc;

  @override
  void initState() {
    super.initState();
    _optionsService.fetchOptions(widget.productId);
    context
        .read<ProductDetailBloc>()
        .add(FetchProductDetailEvent(widget.productId));
    _currentPrice = 0;
    print('initState: _currentPrice: $_currentPrice');
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Lấy tham chiếu đến Bloc khi dependencies của widget thay đổi
  //   _productDetailBloc = context.read<ProductDetailBloc>();
  // }

  // @override
  // void dispose() {
  //   _selectedSize = null;
  //   _selectedColors.clear();
  //   _currentPrice = 0;
  //   _canAddToCart = false;
  //   _product = null;

  //   _productDetailBloc?.add(ResetProductDetailEvent());
  //   _productDetailBloc = null; // Giải phóng tham chiếu

  //   super.dispose();
  //   print('dispose: Trạng thái đã được reset');
  // }

  void _updatePrice() {
    if (_product == null) return;
    _currentPrice = _product!.finalPrice;
    if (_selectedSize != null) {
      try {
        final selectedSizeData =
            _optionsService.sizes.firstWhere((s) => s.id == _selectedSize!.id);
        _currentPrice += selectedSizeData.priceModifier;
      } catch (e) {
        print('Error updating price for size: $e');
      }
    }
    if (_selectedColors.length > 1) {
      _currentPrice += (_selectedColors.length - 1) * 10000;
    }
    _updateAddToCartState();
  }

  void _updateAddToCartState() {
    bool sizeSelected = _optionsService.sizes.isEmpty || _selectedSize != null;
    bool colorsSelected =
        _optionsService.colors.isEmpty || _selectedColors.isNotEmpty;
    setState(() {
      _canAddToCart = sizeSelected && colorsSelected;
    });
  }

  void _addToCart(BuildContext context) {
    if (_product == null || !_canAddToCart) return;
    final cartService = context.read<CartService>();
    cartService.addToCart(_product!.copyWith(finalPrice: _currentPrice),
        size: _selectedSize, colors: _selectedColors);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${_product!.name} (Size: ${_selectedSize?.name ?? 'Mặc định'}, Màu: ${_selectedColors.map((c) => c.name).join(', ')}) đã được thêm vào giỏ hàng với giá ${_currentPrice.toStringAsFixed(0)}đ'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _selectSize(SizeModel? size) {
    setState(() {
      _selectedSize = size;
    });
    _updatePrice();
  }

  void _toggleColor(ColorModel color) {
    setState(() {
      if (_selectedColors.contains(color)) {
        _selectedColors.remove(color);
      } else {
        _selectedColors.add(color);
      }
    });
    _updatePrice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết sản phẩm'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          if (state is ProductDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProductDetailError) {
            return Center(child: Text('Lỗi: ${state.message}'));
          }
          if (state is ProductDetailLoaded) {
            _product = state.product;
            //_currentPrice = 0;
            print(
                'BlocBuilder - ProductDetailLoaded1: _product?.finalPrice: ${_currentPrice}');

            if (_currentPrice == 0) {
              _currentPrice = _product!.price;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _updatePrice();
                _updateAddToCartState();
              });
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    _product!.imageUrl,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _product!.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Text(
                        //   'SP0${_product!.id}',
                        //   style:
                        //       const TextStyle(fontSize: 16, color: Colors.grey),
                        // ),
                        const SizedBox(height: 8),
                        Text(
                          _selectedSize != null || _selectedColors.isNotEmpty
                              ? '${_currentPrice.toStringAsFixed(0)}đ'
                              : (_product?.finalPrice != null
                                  ? '${_product!.finalPrice.toStringAsFixed(0)}đ'
                                  : '${_product?.price.toStringAsFixed(0)}đ'),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                        if (_optionsService.isLoading)
                          const Center(child: CircularProgressIndicator())
                        else if (_optionsService.error != null)
                          Center(child: Text('Lỗi: ${_optionsService.error}'))
                        else ...[
                          if (_optionsService.sizes.isNotEmpty) ...[
                            const Text(
                              'Kích thước',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8.0,
                              children: _optionsService.sizes
                                  .map((size) => ChoiceChip(
                                        label: Text(size.name),
                                        selected: _selectedSize?.id == size.id,
                                        onSelected: (selected) {
                                          _selectSize(selected ? size : null);
                                        },
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 16),
                          ],
                          if (_optionsService.colors.isNotEmpty) ...[
                            const Text(
                              'Màu sắc',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8.0,
                              children: _optionsService.colors
                                  .map((color) => FilterChip(
                                        label: Text(color.name),
                                        selected:
                                            _selectedColors.contains(color),
                                        onSelected: (selected) {
                                          _toggleColor(color);
                                        },
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ],
                        const Text(
                          'Mô tả sản phẩm',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _product!.description,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Không tìm thấy sản phẩm'));
        },
      ),
      bottomNavigationBar: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          if (state is ProductDetailLoaded && !_optionsService.isLoading) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Quay lại'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          _canAddToCart ? () => _addToCart(context) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Thêm vào giỏ'),
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
