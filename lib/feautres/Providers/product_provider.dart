import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/products_model.dart';
import '../../services/api_service.dart';

class ProductNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  ProductNotifier() : super(const AsyncLoading()) {
    initializeProducts();
  }

  Future<void> initializeProducts() async {
    state = const AsyncLoading();
    try {
      final response = await ApiService.getProducts();
      print('Loaded ${response.length} products');
      state = AsyncData(response);
    } catch (error, stack) {
      state = AsyncError(error, stack);
    }
  }

  void addProduct(Product product) {
    final current = state.value ?? [];
    state = AsyncData([...current, product]);
  }
}

final productProvider =
    StateNotifierProvider<ProductNotifier, AsyncValue<List<Product>>>((ref) {
  return ProductNotifier();
});
