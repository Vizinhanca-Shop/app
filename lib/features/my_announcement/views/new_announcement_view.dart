import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vizinhanca_shop/data/models/announcement_address_model.dart';
import 'package:vizinhanca_shop/data/models/create_announcement_model.dart';
import 'package:vizinhanca_shop/features/my_announcement/viewmodels/my_announcements_view_model.dart';
import 'package:vizinhanca_shop/routes/app_routes.dart';
import 'package:vizinhanca_shop/shared/currency_input_formatter.dart';
import 'package:vizinhanca_shop/shared/custom_select.dart';
import 'package:vizinhanca_shop/shared/custom_text_form_field.dart';
import 'package:vizinhanca_shop/shared/header.dart';
import 'package:vizinhanca_shop/theme/app_colors.dart';
import 'package:vizinhanca_shop/utils/parse_price.dart';

class NewAnnouncementView extends StatefulWidget {
  final MyAnnouncementsViewModel viewModel;

  const NewAnnouncementView({super.key, required this.viewModel});

  @override
  State<NewAnnouncementView> createState() => _NewAnnouncementViewState();
}

class _NewAnnouncementViewState extends State<NewAnnouncementView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage(imageQuality: 50);
    setState(() {
      _images = [..._images, ...pickedFiles].take(4).toList();
    });
  }

  Future<void> _fetchAddressFromCep(String cep) async {
    final address = await widget.viewModel.fetchAddressFromCep(cep);

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
    final coordinates = await widget.viewModel.getCoordinatesFromAddress(
      address,
    );

    return coordinates;
  }

  Future<void> _submit() async {
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

      final CreateAnnouncementModel announcement = CreateAnnouncementModel(
        name: _nameController.text,
        description: _descriptionController.text,
        price: parsePrice(_priceController.text),
        address: AnnouncementAddressModel(
          latitude: coordinates['latitude']!.toString(),
          longitude: coordinates['longitude']!.toString(),
          postalCode: _cepController.text,
          road: _ruaController.text,
          neighborhood: _bairroController.text,
          city: _cidadeController.text,
          state: _estadoController.text,
        ),
        category: widget.viewModel.categories.firstWhere(
          (category) => category.id == _categoryController.text,
        ),
        images: _images.map((image) => image.path).toList(),
        latitude: coordinates['latitude']!,
        longitude: coordinates['longitude']!,
      );

      widget.viewModel.createAnnouncement(announcement);
    }
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
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Por favor, insira o nome do anúncio'
                            : null,
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                controller: _descriptionController,
                labelText: 'Descrição',
                hintText: 'Descrição do anúncio',
                maxLines: 3,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Por favor, insira a descrição do anúncio'
                            : null,
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                controller: _priceController,
                labelText: 'Preço',
                hintText: 'R\$ 0,00',
                keyboardType: TextInputType.number,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Por favor, insira o preço do anúncio'
                            : null,
                inputFormatters: [CurrencyInputFormatter()],
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
                onChanged: (value) {},
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Por favor, selecione a categoria'
                            : null,
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
                hintText: 'Digite o CEP (somente números)',
                keyboardType: TextInputType.number,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                onChanged: (value) {
                  if (value.length == 8) {
                    _fetchAddressFromCep(value);
                  }
                },
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Por favor, insira o CEP'
                            : null,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(8),
                ],
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                controller: _ruaController,
                labelText: 'Rua',
                hintText: 'Digite a rua',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Por favor, insira a rua'
                            : null,
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                controller: _bairroController,
                labelText: 'Bairro',
                hintText: 'Digite o bairro',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Por favor, insira o bairro'
                            : null,
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                controller: _cidadeController,
                labelText: 'Cidade',
                hintText: 'Digite a cidade',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Por favor, insira a cidade'
                            : null,
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                controller: _estadoController,
                labelText: 'Estado',
                hintText: 'Digite o estado',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Por favor, insira o estado'
                            : null,
              ),
              const SizedBox(height: 30),

              Text(
                "Imagens (até 4)",
                style: GoogleFonts.sora(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
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
        child: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, snapshot) {
            return ElevatedButton(
              onPressed: widget.viewModel.isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child:
                  widget.viewModel.isLoading
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
                        'Cadastrar Anúncio',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
            );
          },
        ),
      ),
    );
  }
}
