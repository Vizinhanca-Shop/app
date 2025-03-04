import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vizinhanca_shop/data/models/announcement_address_model.dart';
import 'package:vizinhanca_shop/data/models/announcement_model.dart';
import 'package:vizinhanca_shop/features/announcement/viewmodels/announcement_view_model.dart';
import 'package:vizinhanca_shop/features/my_announcement/viewmodels/my_announcements_view_model.dart';
import 'package:vizinhanca_shop/routes/app_routes.dart';
import 'package:vizinhanca_shop/shared/custom_select.dart';
import 'package:vizinhanca_shop/shared/custom_text_form_field.dart';
import 'package:vizinhanca_shop/shared/header.dart';
import 'package:vizinhanca_shop/theme/app_colors.dart';

class MyAnnouncementDetailsArguments {
  final String announcementId;
  const MyAnnouncementDetailsArguments({required this.announcementId});
}

class MyAnnouncementDetails extends StatefulWidget {
  final AnnouncementViewModel viewModel;
  final MyAnnouncementsViewModel myAnnouncementsViewModel;
  final MyAnnouncementDetailsArguments arguments;

  const MyAnnouncementDetails({
    super.key,
    required this.viewModel,
    required this.myAnnouncementsViewModel,
    required this.arguments,
  });

  @override
  State<MyAnnouncementDetails> createState() => _MyAnnouncementDetailsState();
}

