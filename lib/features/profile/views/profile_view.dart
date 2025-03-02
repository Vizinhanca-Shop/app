import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vizinhanca_shop/data/services/auth_service.dart';
import 'package:vizinhanca_shop/di/locator.dart';
import 'package:vizinhanca_shop/features/login/viewmodels/login_view_model.dart';
import 'package:vizinhanca_shop/features/profile/viewmodels/profile_view_model.dart';
import 'package:vizinhanca_shop/shared/custom_text_form_field.dart';
import 'package:vizinhanca_shop/shared/header.dart';
import 'package:vizinhanca_shop/shared/login.dart';
import 'package:vizinhanca_shop/theme/app_colors.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:image_picker/image_picker.dart';

var phoneMaskFormatter = MaskTextInputFormatter(
  mask: '(##) #####-####',
  filter: {"#": RegExp(r'[0-9]')},
);

class ProfileView extends StatefulWidget {
  final AuthService authService;
  final ProfileViewModel viewModel;

  const ProfileView({
    super.key,
    required this.authService,
    required this.viewModel,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _isLoggedIn = false;
  final _formKey = GlobalKey<FormState>();
  final _avatar = ValueNotifier<XFile?>(null);
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  bool _hasChanges = false;

  void _checkAuthStatus() async {
    final isLoggedIn = await widget.authService.isUserLoggedIn();
    setState(() {
      _isLoggedIn = isLoggedIn;
    });

    if (isLoggedIn) {
      await widget.viewModel.fetchUserById(userId: '1');
      _initControllers();
    }
  }

  void _initControllers() {
    _nameController.text = widget.viewModel.user.name;

    final phoneValue = widget.viewModel.user.phone;

    if (phoneValue.isNotEmpty) {
      final digitsOnly = phoneValue.replaceAll(RegExp(r'[^\d]'), '');

      _phoneController.text = phoneMaskFormatter.maskText(digitsOnly);
    } else {
      _phoneController.text = phoneValue;
    }
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _avatar.value = pickedFile;
      _onFieldChanged();
      // widget.viewModel.handleUpdateAvatar(pickedFile);
    }
  }

  void _authStateChanged() async {
    final isLoggedIn = widget.authService.isLoggedIn;
    if (isLoggedIn && !_isLoggedIn) {
      setState(() {
        _isLoggedIn = true;
      });

      await widget.viewModel.fetchUserById(userId: '1');
      _initControllers();
    } else if (!isLoggedIn && _isLoggedIn) {
      setState(() {
        _isLoggedIn = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _checkAuthStatus();

    widget.authService.addListener(_authStateChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    widget.authService.removeListener(_authStateChanged);
    super.dispose();
  }

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Implementar a lógica para salvar as alterações
    // Exemplo:
    // widget.viewModel.updateUserProfile(
    //   name: _nameController.text,
    //   phone: _phoneController.text,
    // );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'Perfil atualizado com sucesso!',
                style: GoogleFonts.sora(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    setState(() {
      _hasChanges = false;
    });
  }

  void _onFieldChanged() {
    setState(() {
      _hasChanges =
          _avatar.value != null ||
          _nameController.text != widget.viewModel.user.name ||
          _phoneController.text != widget.viewModel.user.phone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Header(title: 'Perfil'),
      body: Builder(
        builder: (context) {
          if (!_isLoggedIn) {
            return Transform.translate(
              offset: Offset(0, -100),
              child: Login(
                loginViewModel: locator<LoginViewModel>(),
                title: 'Faça login para acessar o perfil',
                message: 'Você precisa estar logado para acessar o perfil',
              ),
            );
          }

          return ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, snapshot) {
              if (widget.viewModel.isLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              ValueListenableBuilder<XFile?>(
                                valueListenable: _avatar,
                                builder: (context, avatar, child) {
                                  return CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        avatar != null
                                            ? FileImage(File(avatar.path))
                                            : NetworkImage(
                                                  widget.viewModel.user.avatar,
                                                )
                                                as ImageProvider,
                                  );
                                },
                              ),
                              Positioned(
                                bottom: -10,
                                right: -10,
                                child: IconButton(
                                  color: Colors.white,
                                  iconSize: 20,
                                  padding: const EdgeInsets.all(0),
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.grey[800],
                                  ),
                                  onPressed: _pickImage,
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(
                                      Colors.white,
                                    ),
                                    shape: WidgetStateProperty.all(
                                      const CircleBorder(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 32),
                        CustomTextFormField(
                          controller: _nameController,
                          onChanged: (_) => _onFieldChanged(),
                          labelText: 'Nome',
                          hintText: 'Digite seu nome',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira seu nome';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24),
                        CustomTextFormField(
                          controller: _phoneController,
                          onChanged: (_) => _onFieldChanged(),
                          labelText: 'Telefone',
                          hintText: 'Digite seu telefone',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          inputFormatters: [phoneMaskFormatter],
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira seu telefone';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Builder(
        builder: (context) {
          if (!_isLoggedIn) {
            return SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
            child: ElevatedButton(
              onPressed: _hasChanges ? _saveChanges : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: Colors.grey[300],
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Salvar Alterações',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
