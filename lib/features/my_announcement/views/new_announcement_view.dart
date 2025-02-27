import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vizinhanca_shop/features/my_announcement/viewmodels/my_announcements_view_model.dart';
import 'package:vizinhanca_shop/shared/custom_select.dart';
import 'package:vizinhanca_shop/shared/custom_text_form_field.dart';
import 'package:vizinhanca_shop/shared/header.dart';
import 'package:vizinhanca_shop/theme/app_colors.dart';

class NewAnnouncementView extends StatefulWidget {
  final MyAnnouncementsViewModel viewModel;

  const NewAnnouncementView({super.key, required this.viewModel});

  @override
  State<NewAnnouncementView> createState() => _NewAnnouncementViewState();
}

class _NewAnnouncementViewState extends State<NewAnnouncementView> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  List<XFile> _images = [];

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage(imageQuality: 50);
    setState(() {
      _images = [..._images, ...pickedFiles].take(4).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Header(title: 'Novo Anúncio'),
      body: SingleChildScrollView(
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
                controller: TextEditingController(),
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
                controller: TextEditingController(),
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
                controller: TextEditingController(),
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
                controller: TextEditingController(),
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
                controller: TextEditingController(),
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
                onChanged: (value) {},
              ),
              const SizedBox(height: 20),
              Text(
                'Imagens (até 4)',
                style: GoogleFonts.sora(fontSize: 16, color: Colors.grey[800]),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
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
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              print('Formulário válido');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Cadastrar Anúncio',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
