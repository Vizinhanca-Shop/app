import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vizinhanca_shop/features/profile/viewmodels/profile_view_model.dart';

class DeleteAccountDialog extends StatelessWidget {
  final VoidCallback onDelete;
  final ProfileViewModel profileViewModel;

  const DeleteAccountDialog({
    super.key,
    required this.onDelete,
    required this.profileViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: profileViewModel,
      builder: (context, snapshot) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tem certeza que deseja excluir sua conta?',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Essa ação é irreversível.',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 26),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[400],
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Excluir',
                          style: TextStyle(fontSize: 16, color: Colors.white),
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
    );
  }
}

class DialogHelper {
  static Future<void> showDeleteAccountDialog(
    BuildContext context, {
    required VoidCallback onDelete,
    required ProfileViewModel profileViewModel,
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return DeleteAccountDialog(
          onDelete: onDelete,
          profileViewModel: profileViewModel,
        );
      },
    );
  }
}
