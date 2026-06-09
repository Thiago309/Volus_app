import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volus_app/main.dart';

void main() {
  testWidgets('Login screen and home/agenda navigation test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // 1. Verify that the login screen widgets are present
    expect(find.text('Plataforma do Voluntário'), findsOneWidget);
    expect(find.text('Voluts TETO'), findsOneWidget);
    expect(find.text('Você deseja entrar como:'), findsOneWidget);
    expect(find.text('Voluntário'), findsOneWidget);
    expect(find.text('Administrador'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Quero ser voluntário'), findsOneWidget);

    // 2. Tap the 'Entrar' button to navigate
    await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));
    await tester.pumpAndSettle(); // Wait for navigation transition to complete

    // 3. Verify that we successfully transitioned to the new welcome HomeScreen
    expect(find.text('Olá, Voluntário!'), findsOneWidget);
    expect(find.text('Acesso Rápido'), findsOneWidget);

    // 4. Tap the 'Agenda' tab on BottomNavigationBar to go to AgendaScreen
    await tester.tap(find.byIcon(Icons.calendar_month_outlined));
    await tester.pumpAndSettle();

    // 5. Verify that we successfully loaded the AgendaScreen
    expect(find.text('Resumo das Atividades'), findsOneWidget);
    expect(find.text('Equipe Disponível'), findsOneWidget);
    expect(find.text('Agenda Futura'), findsOneWidget);
    
    // Check that stats cards data is rendered
    expect(find.text('124h'), findsOneWidget);
    expect(find.text('18'), findsOneWidget);
  });
}
