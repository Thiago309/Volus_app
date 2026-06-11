import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:volus_app/features/home/presentation/screens/main_navigation_screen.dart';
import 'package:volus_app/features/home/presentation/screens/admin_navigation_screen.dart';
import '../../../../core/theme/teto_colors.dart';

enum UserRole { volunteer, admin }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  UserRole _selectedRole = UserRole.volunteer;

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Não foi possível abrir o link: $urlString')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao tentar abrir o link: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              TetoColors.backgroundStart,
              TetoColors.backgroundEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                
                // Header Logo and App Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(32, 32),
                      painter: TetoLogoPainter(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Voluts TETO',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: TetoColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Subtitle
                Text(
                  'Plataforma do Voluntário',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: TetoColors.primaryBlue,
                  ),
                ),
                
                const SizedBox(height: 20),
                Text(
                  'Você deseja entrar como:',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: TetoColors.textMuted,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Role Selector Switch
                Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    color: TetoColors.socialButtonBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      // Voluntário Option
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedRole = UserRole.volunteer;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _selectedRole == UserRole.volunteer
                                  ? TetoColors.primaryBlue
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Voluntário',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _selectedRole == UserRole.volunteer
                                    ? Colors.white
                                    : TetoColors.textMuted,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Administrador Option
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedRole = UserRole.admin;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _selectedRole == UserRole.admin
                                  ? TetoColors.primaryBlue
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Administrador',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _selectedRole == UserRole.admin
                                    ? Colors.white
                                    : TetoColors.textMuted,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // White Card containing the login form
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: TetoColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // E-mail Label and Field
                        Text(
                          'E-mail',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: TetoColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: GoogleFonts.inter(fontSize: 15),
                          decoration: InputDecoration(
                            hintText: 'seu@email.com',
                            hintStyle: GoogleFonts.inter(color: TetoColors.textMuted.withOpacity(0.6)),
                            prefixIcon: const Icon(Icons.email_outlined, color: TetoColors.inputIcon, size: 20),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: TetoColors.borderSide),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: TetoColors.borderSide),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: TetoColors.primaryBlue, width: 1.5),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Senha Label and Field
                        Text(
                          'Senha',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: TetoColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: GoogleFonts.inter(fontSize: 15),
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            hintStyle: GoogleFonts.inter(color: TetoColors.textMuted.withOpacity(0.6)),
                            prefixIcon: const Icon(Icons.lock_outline_rounded, color: TetoColors.inputIcon, size: 20),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: TetoColors.inputIcon,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: TetoColors.borderSide),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: TetoColors.borderSide),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: TetoColors.primaryBlue, width: 1.5),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Forgot Password Link
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              // Action for forgot password
                            },
                            child: Text(
                              'Esqueci minha senha',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: TetoColors.textLink,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // "Entrar" Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => _selectedRole == UserRole.volunteer
                                        ? const MainNavigationScreen()
                                        : const AdminNavigationScreen(),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: TetoColors.primaryBlue,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Entrar',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.login, size: 18),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // "Quero ser voluntário" Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () => _launchUrl('https://br.techo.org/voluntariado-5/'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: TetoColors.primaryGreen,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Quero ser voluntário',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Terms of Use & Privacy Policy Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: TetoColors.textMuted,
                        height: 1.4,
                      ),
                      children: [
                        const TextSpan(text: 'Ao entrar, você concorda com nossos\n'),
                        TextSpan(
                          text: 'Termos de Uso',
                          style: const TextStyle(
                            color: TetoColors.textLink,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigate/open terms
                            },
                        ),
                        const TextSpan(text: ' e '),
                        TextSpan(
                          text: 'Política de Privacidade',
                          style: const TextStyle(
                            color: TetoColors.textLink,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigate/open privacy policy
                            },
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Footer buttons: Sobre a TETO / Instagram
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFooterButton(
                      icon: Icons.language,
                      label: 'Sobre a TETO',
                      onTap: () => _launchUrl('https://br.techo.org/'),
                    ),
                    const SizedBox(width: 32),
                    _buildFooterButton(
                      icon: Icons.camera_alt_outlined,
                      label: 'Instagram',
                      onTap: () => _launchUrl('https://www.instagram.com/teto.br/'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: TetoColors.socialButtonBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: TetoColors.socialButtonIcon,
              size: 22,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: TetoColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter to draw the TETO Logo (green arrow roof + blue house)
class TetoLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintBlue = Paint()
      ..color = TetoColors.primaryBlue
      ..style = PaintingStyle.fill;

    final paintGreen = Paint()
      ..color = TetoColors.primaryGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    // Draw house base (blue)
    final housePath = Path();
    housePath.moveTo(w * 0.25, h * 0.85);
    housePath.lineTo(w * 0.25, h * 0.52);
    housePath.lineTo(w * 0.5, h * 0.30);
    housePath.lineTo(w * 0.75, h * 0.52);
    housePath.lineTo(w * 0.75, h * 0.85);
    housePath.close();
    canvas.drawPath(housePath, paintBlue);

    // Draw house door (white)
    final doorPath = Path();
    doorPath.moveTo(w * 0.42, h * 0.85);
    doorPath.lineTo(w * 0.42, h * 0.62);
    doorPath.lineTo(w * 0.58, h * 0.62);
    doorPath.lineTo(w * 0.58, h * 0.85);
    doorPath.close();
    canvas.drawPath(doorPath, Paint()..color = Colors.white..style = PaintingStyle.fill);

    // Draw house window (white)
    final windowPaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(w * 0.43, h * 0.42, w * 0.14, h * 0.12),
      windowPaint,
    );

    // Draw green curved arrow roof
    // A curve extending from left to right, bending up, then slightly curving down like an arrow
    final roofPath = Path();
    roofPath.moveTo(w * 0.12, h * 0.58);
    // Control point at top center
    roofPath.quadraticBezierTo(w * 0.5, h * 0.10, w * 0.88, h * 0.58);
    canvas.drawPath(roofPath, paintGreen);

    // Small arrow head at the end of the green line (w * 0.88, h * 0.58)
    final arrowPath = Path();
    arrowPath.moveTo(w * 0.88, h * 0.58);
    arrowPath.lineTo(w * 0.82, h * 0.50);
    arrowPath.moveTo(w * 0.88, h * 0.58);
    arrowPath.lineTo(w * 0.92, h * 0.50);
    
    final paintArrow = Paint()
      ..color = TetoColors.primaryGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(arrowPath, paintArrow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
