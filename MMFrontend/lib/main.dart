import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/storage/preferences_storage.dart';
import 'features/auth/domain/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefsService = await PreferencesStorageService.init();

  runApp(
    ProviderScope(
      overrides: [
        preferencesProvider.overrideWithValue(prefsService),
      ],
      child: const MandiMinutesApp(),
    ),
  );
}
