import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

/// Enhanced logging service with extensive capabilities for debugging
class LogsService {
  static final LogsService _instance = LogsService._internal();
  factory LogsService() => _instance;

  // Configuration options
  bool _enableNetworkLogs = true;
  bool _enableCacheLogs = true;
  bool _enableFileLogging = false;
  final bool _isProduction = const bool.fromEnvironment('dart.vm.product');

  // Performance metrics
  final Map<String, List<Duration>> _endpointTimings = {};
  final Map<String, int> _statusCodeCounts = {};

  // Sensitive keys that should be redacted in logs
  final List<String> _sensitiveKeys = [
    'password',
    'token',
    'authorization',
    'cookie',
    'access_token',
    'refresh_token',
    'gtrack_token',
  ];

  // Logger instance
  late Logger _logger;
  late LogOutput? _fileOutput;

  LogsService._internal() {
    _initLogger();
  }

  Future<void> _initLogger() async {
    // Setup file output if enabled
    if (_enableFileLogging && !kIsWeb) {
      await _setupFileLogging();
    }

    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 3,
        lineLength: 120,
        colors: !_isProduction,
        printEmojis: true,
      ),
      filter: _isProduction ? ProductionFilter() : DevelopmentFilter(),
      output:
          _fileOutput != null
              ? MultiOutput([ConsoleOutput(), _fileOutput!])
              : ConsoleOutput(),
    );

    logInfo('Logger initialized. Production mode: $_isProduction');
  }

  Future<void> _setupFileLogging() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logFile = File('${directory.path}/app_logs.log');

      // Rotate logs if file is too large (>5MB)
      if (await logFile.exists() &&
          (await logFile.length()) > 5 * 1024 * 1024) {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        await logFile.rename('${directory.path}/app_logs_$timestamp.log');
      }

      _fileOutput = FileOutput(file: logFile);
      logInfo('File logging set up at: ${logFile.path}');
    } catch (e) {
      print('Error setting up file logging: $e');
    }
  }

  /// Configure the logging service
  void configure({
    bool? enableNetworkLogs,
    bool? enableCacheLogs,
    bool? enableFileLogging,
    List<String>? additionalSensitiveKeys,
  }) async {
    if (enableNetworkLogs != null) _enableNetworkLogs = enableNetworkLogs;
    if (enableCacheLogs != null) _enableCacheLogs = enableCacheLogs;
    if (enableFileLogging != null) {
      _enableFileLogging = enableFileLogging;
      if (_enableFileLogging && _fileOutput == null && !kIsWeb) {
        await _setupFileLogging();
        // Recreate the logger with the file output
        _initLogger();
      }
    }

    if (additionalSensitiveKeys != null) {
      _sensitiveKeys.addAll(additionalSensitiveKeys);
    }

    logInfo(
      'Logger reconfigured: network=$_enableNetworkLogs, cache=$_enableCacheLogs, file=$_enableFileLogging',
    );
  }

  // Redacts sensitive information from logs
  String _redactSensitiveInfo(String input) {
    String result = input;
    for (final key in _sensitiveKeys) {
      final regex = RegExp('"$key"\\s*:\\s*"[^"]*"', caseSensitive: false);
      result = result.replaceAllMapped(regex, (match) {
        return '"$key": "****REDACTED****"';
      });

      // Also check for Authorization header format
      if (key.toLowerCase() == 'authorization') {
        final authRegex = RegExp(
          '"Authorization"\\s*:\\s*"[^"]*"',
          caseSensitive: false,
        );
        result = result.replaceAllMapped(authRegex, (match) {
          return '"Authorization": "****REDACTED****"';
        });
      }
    }
    return result;
  }

  void logRequest(
    String url,
    String method,
    Map<String, String> headers,
    dynamic body,
  ) {
    if (!_enableNetworkLogs) return;

    final requestLog = StringBuffer();
    requestLog.writeln('\n🌐 REQUEST DETAILS');
    requestLog.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    requestLog.writeln('URL: $url');
    requestLog.writeln('METHOD: $method');

    // Redact sensitive headers
    var headersStr = const JsonEncoder.withIndent('  ').convert(headers);
    headersStr = _redactSensitiveInfo(headersStr);
    requestLog.writeln('HEADERS: $headersStr');

    if (body != null) {
      var bodyStr =
          body is String
              ? body
              : const JsonEncoder.withIndent('  ').convert(body);

      // Redact sensitive body content
      bodyStr = _redactSensitiveInfo(bodyStr);
      requestLog.writeln('BODY: $bodyStr');
    }

    _logger.i(requestLog.toString());
  }

  void logResponse(http.Response response, Duration duration) {
    if (!_enableNetworkLogs) return;

    // Track performance metrics
    final endpoint = response.request?.url.path ?? 'unknown';
    _endpointTimings.putIfAbsent(endpoint, () => []).add(duration);

    // Track status code metrics
    final statusCode = response.statusCode.toString();
    _statusCodeCounts[statusCode] = (_statusCodeCounts[statusCode] ?? 0) + 1;

    final responseLog = StringBuffer();
    responseLog.writeln('\n📨 RESPONSE DETAILS [${duration.inMilliseconds}ms]');
    responseLog.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    responseLog.writeln('STATUS: ${response.statusCode}');
    responseLog.writeln('URL: ${response.request?.url}');

    if (response.headers.isNotEmpty) {
      var headersStr = const JsonEncoder.withIndent(
        '  ',
      ).convert(response.headers);
      headersStr = _redactSensitiveInfo(headersStr);
      responseLog.writeln('HEADERS: $headersStr');
    }

    if (response.body.isNotEmpty) {
      try {
        final dynamic decodedBody = json.decode(response.body);
        var prettyJson = const JsonEncoder.withIndent(
          '  ',
        ).convert(decodedBody);
        prettyJson = _redactSensitiveInfo(prettyJson);
        responseLog.writeln('BODY: $prettyJson');
      } catch (e) {
        responseLog.writeln(
          'BODY: ${response.body.length > 1000 ? '${response.body.substring(0, 1000)}... (truncated)' : response.body}',
        );
      }
    }

    final icon =
        response.statusCode >= 200 && response.statusCode < 300
            ? '✅'
            : (response.statusCode >= 400 ? '❌' : '⚠️');
    _logger.i('$icon ${responseLog.toString()}');
  }

  void logCache(String action, String endpoint) {
    if (!_enableCacheLogs) return;

    final emoji = _getCacheEmoji(action.toLowerCase());
    _logger.i('$emoji Cache ${action.toUpperCase()}: $endpoint');
  }

  String _getCacheEmoji(String action) {
    switch (action) {
      case 'hit':
        return '📦';
      case 'miss':
        return '🔍';
      case 'store':
        return '💾';
      case 'clear':
        return '🧹';
      case 'expired':
        return '⏱️';
      case 'update':
        return '🔄';
      default:
        return '🔄';
    }
  }

  void logWarning(String message) {
    _logger.w('⚠️ $message');
  }

  void logError(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e('❌ $message', error: error, stackTrace: stackTrace);
  }

  void logInfo(String message) {
    _logger.i('ℹ️ $message');
  }

  void logDebug(String message) {
    _logger.d('🔍 $message');
  }

  void logVerbose(String message) {
    _logger.v('🔬 $message'); // Fixed emoji
  }

  /// Log network performance statistics
  void logNetworkStats() {
    if (!_enableNetworkLogs || _endpointTimings.isEmpty) return;

    final statsLog = StringBuffer();
    statsLog.writeln('\n📊 NETWORK STATISTICS');
    statsLog.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    // Endpoint timing statistics
    statsLog.writeln('ENDPOINT PERFORMANCE:');
    _endpointTimings.forEach((endpoint, times) {
      if (times.isEmpty) return;

      final avgTime =
          times.reduce((a, b) => a + b).inMilliseconds / times.length;
      final maxTime = times
          .map((t) => t.inMilliseconds)
          .reduce((a, b) => a > b ? a : b);

      statsLog.writeln(
        '  $endpoint: ${times.length} calls, avg: ${avgTime.toStringAsFixed(1)}ms, max: ${maxTime}ms',
      );
    });

    // Status code distribution
    statsLog.writeln('\nSTATUS CODE DISTRIBUTION:');
    _statusCodeCounts.forEach((code, count) {
      String icon = '➖';
      if (code.startsWith('2'))
        icon = '✅';
      else if (code.startsWith('4') || code.startsWith('5'))
        icon = '❌';
      else if (code.startsWith('3'))
        icon = '↪️';

      statsLog.writeln('  $icon $code: $count times');
    });

    _logger.i(statsLog.toString());
  }

  /// Clears performance tracking data
  void clearNetworkStats() {
    _endpointTimings.clear();
    _statusCodeCounts.clear();
    logInfo('Network statistics cleared');
  }

  /// Log a performance metric for any operation
  void logPerformance(String operation, Duration duration) {
    _logger.i('⏱️ PERFORMANCE: $operation took ${duration.inMilliseconds}ms');
  }
}

/// Custom file output for saving logs to a file
class FileOutput extends LogOutput {
  final File file;

  FileOutput({required this.file});

  @override
  void output(OutputEvent event) async {
    for (var line in event.lines) {
      await file.writeAsString(
        '${line.replaceAll(RegExp(r'\x1B\[[0-9;]*m'), '')}\n',
        mode: FileMode.append,
      );
    }
  }
}
