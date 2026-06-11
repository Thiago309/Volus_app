import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volus_app/main.dart';
import 'package:volus_app/features/home/presentation/screens/depoimentos_pendentes_screen.dart';

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

  testWidgets('Admin flow: login as administrator, verify cards, approve testimonial, and check navigation tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // 1. Verify we are on login screen
    expect(find.text('Plataforma do Voluntário'), findsOneWidget);

    // 2. Tap the 'Administrador' role tab to switch role
    await tester.tap(find.text('Administrador'));
    await tester.pumpAndSettle();

    // 3. Tap the 'Entrar' button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));
    await tester.pumpAndSettle();

    // 4. Verify we are on the Painel Administrativo screen
    expect(find.text('Painel Administrativo'), findsOneWidget);
    expect(find.text('Bem-vindo, Admin'), findsOneWidget);

    // 5. Verify quick actions and cards
    expect(find.text('Adicionar\nProjeto'), findsOneWidget);
    expect(find.text('Postar Aviso'), findsOneWidget);
    expect(find.text('Impacto este Mês'), findsOneWidget);
    expect(find.text('Meta da Campanha'), findsOneWidget);
    expect(find.text('Avisos Urgentes'), findsOneWidget);
    expect(find.text('Depoimentos Pendentes'), findsOneWidget);
    expect(find.text('Projetos Ativos'), findsOneWidget);
    expect(find.text('Gerenciar Galeria'), findsOneWidget);

    // 6. Verify pending testimonials are visible
    expect(find.text('Maria Oliveira'), findsOneWidget);
    expect(find.text('Carlos Santos'), findsOneWidget);

    // 7. Approve the first testimonial (Maria Oliveira)
    final checkIcon = find.byIcon(Icons.check).first;
    await tester.ensureVisible(checkIcon);
    await tester.pumpAndSettle();
    await tester.tap(checkIcon);
    await tester.pumpAndSettle();

    // Verify Maria Oliveira is no longer in the list (or at least approved notification snackbar popped up)
    expect(find.text('Depoimento de Maria Oliveira aprovado!'), findsOneWidget);
    expect(find.text('Maria Oliveira'), findsNothing);
    expect(find.text('Carlos Santos'), findsOneWidget);

    // Test 'Ver Todos' redirection and moderation
    final verTodos = find.text('Ver Todos');
    await tester.ensureVisible(verTodos);
    await tester.tap(verTodos);
    await tester.pumpAndSettle();

    // Verify we are on the new screen and Carlos Santos is there
    expect(find.text('Carlos Santos'), findsOneWidget);

    // Approve Carlos Santos on the new screen
    final newCheckIcon = find.descendant(
      of: find.byType(DepoimentosPendentesScreen),
      matching: find.byIcon(Icons.check),
    ).first;
    await tester.ensureVisible(newCheckIcon);
    await tester.pumpAndSettle();
    await tester.tap(newCheckIcon);
    await tester.pumpAndSettle();

    // Verify Carlos Santos is approved and removed from the list
    expect(find.text('Depoimento de Carlos Santos aprovado!'), findsOneWidget);
    expect(find.text('Carlos Santos'), findsNothing);

    // Return to the main screen
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Verify we are back on AdminHomeScreen and no testimonials remain
    expect(find.text('Nenhum depoimento pendente!'), findsOneWidget);

    // 8. Navigation check
    // Agenda
    await tester.tap(find.byIcon(Icons.calendar_month_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Resumo das Atividades'), findsOneWidget);

    // Escala
    await tester.tap(find.byIcon(Icons.leaderboard_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Comunidade Esperança'), findsOneWidget);

    // Perfil
    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();
    expect(find.text('Meu Perfil'), findsOneWidget);
  });
}
