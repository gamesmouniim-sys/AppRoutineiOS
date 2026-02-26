import 'package:drift/drift.dart';

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get listType => text()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
}

class FocusSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get durationMinutes => integer()();
  TextColumn get category => text()();
  DateTimeColumn get completedAt => dateTime()();
  TextColumn get note => text().nullable()();
  TextColumn get doneEntry => text().nullable()();
}
