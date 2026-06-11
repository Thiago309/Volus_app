import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:volus_app/core/theme/teto_colors.dart';

class DepoimentosPendentesScreen extends StatefulWidget {
  final List<Map<String, String>> pendingTestimonials;
  final Function(String) onApprove;
  final Function(String) onReject;

  const DepoimentosPendentesScreen({
    super.key,
    required this.pendingTestimonials,
    required this.onApprove,
    required this.onReject,
  });

  @override
  State<DepoimentosPendentesScreen> createState() => _DepoimentosPendentesScreenState();
}

class _DepoimentosPendentesScreenState extends State<DepoimentosPendentesScreen> {
  late List<Map<String, String>> _localTestimonials;

  @override
  void initState() {
    super.initState();
    _localTestimonials = List.from(widget.pendingTestimonials);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: TetoColors.primaryBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Depoimentos Pendentes',
          style: GoogleFonts.inter(
            color: TetoColors.primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: TetoColors.borderSide.withOpacity(0.5),
            height: 1.0,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF9FBFC),
      body: SafeArea(
        child: _localTestimonials.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      size: 64,
                      color: TetoColors.textMuted.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhum depoimento pendente!',
                      style: GoogleFonts.inter(
                        color: TetoColors.textMuted,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                itemCount: _localTestimonials.length,
                itemBuilder: (context, index) {
                  final t = _localTestimonials[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: TetoColors.borderSide.withOpacity(0.8)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.01),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Color(int.parse(t['avatarBg']!)),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            t['initial']!,
                            style: GoogleFonts.inter(
                              color: Color(int.parse(t['avatarText']!)),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Text Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t['name']!,
                                style: GoogleFonts.inter(
                                  color: TetoColors.textDark,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                t['text']!,
                                style: GoogleFonts.inter(
                                  color: TetoColors.textMuted,
                                  fontSize: 14,
                                  height: 1.4,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Actions Column
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                widget.onApprove(t['id']!);
                                setState(() {
                                  _localTestimonials.removeAt(index);
                                });
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Depoimento de ${t['name']} aprovado!',
                                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                    ),
                                    backgroundColor: TetoColors.primaryGreen,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.check, color: TetoColors.primaryGreen, size: 20),
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFFDCFCE7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: const EdgeInsets.all(10),
                              ),
                            ),
                            const SizedBox(height: 8),
                            IconButton(
                              onPressed: () {
                                widget.onReject(t['id']!);
                                setState(() {
                                  _localTestimonials.removeAt(index);
                                });
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Depoimento de ${t['name']} rejeitado!',
                                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                    ),
                                    backgroundColor: const Color(0xFFDC2626),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.close, color: Color(0xFFDC2626), size: 20),
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFFFEE2E2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: const EdgeInsets.all(10),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
