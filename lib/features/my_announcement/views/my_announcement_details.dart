import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vizinhanca_shop/data/models/announcement_model.dart';
import 'package:vizinhanca_shop/features/announcement/viewmodels/announcement_view_model.dart';
import 'package:vizinhanca_shop/features/my_announcement/viewmodels/my_announcements_view_model.dart';
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
  final _addressController = TextEditingController();
  final _categoryController = TextEditingController();

  void _fetchAnnouncement() async {
    await widget.viewModel.handleGetAnnouncement(
      widget.arguments.announcementId,
    );

    final announcement = widget.viewModel.announcement;
    _nameController.text = announcement.name;
    _descriptionController.text = announcement.description;
    _priceController.text = announcement.price.toString();
    _addressController.text = announcement.address;
    _categoryController.text = announcement.category.id;

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

  void _saveAnnouncement() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final description = _descriptionController.text;
      final price = double.parse(_priceController.text);
      final address = _addressController.text;
      final categoryId = _categoryController.text;

      final images = _images.map((image) => image.path).toList();
      images.addAll(_networkImageUrls);

      final announcement = AnnouncementModel(
        id: widget.arguments.announcementId,
        name: name,
        description: description,
        price: price,
        address: address,
        category: widget.viewModel.categories.firstWhere(
          (category) => category.id == categoryId,
        ),
        images: images,
        seller: widget.viewModel.announcement.seller,
      );

      await widget.myAnnouncementsViewModel.updateAnnouncement(announcement);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anúncio atualizado com sucesso!')),
      );
      Navigator.pop(context);
    }
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
    _addressController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Header(title: 'Editar Anúncio'),
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
                      CustomTextFormField(
                        controller: _addressController,
                        labelText: 'Endereço',
                        hintText: 'Endereço do anúncio',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o endereço do anúncio';
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
                      const SizedBox(height: 20),
                      Text(
                        'Imagens (até 4)',
                        style: GoogleFonts.sora(
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
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
