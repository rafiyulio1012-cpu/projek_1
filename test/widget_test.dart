import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elite_wealth/main.dart';

void main() {
  testWidgets('App launches and shows Login screen', (WidgetTester tester) async {
    // Build app
    await tester.pumpWidget(const EliteWealthApp());
    await tester.pumpAndSettle();

    // Pastikan app berhasil di-render
    expect(find.byType(EliteWealthApp), findsOneWidget);

    // Pastikan halaman Login muncul dengan brand name
    expect(find.text('ELITE WEALTH'), findsWidgets);

    // Pastikan field email dan password tersedia
    expect(find.byType(TextFormField), findsWidgets);

    // Pastikan tombol Login tersedia
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Login screen has Register link', (WidgetTester tester) async {
    await tester.pumpWidget(const EliteWealthApp());
    await tester.pumpAndSettle();

    // Pastikan link ke Register tersedia
    expect(find.text('Register'), findsOneWidget);
  });

  testWidgets('Login form shows validation errors when empty', (WidgetTester tester) async {
    await tester.pumpWidget(const EliteWealthApp());
    await tester.pumpAndSettle();

    // Tap tombol Login tanpa mengisi form
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Validasi error muncul
    expect(find.text('Email wajib diisi'), findsOneWidget);
    expect(find.text('Password wajib diisi'), findsOneWidget);
  });
}