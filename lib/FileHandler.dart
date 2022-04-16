import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileHandler {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/Speedrunners.json');
  }

  Future<File> writeRun(String json) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString(json);
  }

  // returns null if no file found
  Future<String?> readRuns() async {
    try {
      final file = await _localFile;

      final exists = await file.exists();
      if (!exists) return null;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return null;
    }
  }

  Future<bool> deleteRuns() async {
    try {
      final file = await _localFile;

      await file.delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
