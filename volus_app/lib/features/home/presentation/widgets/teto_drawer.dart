import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:volus_app/core/theme/teto_colors.dart';
import 'package:volus_app/features/auth/presentation/screens/login_screen.dart';

class TetoDrawer extends StatelessWidget {
  const TetoDrawer({super.key});

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Não foi possível abrir o link: $urlString')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao abrir o link: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: const BoxDecoration(
              color: TetoColors.primaryBlue,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomPaint(
                  size: const Size(40, 40),
                  painter: TetoLogoPainterWhite(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Voluts TETO',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Menu Institucional',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Drawer Links
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerTile(
                  context,
                  icon: Icons.info_outline_rounded,
                  title: 'Sobre a TETO',
                  url: 'https://br.techo.org/sobre-a-teto',
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.lightbulb_outline_rounded,
                  title: 'Porque existimos',
                  url: 'https://br.techo.org/porque-existimos/',
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.assignment_outlined,
                  title: 'O que fazemos',
                  url: 'https://br.techo.org/o-que-fazemos',
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.handshake_outlined,
                  title: 'Modelo de trabalho',
                  url: 'https://br.techo.org/modelo-de-trabalho/',
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.assignment_turned_in_outlined,
                  title: 'Transparência',
                  url: 'https://br.techo.org/transparencia/',
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.map_outlined,
                  title: 'Onde estamos',
                  url: 'https://br.techo.org/onde-estamos',
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.help_outline_rounded,
                  title: 'Mapa de Direitos',
                  url: 'https://br.techo.org/preguntas-frecuentes/',
                ),
                const Divider(color: TetoColors.borderSide, height: 24),
                _buildDrawerTile(
                  context,
                  icon: Icons.favorite_border_rounded,
                  title: 'Como doar',
                  url: 'https://br.techo.org/doacao',
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.person_pin_outlined,
                  title: 'Portal do doador',
                  url: 'https://teto.portaldodoador.org/login?utm_source=site&utm_medium=organic&utm_campaign=portal-do-doador&utm_content=site-teto-rodap%C3%A9',
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.campaign_outlined,
                  title: 'Ouvidoria',
                  url: 'https://bit.ly/ouvidoriaTETOBR',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String url,
  }) {
    return ListTile(
      leading: Icon(icon, color: TetoColors.primaryBlue, size: 22),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: TetoColors.textDark,
        ),
      ),
      trailing: const Icon(Icons.open_in_new, size: 14, color: TetoColors.inputIcon),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        _launchUrl(context, url);
      },
    );
  }
}

// Logo painter modified to look white for the dark blue drawer header
class TetoLogoPainterWhite extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintWhite = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final paintGreen = Paint()
      ..color = const Color(0xFFCBE39C) // Lighter green for dark background contrast
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    // Draw house base (white)
    final housePath = Path();
    housePath.moveTo(w * 0.25, h * 0.85);
    housePath.lineTo(w * 0.25, h * 0.52);
    housePath.lineTo(w * 0.5, h * 0.30);
    housePath.lineTo(w * 0.75, h * 0.52);
    housePath.lineTo(w * 0.75, h * 0.85);
    housePath.close();
    canvas.drawPath(housePath, paintWhite);

    // Draw house door (transparent/blue header background by painting it blue)
    final doorPath = Path();
    doorPath.moveTo(w * 0.42, h * 0.85);
    doorPath.lineTo(w * 0.42, h * 0.62);
    doorPath.lineTo(w * 0.58, h * 0.62);
    doorPath.lineTo(w * 0.58, h * 0.85);
    doorPath.close();
    canvas.drawPath(doorPath, Paint()..color = TetoColors.primaryBlue..style = PaintingStyle.fill);

    // Draw house window (blue)
    canvas.drawRect(
      Rect.fromLTWH(w * 0.43, h * 0.42, w * 0.14, h * 0.12),
      Paint()..color = TetoColors.primaryBlue..style = PaintingStyle.fill,
    );

    // Draw green curved arrow roof
    final roofPath = Path();
    roofPath.moveTo(w * 0.12, h * 0.58);
    roofPath.quadraticBezierTo(w * 0.5, h * 0.10, w * 0.88, h * 0.58);
    canvas.drawPath(roofPath, paintGreen);

    // Small arrow head
    final arrowPath = Path();
    arrowPath.moveTo(w * 0.88, h * 0.58);
    arrowPath.lineTo(w * 0.82, h * 0.50);
    arrowPath.moveTo(w * 0.88, h * 0.58);
    arrowPath.lineTo(w * 0.92, h * 0.50);
    
    final paintArrow = Paint()
      ..color = const Color(0xFFCBE39C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(arrowPath, paintArrow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
