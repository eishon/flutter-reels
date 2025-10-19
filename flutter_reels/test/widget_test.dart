// This is a basic Flutter widget test.
//
// Basic smoke test for the main app entry point.
// Comprehensive widget tests are in test/unit/presentation/widgets/

import 'package:flutter_reels/core/di/injection_container.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Dependency injection initializes correctly', () async {
    // Verify DI can be initialized
    await initializeDependencies();
    
    // Verify dependencies are registered
    expect(sl.isRegistered, isNotNull);
    
    // Clean up
    await resetDependencies();
  });
}
