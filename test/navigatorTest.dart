import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:share_yourself_artists_team_flutter/authentication/authentication.dart';
import 'package:share_yourself_artists_team_flutter/authentication/login/forgotPassword.dart';
import 'package:share_yourself_artists_team_flutter/routes.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockAuthentication extends Mock implements Authentication {}

Widget createLaunch({MockNavigatorObserver navigatorObserver}) {
  return new MaterialApp(
    routes: routes,
    initialRoute: '/',
    navigatorObservers: [navigatorObserver],
  );
}

void main() {
  testWidgets('Test navigation after valid log in',
      (WidgetTester tester) async {
    MockNavigatorObserver mockNavigatorObserver = MockNavigatorObserver();

    // Pump new MaterialApp build
    await tester
        .pumpWidget(createLaunch(navigatorObserver: mockNavigatorObserver));
    verify(mockNavigatorObserver.didPush(any, any));

    await tester.tap(find.byKey(Key('forgot')));
    await tester.pumpAndSettle();

    // Verify that the Forgot Password page is pushed on pressed
    verify(mockNavigatorObserver.didPush(any, any));

    expect(find.byType(ForgotPasswordPage), findsOneWidget);
  });
}
