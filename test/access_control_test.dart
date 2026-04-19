import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zhkh_app/models/user.dart';
import 'package:zhkh_app/screens/admin/admin_screen.dart';
import 'package:zhkh_app/widgets/header.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  User buildUser() {
    return User(
      id: 'u1',
      name: 'Test User',
      email: 'test@example.com',
      phone: '+7 900 000-00-00',
      property: Property(id: 'p1', name: 'Sunset Apartments', unit: 'Unit 4B'),
    );
  }

  testWidgets('Admin menu item is hidden for resident role', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'isLoggedIn': true,
      'userRole': 'resident',
    });

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: AppHeader(user: buildUser()))),
    );

    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();

    expect(find.text('Админ панель'), findsNothing);
  });

  testWidgets('Admin menu item is visible for admin role', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'isLoggedIn': true,
      'userRole': 'admin',
    });

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: AppHeader(user: buildUser()))),
    );

    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();

    expect(find.text('Админ панель'), findsOneWidget);
  });

  testWidgets('Admin screen denies access for resident role', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'isLoggedIn': true,
      'userRole': 'resident',
    });

    await tester.pumpWidget(const MaterialApp(home: AdminScreen()));
    await tester.pumpAndSettle();

    expect(
      find.text('Доступ запрещен. Требуются права администратора.'),
      findsOneWidget,
    );
  });
}
