import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/repositories/app_repository.dart';

class ExportService {
  Future<void> exportJson() async {
    final data = AppRepository.instance.exportAll();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/deep_work_export_v1.json');
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(data));
    await Share.shareXFiles([XFile(file.path)], text: 'Deep Work Routine export');
  }
}
