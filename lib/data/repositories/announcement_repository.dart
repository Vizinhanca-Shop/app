import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vizinhanca_shop/config/app_config.dart';
import 'package:vizinhanca_shop/data/models/announcement_model.dart';
import 'package:vizinhanca_shop/data/models/category_model.dart';
import 'package:vizinhanca_shop/data/models/user_model.dart';
import 'package:vizinhanca_shop/http/http_client.dart';

class AnnouncementRepository {
  final HttpClient client;
  final AppConfig appConfig;

  AnnouncementRepository({required this.client, required this.appConfig});

  String get baseUrl => appConfig.baseUrl;

  final announcements = [
    AnnouncementModel(
      id: '1',
      name: 'Bolo de Cenoura com Chocolate',
      price: 120.0,
      description:
          'Um delicioso bolo caseiro de cenoura com cobertura de chocolate. Perfeito para acompanhar o café da tarde.',
      images: [
        'https://www.sabornamesa.com.br/media/k2/items/cache/f59fd3a46f2adbbd9dd6269010353971_XL.jpg',
        'https://panutti.com.br/arquivos/produtos/imagens_adicionais/P%C3%A3o%20Caseiro%20(1)-153.jpg',
        'https://amopaocaseiro.com.br/wp-content/uploads/2019/12/pao-de-forma-caseiro_02.jpg',
      ],
      seller: UserModel(
        id: '2',
        name: 'Maria Confeitaria',
        phone: '48 98888-8888',
        avatar: 'https://i.pravatar.cc/301',
      ),
      category: CategoryModel(id: '1', name: 'Alimentos e Bebidas'),
      address: 'Av. Central, 456',
    ),

    AnnouncementModel(
      id: '2',
      name: 'Açaí na Tigela 500ml',
      price: 150.0,
      description:
          'Açaí cremoso com banana, morango, granola e mel. Refrescante e nutritivo para qualquer hora do dia.',
      images: [
        'https://www.sabornamesa.com.br/media/k2/items/cache/f59fd3a46f2adbbd9dd6269010353971_XL.jpg',
        'https://panutti.com.br/arquivos/produtos/imagens_adicionais/P%C3%A3o%20Caseiro%20(1)-153.jpg',
        'https://amopaocaseiro.com.br/wp-content/uploads/2019/12/pao-de-forma-caseiro_02.jpg',
      ],
      seller: UserModel(
        id: '2',
        name: 'Açaí Tropical',
        phone: '48 97777-7777',
        avatar: 'https://i.pravatar.cc/302',
      ),
      category: CategoryModel(id: '1', name: 'Alimentos e Bebidas'),
      address: 'Rua do Comércio, 789',
    ),

    AnnouncementModel(
      id: '3',
      name: 'Coxinha de Frango com Catupiry (Unidade)',
      price: 50.0,
      description:
          'Coxinha crocante por fora e recheada com frango desfiado e catupiry cremoso. Ótima para lanches e festas.',
      images: [
        'https://www.sabornamesa.com.br/media/k2/items/cache/f59fd3a46f2adbbd9dd6269010353971_XL.jpg',
        'https://panutti.com.br/arquivos/produtos/imagens_adicionais/P%C3%A3o%20Caseiro%20(1)-153.jpg',
        'https://amopaocaseiro.com.br/wp-content/uploads/2019/12/pao-de-forma-caseiro_02.jpg',
      ],
      seller: UserModel(
        id: '2',
        name: 'Lanchonete Express',
        phone: '48 96666-6666',
        avatar: 'https://i.pravatar.cc/303',
      ),
      category: CategoryModel(id: '1', name: 'Alimentos e Bebidas'),
      address: 'Praça dos Sabores, 101',
    ),

    AnnouncementModel(
      id: '4',
      name: 'Smartphone XYZ Pro 128GB',
      price: 2999.0,
      description:
          'Celular com tela AMOLED de 6.5", câmera tripla de 108MP e bateria de longa duração.',
      images: [
        'https://www.sabornamesa.com.br/media/k2/items/cache/f59fd3a46f2adbbd9dd6269010353971_XL.jpg',
        'https://panutti.com.br/arquivos/produtos/imagens_adicionais/P%C3%A3o%20Caseiro%20(1)-153.jpg',
        'https://amopaocaseiro.com.br/wp-content/uploads/2019/12/pao-de-forma-caseiro_02.jpg',
      ],
      seller: UserModel(
        id: '5',
        name: 'Tech Eletrônicos',
        phone: '48 95555-5555',
        avatar: 'https://i.pravatar.cc/304',
      ),
      category: CategoryModel(id: '2', name: 'Eletrônicos e Acessórios'),
      address: 'Shopping Center, Loja 12',
    ),

    AnnouncementModel(
      id: '5',
      name: 'Corte de Cabelo Masculino',
      price: 80.0,
      description:
          'Corte de cabelo moderno e estiloso para homens. Atendimento profissional com agendamento prévio.',
      images: [
        'https://www.sabornamesa.com.br/media/k2/items/cache/f59fd3a46f2adbbd9dd6269010353971_XL.jpg',
        'https://panutti.com.br/arquivos/produtos/imagens_adicionais/P%C3%A3o%20Caseiro%20(1)-153.jpg',
        'https://amopaocaseiro.com.br/wp-content/uploads/2019/12/pao-de-forma-caseiro_02.jpg',
      ],
      seller: UserModel(
        id: '6',
        name: 'Barbearia Elite',
        phone: '48 94444-4444',
        avatar: 'https://i.pravatar.cc/305',
      ),
      category: CategoryModel(id: '10', name: 'Beleza e Estética'),
      address: 'Rua dos Estilos, 150',
    ),

    AnnouncementModel(
      id: '6',
      name: 'Limpeza de Pele Profunda',
      price: 180.0,
      description:
          'Sessão completa de limpeza de pele com hidratação e revitalização. Ideal para manter a pele saudável e bonita.',
      images: [
        'https://www.sabornamesa.com.br/media/k2/items/cache/f59fd3a46f2adbbd9dd6269010353971_XL.jpg',
        'https://panutti.com.br/arquivos/produtos/imagens_adicionais/P%C3%A3o%20Caseiro%20(1)-153.jpg',
        'https://amopaocaseiro.com.br/wp-content/uploads/2019/12/pao-de-forma-caseiro_02.jpg',
      ],
      seller: UserModel(
        id: '7',
        name: 'Estética Bella',
        phone: '48 93333-3333',
        avatar: 'https://i.pravatar.cc/306',
      ),
      category: CategoryModel(id: '10', name: 'Beleza e Estética'),
      address: 'Av. da Beleza, 222',
    ),

    AnnouncementModel(
      id: '7',
      name: 'Relógio Smartwatch Fitness',
      price: 450.0,
      description:
          'Relógio inteligente com monitoramento cardíaco, contagem de passos e resistência à água.',
      images: [
        'https://www.sabornamesa.com.br/media/k2/items/cache/f59fd3a46f2adbbd9dd6269010353971_XL.jpg',
        'https://panutti.com.br/arquivos/produtos/imagens_adicionais/P%C3%A3o%20Caseiro%20(1)-153.jpg',
        'https://amopaocaseiro.com.br/wp-content/uploads/2019/12/pao-de-forma-caseiro_02.jpg',
      ],
      seller: UserModel(
        id: '8',
        name: 'Loja Digital',
        phone: '48 92222-2222',
        avatar: 'https://i.pravatar.cc/307',
      ),
      category: CategoryModel(id: '2', name: 'Eletrônicos e Acessórios'),
      address: 'Centro Comercial, Loja 8',
    ),

    AnnouncementModel(
      id: '8',
      name: 'Brinquedo Educativo de Madeira',
      price: 90.0,
      description:
          'Brinquedo de encaixe em madeira para estimular o aprendizado e a coordenação motora das crianças.',
      images: [
        'https://www.sabornamesa.com.br/media/k2/items/cache/f59fd3a46f2adbbd9dd6269010353971_XL.jpg',
        'https://panutti.com.br/arquivos/produtos/imagens_adicionais/P%C3%A3o%20Caseiro%20(1)-153.jpg',
        'https://amopaocaseiro.com.br/wp-content/uploads/2019/12/pao-de-forma-caseiro_02.jpg',
      ],
      seller: UserModel(
        id: '9',
        name: 'Brincar & Aprender',
        phone: '48 91111-1111',
        avatar: 'https://i.pravatar.cc/308',
      ),
      category: CategoryModel(id: '7', name: 'Infantil'),
      address: 'Rua das Crianças, 300',
    ),

    AnnouncementModel(
      id: '9',
      name: 'Kit de Temperos Naturais',
      price: 70.0,
      description:
          'Kit com 5 temperos naturais sem conservantes. Ideal para realçar o sabor dos alimentos.',
      images: [
        'https://www.sabornamesa.com.br/media/k2/items/cache/f59fd3a46f2adbbd9dd6269010353971_XL.jpg',
        'https://panutti.com.br/arquivos/produtos/imagens_adicionais/P%C3%A3o%20Caseiro%20(1)-153.jpg',
        'https://amopaocaseiro.com.br/wp-content/uploads/2019/12/pao-de-forma-caseiro_02.jpg',
      ],
      seller: UserModel(
        id: '10',
        name: 'Sabor da Terra',
        phone: '48 90000-0000',
        avatar: 'https://i.pravatar.cc/309',
      ),
      category: CategoryModel(id: '1', name: 'Alimentos e Bebidas'),
      address: 'Mercado Municipal, Box 15',
    ),
  ];

