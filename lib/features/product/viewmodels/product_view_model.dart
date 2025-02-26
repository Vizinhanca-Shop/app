import 'package:flutter/material.dart';
import 'package:vizinhanca_shop/data/models/product_model.dart';
import 'package:vizinhanca_shop/data/repositories/product_repository.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductRepository _repository;
  ProductModel _product = ProductModel.empty();
  bool _isLoading = false;

  ProductViewModel({required ProductRepository repository})
    : _repository = repository;

  ProductModel get product => _product;
  bool get isLoading => _isLoading;

  void handleGetProduct(String productId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _product = await _repository.fetchProduct(productId);
    } catch (e) {
      _product = ProductModel.empty();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
