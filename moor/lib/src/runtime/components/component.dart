import 'package:moor/moor.dart';

/// A component is anything that can appear in a sql query.
abstract class Component {
  /// Writes this component into the [context] by writing to its
  /// [GenerationContext.buffer] or by introducing bound variables. When writing
  /// into the buffer, no whitespace around the this component should be
  /// introduced. When a component consists of multiple composed component, it's
  /// responsible for introducing whitespace between its child components.
  void writeInto(GenerationContext context);
}

/// An enumeration of database systems supported by moor. Only
/// [SqlDialect.sqlite] is officially supported, all others are in an
/// experimental state at the moment.
enum SqlDialect { sqlite, mysql }

/// Contains information about a query while it's being constructed.
class GenerationContext {
  /// Whether the query obtained by this context operates on multiple tables.
  ///
  /// If it does, columns should prefix their table name to avoid ambiguous
  /// queries.
  bool hasMultipleTables = false;

  final SqlTypeSystem typeSystem;
  final SqlDialect dialect;
  final QueryExecutor executor;

  final List<dynamic> _boundVariables = [];

  /// The values of [introducedVariables] that will be sent to the underlying
  /// engine.
  List<dynamic> get boundVariables => _boundVariables;

  /// All variables ("?" in sql) that were added to this context.
  final List<Variable> introducedVariables = [];

  int get amountOfVariables => boundVariables.length;

  /// The string buffer contains the sql query as it's being constructed.
  final StringBuffer buffer = StringBuffer();

  /// Gets the generated sql statement
  String get sql => buffer.toString();

  GenerationContext.fromDb(QueryEngine database)
      : typeSystem = database.typeSystem,
        executor = database.executor,
        dialect = database.executor?.dialect ?? SqlDialect.sqlite;

  GenerationContext(this.typeSystem, this.executor,
      {this.dialect = SqlDialect.sqlite});

  /// Introduces a variable that will be sent to the database engine. Whenever
  /// this method is called, a question mark should be added to the [buffer] so
  /// that the prepared statement can be executed with the variable. The value
  /// must be a type that is supported by the sqflite library. A list of
  /// supported types can be found [here](https://github.com/tekartik/sqflite#supported-sqlite-types).
  void introduceVariable(Variable v, dynamic value) {
    introducedVariables.add(v);
    _boundVariables.add(value);
  }

  /// Shortcut to add a single space to the buffer because it's used very often.
  void writeWhitespace() => buffer.write(' ');
}
