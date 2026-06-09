import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volus_app/main.dart';

void main() {
  testWidgets('Full flow: login, dashboard navigation, profile check, and logout', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // 1. Verify that the login screen widgets are present
    expect(find.text('Plataforma do Voluntário'), findsOneWidget);
    expect(find.text('Voluts TETO'), findsOneWidget);

    // 2. Tap the 'Entrar' button to navigate
    await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));
    await tester.pumpAndSettle(); // Wait for navigation transition to complete

    // 3. Verify that we successfully transitioned to the welcome HomeScreen
    expect(find.text('Aviso Crítico: Mudança de Clima'), findsOneWidget);
    expect(find.text('Nosso Impacto Recente'), findsOneWidget);

    // 4. Tap the 'Agenda' tab on BottomNavigationBar to go to AgendaScreen
    await tester.tap(find.byIcon(Icons.calendar_month_outlined));
    await tester.pumpAndSettle();

    // 5. Verify that we successfully loaded the AgendaScreen
    expect(find.text('Resumo das Atividades'), findsOneWidget);

    // 5.1. Tap the 'Escala' tab on BottomNavigationBar to go to EscalaScreen
    await tester.tap(find.byIcon(Icons.leaderboard_outlined));
    await tester.pumpAndSettle();

    // 5.2. Verify that we loaded the EscalaScreen in pending state
    expect(find.text('Comunidade Esperança'), findsOneWidget);
    expect(find.text('Construção'), findsOneWidget);
    expect(find.text('Sua Confirmação'), findsOneWidget);

    // 5.3. Tap 'Vou comparecer' to confirm presence
    await tester.tap(find.widgetWithText(ElevatedButton, 'Vou comparecer'));
    await tester.pumpAndSettle();

    // 5.4. Verify empty state is shown
    expect(find.text('Não há nenhuma escala pendente'), findsOneWidget);
    expect(find.text('Comunidade Esperança'), findsNothing);

    // 6. Tap the 'Perfil' tab on BottomNavigationBar to go to ProfileScreen
    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();

    // 7. Verify profile data
    expect(find.text('Meu Perfil'), findsOneWidget);
    expect(find.text('João Silva'), findsOneWidget);
    expect(find.text('Voluntário - Núcleo SP'), findsOneWidget);
    expect(find.text('Data de Nascimento'), findsOneWidget);
    expect(find.text('Termo de Voluntariado'), findsOneWidget);
    expect(find.text('Disponibilidade'), findsOneWidget);
    expect(find.text('Estou disponível'), findsOneWidget);
    expect(find.text('Sair da Conta'), findsOneWidget);

    // 8. Scroll to 'Sair da Conta' button and tap it to log out and return to Login Screen
    final logoutButton = find.widgetWithText(OutlinedButton, 'Sair da Conta');
    await tester.ensureVisible(logoutButton);
    await tester.pumpAndSettle();
    await tester.tap(logoutButton);
    await tester.pumpAndSettle();

    // 9. Verify we are back on the LoginScreen
    expect(find.text('Plataforma do Voluntário'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}
