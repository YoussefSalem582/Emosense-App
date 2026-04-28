#!/usr/bin/env dart

/// Environment switcher script for EmoSense Flutter app
///
/// Usage:
///   dart scripts/switch_environment.dart development
///   dart scripts/switch_environment.dart production
///
/// This script copies the appropriate environment file to .env
/// so the app loads the correct configuration.
library;

import 'dart:developer' show log;
import 'dart:io';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    log('❌ Error: Please specify an environment', name: 'switch_environment');
    log('Usage: dart scripts/switch_environment.dart <environment>', name: 'switch_environment');
    log('Available environments: development, production', name: 'switch_environment');
    exit(1);
  }

  final environment = arguments[0].toLowerCase();
  final validEnvironments = ['development', 'production'];

  if (!validEnvironments.contains(environment)) {
    log('❌ Error: Invalid environment "$environment"', name: 'switch_environment');
    log('Available environments: ${validEnvironments.join(', ')}', name: 'switch_environment');
    exit(1);
  }

  try {
    switchEnvironment(environment);
    log('✅ Successfully switched to $environment environment', name: 'switch_environment');
    log('🔄 You may need to restart your Flutter app', name: 'switch_environment');
  } catch (e) {
    log('❌ Error switching environment: $e', name: 'switch_environment');
    exit(1);
  }
}

void switchEnvironment(String environment) {
  final sourceFile = File('.env.$environment');
  final targetFile = File('.env');

  // Check if source environment file exists
  if (!sourceFile.existsSync()) {
    throw Exception('Environment file .env.$environment not found');
  }

  // Create backup of current .env if it exists
  if (targetFile.existsSync()) {
    final backupFile = File('.env.backup');
    targetFile.copySync(backupFile.path);
    log('📄 Created backup: .env.backup', name: 'switch_environment');
  }

  // Copy environment file to .env
  sourceFile.copySync(targetFile.path);

  // Display configuration summary
  displayEnvironmentSummary(environment);
}

void displayEnvironmentSummary(String environment) {
  final envFile = File('.env');
  final lines = envFile.readAsLinesSync();

  String? apiBaseUrl;
  String? enableMockData;
  String? debugMode;

  for (final line in lines) {
    if (line.startsWith('API_BASE_URL=')) {
      apiBaseUrl = line.split('=')[1];
    } else if (line.startsWith('ENABLE_MOCK_DATA=')) {
      enableMockData = line.split('=')[1];
    } else if (line.startsWith('DEBUG_MODE=')) {
      debugMode = line.split('=')[1];
    }
  }

  log('\n📋 Environment Configuration Summary:', name: 'switch_environment');
  log('🌍 Environment: $environment', name: 'switch_environment');
  log('🔗 API URL: $apiBaseUrl', name: 'switch_environment');
  log('🎭 Mock Data: $enableMockData', name: 'switch_environment');
  log('🐛 Debug Mode: $debugMode', name: 'switch_environment');

  if (environment == 'production') {
    log('\n⚠️  Production Environment Notes:', name: 'switch_environment');
    log('   • Backend deployed on Render', name: 'switch_environment');
    log('   • Cold starts may take 30-60 seconds', name: 'switch_environment');
    log('   • Mock data is disabled', name: 'switch_environment');
    log('   • Debug logging is disabled', name: 'switch_environment');
  } else {
    log('\n🛠️  Development Environment Notes:', name: 'switch_environment');
    log('   • Local backend expected at localhost:8002', name: 'switch_environment');
    log('   • Mock data enabled as fallback', name: 'switch_environment');
    log('   • Debug logging enabled', name: 'switch_environment');
  }
}
