import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vizinhanca_shop/data/services/auth_service.dart';
import 'package:vizinhanca_shop/features/main/viewmodels/main_view_model.dart';
import 'package:vizinhanca_shop/features/menu/views/widgets/delete_account_dialog.dart';
import 'package:vizinhanca_shop/features/profile/viewmodels/profile_view_model.dart';
import 'package:vizinhanca_shop/routes/app_routes.dart';
import 'package:vizinhanca_shop/shared/header.dart';

class MenuView extends StatelessWidget {
  final AuthService authService;
  final MainViewModel viewModel;
  final ProfileViewModel profileViewModel;

  const MenuView({
    super.key,
    required this.authService,
    required this.viewModel,
    required this.profileViewModel,
  });

  void _logout() {
    authService.logout();
    viewModel.navigateToHome();
  }

  void _deleteAccount() {
    DialogHelper.showDeleteAccountDialog(
      AppRoutes.navigatorKey.currentContext!,
      onDelete: () {
        profileViewModel.deleteUser();
        _logout();
      },
      profileViewModel: profileViewModel,
    );
  }

  void _editProfile() {
    Navigator.of(
      AppRoutes.navigatorKey.currentContext!,
    ).pushNamed(AppRoutes.profile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Header(title: 'Menu', hideBackButton: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seção de opções de conta
            Text(
              'Opções de Conta',
              style: GoogleFonts.sora(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),

            // Lista de opções com cards
            OptionCard(
              icon: Icons.edit,
              title: 'Editar Perfil',
              subtitle: 'Atualize suas informações pessoais',
              color: Colors.blue,
              onTap: _editProfile,
            ),

            const SizedBox(height: 12),

            OptionCard(
              icon: Icons.logout,
              title: 'Sair da Conta',
              subtitle: 'Encerrar a sessão atual',
              color: Colors.orange,
              onTap: _logout,
            ),

            const SizedBox(height: 32),

            // Seção de configurações avançadas
            Text(
              'Configurações Avançadas',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            OptionCard(
              icon: Icons.delete_forever,
              title: 'Excluir Conta',
              subtitle: 'Remover permanentemente sua conta',
              color: Colors.red,
              onTap: _deleteAccount,
              isDangerous: true,
            ),

            const Spacer(),

            // Rodapé com versão do app
            Center(
              child: Text(
                'Vizinhança Shop v1.0.0',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class OptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final bool isDangerous;

  const OptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.isDangerous = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[200]!,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.sora(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.sora(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
