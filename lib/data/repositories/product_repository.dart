import 'package:vizinhanca_shop/config/app_config.dart';
import 'package:vizinhanca_shop/data/models/product_model.dart';
import 'package:vizinhanca_shop/data/models/user_model.dart';
import 'package:vizinhanca_shop/http/http_client.dart';

class ProductRepository {
  final HttpClient client;
  final AppConfig appConfig;

  ProductRepository({required this.client, required this.appConfig});

  String get baseUrl => appConfig.baseUrl;

  Future<ProductModel> fetchProduct(String productId) async {
    // final url = Uri.parse('$baseUrl/products/$productId');

    try {
      // final response = await client.get(url);
      // if (response.statusCode == 200) {
      //   final decodedBody = json.decode(response.body);
      //   return ProductModel.fromJson(decodedBody);
      // } else {
      //   return ProductModel.empty();
      // }

      await Future.delayed(Duration(seconds: 2));

      return ProductModel(
        id: '1',
        name: 'Pão de Forma Caseiro',
        price: 100.0,
        description:
            'Nosso pão caseiro artesanal é preparado diariamente com ingredientes selecionados e fermentação natural. Com casca crocante e miolo macio, este pão tem o sabor autêntico da tradição. Assado lentamente em forno de pedra, preserva todos os aromas e nutrientes da farinha orgânica. Perfeito para o café da manhã ou para acompanhar suas refeições. Experimente esta delícia preparada com carinho pela nossa padaria local. Peso aproximado: 500g Validade: 3 dias em temperatura ambiente',
        images: [
          'https://www.sabornamesa.com.br/media/k2/items/cache/f59fd3a46f2adbbd9dd6269010353971_XL.jpg',
          'https://panutti.com.br/arquivos/produtos/imagens_adicionais/P%C3%A3o%20Caseiro%20(1)-153.jpg',
          'https://amopaocaseiro.com.br/wp-content/uploads/2019/12/pao-de-forma-caseiro_02.jpg',
        ],
        seller: UserModel(
          id: '1',
          name: 'John Doe',
          phone: '48 99999-9999',
          address: 'Rua das Flores, 123',
          avatar: 'https://i.pravatar.cc/300',
        ),
        category: 'Alimentos e Bebidas',
      );
    } catch (e) {
      return ProductModel.empty();
    }
  }
}
