import 'package:flutter/material.dart';
import 'package:vizinhanca_shop/data/models/product_model.dart';
import 'package:vizinhanca_shop/data/repositories/product_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final ProductRepository _repository;
  List<ProductModel> _products = [];
  bool _isLoading = false;

  HomeViewModel({required ProductRepository repository})
    : _repository = repository;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;

  void handleGetProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _repository.fetchProducts();
    } catch (e) {
      _products = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
