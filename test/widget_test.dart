import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zhkh_app/screens/home/home_screen.dart';
import 'package:zhkh_app/screens/payments/payments_screen.dart';
import 'package:zhkh_app/screens/requests/requests_list_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Smoke: home navigation opens key sections', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'isLoggedIn': true,
      'userRole': 'resident',
    });

    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Quick Actions'), findsOneWidget);

    await tester.tap(find.text('Requests'));
    await tester.pumpAndSettle();
    expect(find.byType(RequestsListScreen), findsOneWidget);

    await tester.tap(find.text('Payments'));
    await tester.pumpAndSettle();
    expect(find.byType(PaymentsScreen), findsOneWidget);
  });
}
