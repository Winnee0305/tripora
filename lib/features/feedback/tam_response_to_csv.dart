import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

/// Fetches all TAM responses from Firestore
Future<List<Map<String, dynamic>>> fetchAllTamResponses() async {
  try {
    debugPrint('📥 Fetching TAM responses from Firestore...');
    final snapshot = await FirebaseFirestore.instance
        .collection('tam_responses')
        .get();

    final responses = <Map<String, dynamic>>[];
    for (var doc in snapshot.docs) {
      responses.add({'docId': doc.id, ...doc.data()});
    }

    debugPrint('✅ Fetched ${responses.length} TAM responses');
    return responses;
  } catch (e) {
    debugPrint('❌ Error fetching TAM responses: $e');
    rethrow;
  }
}

/// Converts TAM responses to CSV format
List<List<dynamic>> convertTamResponsesToCsv(
  List<Map<String, dynamic>> tamResponses,
) {
  try {
    debugPrint('📝 Converting TAM responses to CSV format...');

    // CSV Header
    const header = [
      'Document ID',
      'User ID',
      'Feature Evaluated',
      'App Version',
      'Completed At',
      'PEOU_1',
      'PEOU_2',
      'PEOU_3',
      'PEOU_4',
      'PEOU_5',
      'PEOU_6',
      'PU_1',
      'PU_2',
      'PU_3',
      'PU_4',
      'PU_5',
      'PU_6',
    ];

    final csvData = <List<dynamic>>[header];

    for (var response in tamResponses) {
      final docId = response['docId'] ?? '';
      final userId = response['userId'] ?? '';
      final featureEvaluated = response['featureEvaluated'] ?? '';
      final appVersion = response['appVersion'] ?? '';

      // Format timestamp
      String completedAtStr = '';
      if (response['completedAt'] != null) {
        final timestamp = response['completedAt'] as Timestamp;
        completedAtStr = timestamp.toDate().toString();
      }

      // Extract PEOU responses (Perceived Ease of Use)
      final peouList = <dynamic>['', '', '', '', '', ''];
      if (response['responses'] != null &&
          response['responses'] is Map &&
          response['responses']['PEOU'] != null) {
        final peouResponses = response['responses']['PEOU'] as List?;
        if (peouResponses != null) {
          for (int i = 0; i < peouResponses.length && i < 6; i++) {
            peouList[i] = peouResponses[i] ?? '';
          }
        }
      }

      // Extract PU responses (Perceived Usefulness)
      final puList = <dynamic>['', '', '', '', '', ''];
      if (response['responses'] != null &&
          response['responses'] is Map &&
          response['responses']['PU'] != null) {
        final puResponses = response['responses']['PU'] as List?;
        if (puResponses != null) {
          for (int i = 0; i < puResponses.length && i < 6; i++) {
            puList[i] = puResponses[i] ?? '';
          }
        }
      }

      // Build row
      final row = [
        docId,
        userId,
        featureEvaluated,
        appVersion,
        completedAtStr,
        ...peouList,
        ...puList,
      ];

      csvData.add(row);
    }

    debugPrint('✅ Converted ${tamResponses.length} responses to CSV');
    return csvData;
  } catch (e) {
    debugPrint('❌ Error converting to CSV: $e');
    rethrow;
  }
}

/// Saves CSV data to a file
Future<String> saveCsvToFile(List<List<dynamic>> csvData) async {
  try {
    debugPrint('💾 Saving CSV to file...');

    // Get the documents directory
    final directory = await getApplicationDocumentsDirectory();

    // Create filename with timestamp
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final filename = 'tam_responses_$timestamp.csv';
    final filePath = '${directory.path}/$filename';

    // Convert CSV data to string
    final csvString = const ListToCsvConverter().convert(csvData);

    // Write to file
    final file = File(filePath);
    await file.writeAsString(csvString);

    debugPrint('✅ CSV saved to: $filePath');
    return filePath;
  } catch (e) {
    debugPrint('❌ Error saving CSV file: $e');
    rethrow;
  }
}

/// Main function to fetch TAM responses and save to CSV
/// Returns the file path of the saved CSV
Future<String> exportTamResponsesToCsv() async {
  try {
    debugPrint('🚀 Starting TAM responses export...');

    // Fetch all responses
    final tamResponses = await fetchAllTamResponses();

    if (tamResponses.isEmpty) {
      debugPrint('⚠️ No TAM responses found');
      throw Exception('No TAM responses found in database');
    }

    // Convert to CSV format
    final csvData = convertTamResponsesToCsv(tamResponses);

    // Save to file
    final filePath = await saveCsvToFile(csvData);

    debugPrint('✅ TAM responses export completed successfully');
    debugPrint('📄 File location: $filePath');

    return filePath;
  } catch (e) {
    debugPrint('❌ TAM responses export failed: $e');
    rethrow;
  }
}

/// Alternative: Save CSV to external storage (if permissions granted)
/// This is useful for sharing the file on Android/iOS
Future<String?> saveCsvToExternalStorage(List<List<dynamic>> csvData) async {
  try {
    debugPrint('💾 Saving CSV to external storage...');

    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      debugPrint('⚠️ External storage not available');
      return null;
    }

    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final filename = 'tam_responses_$timestamp.csv';
    final filePath = '${directory.path}/$filename';

    final csvString = const ListToCsvConverter().convert(csvData);
    final file = File(filePath);
    await file.writeAsString(csvString);

    debugPrint('✅ CSV saved to external storage: $filePath');
    return filePath;
  } catch (e) {
    debugPrint('❌ Error saving to external storage: $e');
    return null;
  }
}

/// Fetches TAM responses for a specific feature
Future<List<Map<String, dynamic>>> fetchTamResponsesByFeature(
  String featureName,
) async {
  try {
    debugPrint('📥 Fetching TAM responses for feature: $featureName');
    final snapshot = await FirebaseFirestore.instance
        .collection('tam_responses')
        .where('featureEvaluated', isEqualTo: featureName)
        .get();

    final responses = <Map<String, dynamic>>[];
    for (var doc in snapshot.docs) {
      responses.add({'docId': doc.id, ...doc.data()});
    }

    debugPrint('✅ Fetched ${responses.length} responses for $featureName');
    return responses;
  } catch (e) {
    debugPrint('❌ Error fetching responses for feature: $e');
    rethrow;
  }
}

/// Fetches TAM responses for a specific user
Future<List<Map<String, dynamic>>> fetchTamResponsesByUser(
  String userId,
) async {
  try {
    debugPrint('📥 Fetching TAM responses for user: $userId');
    final snapshot = await FirebaseFirestore.instance
        .collection('tam_responses')
        .where('userId', isEqualTo: userId)
        .get();

    final responses = <Map<String, dynamic>>[];
    for (var doc in snapshot.docs) {
      responses.add({'docId': doc.id, ...doc.data()});
    }

    debugPrint('✅ Fetched ${responses.length} responses for user $userId');
    return responses;
  } catch (e) {
    debugPrint('❌ Error fetching responses for user: $e');
    rethrow;
  }
}
