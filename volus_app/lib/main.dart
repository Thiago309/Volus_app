import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:volus_app/core/config/app_config.dart';
import 'package:volus_app/core/theme/teto_colors.dart';
import 'package:volus_app/features/auth/presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (AppConfig.supabaseUrl.startsWith('http')) {
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        anonKey: AppConfig.supabaseAnonKey,
      );
      
      // Teste de conexão rápida no log
      final data = await Supabase.instance.client.from('projects').select();
      debugPrint('🎉 BANCO DE DADOS CONECTADO COM SUCESSO!');
      debugPrint('Projetos cadastrados no Supabase: ${data.length}');
    }
  } catch (e) {
    debugPrint('Aviso: Supabase não inicializado ou chaves de API pendentes. $e');
  }

  runApp(const MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  const MyCustomScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voluts TETO',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MyCustomScrollBehavior(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: TetoColors.primaryBlue,
          primary: TetoColors.primaryBlue,
          secondary: TetoColors.primaryGreen,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LoginScreen(),
    );
  }
}
