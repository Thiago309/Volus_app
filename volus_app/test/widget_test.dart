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

    // 3.1. Tap the 'Ver todos' button in Projetos Ativos section after ensuring it is visible
    final verTodosButton = find.text('Ver todos');
    await tester.ensureVisible(verTodosButton);
    await tester.pumpAndSettle();
    await tester.tap(verTodosButton);
    await tester.pumpAndSettle();

    // 3.2. Verify that we successfully loaded the ProjetosAtivosScreen
    expect(find.text('Impacto em ação'), findsOneWidget);
    expect(find.text('Construção de Banheiros Sustentáveis'), findsOneWidget);

    // 3.3. Tap the back button to return to HomeScreen
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // 3.4. Verify we are back on HomeScreen
    expect(find.text('Nosso Impacto Recente'), findsOneWidget);

    // 3.5. Tap the 'Ver todas' button in Galeria Recente section after ensuring it is visible
    final verTodasButton = find.text('Ver todas');
    await tester.ensureVisible(verTodasButton);
    await tester.pumpAndSettle();
    await tester.tap(verTodasButton);
    await tester.pumpAndSettle();

    // 3.6. Verify that we successfully loaded the GaleriaRecenteScreen
    expect(find.text('Momentos inesquecíveis das nossas últimas ações comunitárias.'), findsOneWidget);
    expect(find.text('Construção Setor B – Mutirão Principal'), findsOneWidget);

    // 3.7. Tap 'Carregar Mais Fotos' button after scrolling
    final loadMoreButton = find.widgetWithText(OutlinedButton, 'Carregar Mais Fotos');
    await tester.ensureVisible(loadMoreButton);
    await tester.pumpAndSettle();
    await tester.tap(loadMoreButton);
    await tester.pumpAndSettle();

    // 3.8. Tap back button to return to HomeScreen
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // 3.9. Verify we are back on HomeScreen
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

    // 10. Log back in to test the redirect from ProjetosAtivosScreen to Escala tab
    await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));
    await tester.pumpAndSettle();

    // 11. Navigate to ProjetosAtivosScreen after ensuring visibility
    final verTodosButton2 = find.text('Ver todos');
    await tester.ensureVisible(verTodosButton2);
    await tester.pumpAndSettle();
    await tester.tap(verTodosButton2);
    await tester.pumpAndSettle();

    // 12. Tap 'Ver Escalas Disponíveis' after ensuring visibility
    final redirectButton = find.widgetWithText(ElevatedButton, 'Ver Escalas Disponíveis');
    await tester.ensureVisible(redirectButton);
    await tester.pumpAndSettle();
    await tester.tap(redirectButton);
    await tester.pumpAndSettle();

    // 13. Verify we redirected to Escala tab (which has reset to pending state since it's a new session)
    expect(find.text('Comunidade Esperança'), findsOneWidget);

    // 14. Confirm presence again and verify empty state is shown
    await tester.tap(find.widgetWithText(ElevatedButton, 'Vou comparecer'));
    await tester.pumpAndSettle();
    expect(find.text('Não há nenhuma escala pendente'), findsOneWidget);
  });
}
