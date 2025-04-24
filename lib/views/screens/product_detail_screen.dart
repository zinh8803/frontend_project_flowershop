import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/product/product_detail/product_detail_bloc.dart';
import 'package:frontend_appflowershop/bloc/product/product_detail/product_detail_event.dart';
import 'package:frontend_appflowershop/bloc/product/product_detail/product_detail_state.dart';
import 'package:frontend_appflowershop/data/models/product.dart';
import 'package:frontend_appflowershop/data/models/size.dart';
import 'package:frontend_appflowershop/data/models/color.dart';
import 'package:frontend_appflowershop/data/services/cart/cart_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final List<SizeModel> _sizes = [
    SizeModel(id: 1, name: 'Bó nhỏ', priceModifier: -10),
    SizeModel(id: 2, name: 'Bó lớn', priceModifier: 10),
  ];

  final List<ColorModel> _colors = [
    ColorModel(id: 1, name: 'Xanh'),
    ColorModel(id: 2, name: 'Đỏ'),
    ColorModel(id: 3, name: 'Cam'),
    ColorModel(id: 4, name: 'Trắng'),
  ];

  SizeModel? _selectedSize;
  List<ColorModel> _selectedColors = [];
  double _currentPrice = 0;
  bool _canAddToCart =
      false; 

  @override
  void initState() {
    super.initState();
    context
        .read<ProductDetailBloc>()
        .add(FetchProductDetailEvent(widget.productId));
  }

  void _updatePrice(ProductModel product) {
    _currentPrice = product.price;
    if (_selectedSize != null) {
      _currentPrice += (_currentPrice * _selectedSize!.priceModifier / 100);
    }
    for (var color in _selectedColors) {
      _currentPrice += (_currentPrice * 0.05);
    }
    _updateAddToCartState(); 
  }

  void _updateAddToCartState() {
    bool sizeSelected = _sizes.isEmpty || _selectedSize != null;
    bool colorsSelected = _colors.isEmpty || _selectedColors.isNotEmpty;
    setState(() {
      _canAddToCart = sizeSelected && colorsSelected;
    });
  }

  void _addToCart(BuildContext context, ProductModel? product) {
    if (product == null || !_canAddToCart) return;
    final cartService = context.read<CartService>();
    cartService.addToCart(product.copyWith(finalPrice: _currentPrice),
        size: _selectedSize, colors: _selectedColors);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${product.name} (Size: ${_selectedSize?.name ?? 'Mặc định'}, Màu: ${_selectedColors.map((c) => c.name).join(', ')}) đã được thêm vào giỏ hàng với giá ${_currentPrice.toStringAsFixed(0)}đ'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _selectSize(SizeModel? size, ProductModel? product) {
    if (product == null) return;
    setState(() {
      _selectedSize = size;
      _updatePrice(product);
    });
  }

  void _toggleColor(ColorModel color, ProductModel? product) {
    if (product == null) return;
    setState(() {
      if (_selectedColors.contains(color)) {
        _selectedColors.remove(color);
      } else {
        _selectedColors.add(color);
      }
      _updatePrice(product);
    });
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
            final product = state.product;
            if (_currentPrice == 0) {
              _currentPrice = product.price;
              _updateAddToCartState(); // Khởi tạo trạng thái nút khi sản phẩm được tải
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    product.imageUrl,
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
                          product.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'SP0${product.id}',
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_currentPrice.toStringAsFixed(0)}đ',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                        if (_sizes.isNotEmpty) ...[
                          const Text(
                            'Kích thước',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8.0,
                            children: _sizes
                                .map((size) => ChoiceChip(
                                      label: Text(size.name),
                                      selected: _selectedSize == size,
                                      onSelected: (selected) {
                                        _selectSize(
                                            selected ? size : null, product);
                                      },
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (_colors.isNotEmpty) ...[
                          const Text(
                            'Màu sắc',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8.0,
                            children: _colors
                                .map((color) => FilterChip(
                                      label: Text(color.name),
                                      selected: _selectedColors.contains(color),
                                      onSelected: (selected) {
                                        _toggleColor(color, product);
                                      },
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 16),
                        ],
                        const Text(
                          'Mô tả sản phẩm',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.description,
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
          if (state is ProductDetailLoaded) {
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
                      onPressed: _canAddToCart
                          ? () {
                              _addToCart(context, state.product);
                            }
                          : null, // Vô hiệu hóa nếu _canAddToCart là false
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