  Future<List<AnnouncementModel>> fetchAnnouncements() async {
    // final url = Uri.parse('$baseUrl/products');

    try {
      // final response = await client.get(url);
      // if (response.statusCode == 200) {
      //   final decodedBody = json.decode(response.body);
      //   return List<ProductModel>.from(
      //     decodedBody.map((product) => ProductModel.fromJson(product)),
      //   );
      // } else {
      //   return [];
      // }

      await Future.delayed(Duration(seconds: 2));

      return announcements;
    } catch (e) {
      return [];
    }
  }

  Future<AnnouncementModel> fetchAnnouncement(String productId) async {
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

      return announcements.firstWhere((product) => product.id == productId);
    } catch (e) {
      return AnnouncementModel.empty();
    }
  }

  Future<List<AnnouncementModel>> fetchUserAnnouncements(String userId) async {
    // final url = Uri.parse('$baseUrl/products?sellerId=$userId');

    try {
      // final response = await client.get(url);
      // if (response.statusCode == 200) {
      //   final decodedBody = json.decode(response.body);
      //   return List<ProductModel>.from(
      //     decodedBody.map((product) => ProductModel.fromJson(product)),
      //   );
      // } else {
      //   return [];
      // }

      await Future.delayed(Duration(seconds: 2));

      return announcements
          .where((product) => product.seller.id == userId)
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> createAnnouncement(AnnouncementModel announcement) async {
    // final url = Uri.parse('$baseUrl/products');

    try {
      // final response = await client.post(url, data: announcement.toJson());
      // if (response.statusCode == 201) {
      //   return;
      // } else {
      //   throw Exception('Failed to create announcement');
      // }

      await Future.delayed(Duration(seconds: 2));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateAnnouncement(AnnouncementModel announcement) async {
    await Future.delayed(Duration(seconds: 2));

    final localImages =
        announcement.images.where((img) => !img.startsWith('http')).toList();
    final remoteImages =
        announcement.images.where((img) => img.startsWith('http')).toList();

    List<http.MultipartFile> multipartFiles = [];
    for (final imagePath in localImages) {
      final multipartFile = await http.MultipartFile.fromPath(
        'images',
        imagePath,
      );
      multipartFiles.add(multipartFile);
    }

    Map<String, dynamic> fields = {
      'name': announcement.name,
      'description': announcement.description,
      'price': announcement.price.toString(),
      'category': announcement.category.id,
      'address': announcement.address,
      'remote_images': jsonEncode(remoteImages),
    };

    for (int i = 0; i < multipartFiles.length; i++) {
      fields['images[$i]'] = multipartFiles[i];
    }

    final url = Uri.parse('$baseUrl/products/${announcement.id}');
    final response = await client.multipart(url, data: fields, method: 'PUT');

    if (response.statusCode == 200) {
      print('Anúncio atualizado com sucesso!');
      print('Anúncio atualizado com sucesso!');
    } else {
      print('Erro ao atualizar anúncio: ${response.statusCode}');
      throw Exception('Erro ao atualizar anúncio');
    }
  }
}