class _MyAnnouncementDetailsState extends State<MyAnnouncementDetails> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  List<XFile> _images = [];
  List<String> _networkImageUrls = [];

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();

  final _cepController = TextEditingController();
  final _ruaController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();

  void _fetchAnnouncement() async {
    await widget.viewModel.handleGetAnnouncement(
      widget.arguments.announcementId,
    );
    final announcement = widget.viewModel.announcement;
    _nameController.text = announcement.name;
    _descriptionController.text = announcement.description;
    _priceController.text = announcement.price.toString();
    _categoryController.text = announcement.category.id;

    _cepController.text = announcement.address.postalCode;
    _ruaController.text = announcement.address.road;
    _bairroController.text = announcement.address.neighborhood;
    _cidadeController.text = announcement.address.city;
    _estadoController.text = announcement.address.state;

    if (announcement.images.isNotEmpty) {
      _loadImages(announcement.images);
    }
  }

  void _loadImages(List<String> imagePaths) {
    setState(() {
      _networkImageUrls = imagePaths;
      _images = [];
    });
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage(imageQuality: 50);
    setState(() {
      _images = [..._images, ...pickedFiles].take(4).toList();
    });
  }

  Future<void> _fetchAddressFromCep(String cep) async {
    final address = await widget.myAnnouncementsViewModel.fetchAddressFromCep(
      cep,
    );

    setState(() {
      _ruaController.text = address['logradouro'] ?? '';
      _bairroController.text = address['bairro'] ?? '';
      _cidadeController.text = address['localidade'] ?? '';
      _estadoController.text = address['uf'] ?? '';
    });
  }

  Future<Map<String, double>?> _getCoordinatesFromAddress(
    String address,
  ) async {
    final coordinates = await widget.myAnnouncementsViewModel
        .getCoordinatesFromAddress(address);

    return coordinates;
  }

  Future<void> _saveAnnouncement() async {
    if (_formKey.currentState!.validate()) {
      if (_cepController.text.isEmpty ||
          _ruaController.text.isEmpty ||
          _bairroController.text.isEmpty ||
          _cidadeController.text.isEmpty ||
          _estadoController.text.isEmpty) {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text("Endereço Incompleto"),
                content: const Text(
                  "Por favor, revise o endereço. Todos os campos devem estar preenchidos.",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Ok"),
                  ),
                ],
              ),
        );
        return;
      }

      final fullAddress =
          "${_ruaController.text}, ${_bairroController.text}, ${_cidadeController.text} - ${_estadoController.text}";

      final coordinates = await _getCoordinatesFromAddress(fullAddress);

      if (coordinates == null) {
        showDialog(
          context: AppRoutes.navigatorKey.currentContext!,
          builder:
              (context) => AlertDialog(
                title: const Text("Localização Não Encontrada"),
                content: const Text(
                  "Não foi possível obter as coordenadas do endereço. Por favor, confirme ou ajuste os dados do endereço.",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Ok"),
                  ),
                ],
              ),
        );
        return;
      }

      final name = _nameController.text;
      final description = _descriptionController.text;
      final price = int.parse(_priceController.text);
      final categoryId = _categoryController.text;
      final images = _images.map((image) => image.path).toList();
      images.addAll(_networkImageUrls);

      final announcementAddress = AnnouncementAddressModel(
        latitude: coordinates['latitude']!.toString(),
        longitude: coordinates['longitude']!.toString(),
        postalCode: _cepController.text,
        road: _ruaController.text,
        neighborhood: _bairroController.text,
        city: _cidadeController.text,
        state: _estadoController.text,
      );

      final announcement = AnnouncementModel(
        id: widget.arguments.announcementId,
        name: name,
        description: description,
        price: price,
        address: announcementAddress,
        category: widget.viewModel.categories.firstWhere(
          (category) => category.id == categoryId,
        ),
        images: images,
        seller: widget.viewModel.announcement.seller,
      );

      await widget.myAnnouncementsViewModel.updateAnnouncement(announcement);
    }
  }

  Future<void> _deleteAnnouncement() async {
    await widget.myAnnouncementsViewModel.deleteAnnouncement(
      widget.arguments.announcementId,
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchAnnouncement();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _cepController.dispose();
    _ruaController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Header(
        title: 'Editar Anúncio',
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Excluir Anúncio"),
                    content: const Text(
                      "Tem certeza que deseja excluir este anúncio?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancelar"),
                      ),
                      TextButton(
                        onPressed: () async {
                          await _deleteAnnouncement();
                          Navigator.pop(AppRoutes.navigatorKey.currentContext!);
                          Navigator.pop(AppRoutes.navigatorKey.currentContext!);
                        },
                        child: const Text("Excluir"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, snapshot) {
          return widget.viewModel.isLoading
              ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: 120,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Informações Principais",
                        style: GoogleFonts.sora(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _nameController,
                        labelText: 'Nome',
                        hintText: 'Nome do anúncio',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o nome do anúncio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _descriptionController,
                        labelText: 'Descrição',
                        hintText: 'Descrição do anúncio',
                        maxLines: 3,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira a descrição do anúncio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _priceController,
                        labelText: 'Preço',
                        hintText: 'Preço do anúncio',
                        keyboardType: TextInputType.number,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o preço do anúncio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomSelect(
                        controller: _categoryController,
                        labelText: 'Categoria',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Selecione a categoria',
                        items:
                            widget.viewModel.categories.map((category) {
                              return ItemModel(
                                label: category.name,
                                value: category.id,
                              );
                            }).toList(),
                        onChanged: (value) {
                          _categoryController.text = value;
                        },
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "Endereço",
                        style: GoogleFonts.sora(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _cepController,
                        labelText: 'CEP',
                        hintText: 'Digite o CEP',
                        keyboardType: TextInputType.number,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        onChanged: (value) {
                          if (value.length == 8) {
                            _fetchAddressFromCep(value);
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o CEP';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _ruaController,
                        labelText: 'Rua',
                        hintText: 'Digite a rua',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira a rua';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _bairroController,
                        labelText: 'Bairro',
                        hintText: 'Digite o bairro',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o bairro';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _cidadeController,
                        labelText: 'Cidade',
                        hintText: 'Digite a cidade',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira a cidade';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _estadoController,
                        labelText: 'Estado',
                        hintText: 'Digite o estado',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o estado';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Imagens (até 4)',
                        style: GoogleFonts.sora(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: [
                          ..._networkImageUrls.map((url) {
                            return Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey[300],
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.network(
                                    url,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  right: 6,
                                  top: 6,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _networkImageUrls.remove(url);
                                      });
                                    },
                                    child: Container(
                                      color: Colors.black54,
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                          ..._images.map((image) {
                            return Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey[300],
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.file(
                                    File(image.path),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  right: 6,
                                  top: 6,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _images.remove(image);
                                      });
                                    },
                                    child: Container(
                                      color: Colors.black54,
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                          if (_networkImageUrls.length + _images.length < 4)
                            GestureDetector(
                              onTap: _pickImages,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
        },
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, snapshot) {
          if (widget.viewModel.isLoading) {
            return SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
            child: ListenableBuilder(
              listenable: widget.myAnnouncementsViewModel,
              builder: (context, snapshot) {
                return ElevatedButton(
                  onPressed:
                      widget.myAnnouncementsViewModel.isEditing
                          ? null
                          : _saveAnnouncement,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                      widget.myAnnouncementsViewModel.isEditing
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : const Text(
                            'Salvar Alterações',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
