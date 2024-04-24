import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/movie.dart';

class MoviesDatabase {
  static final MoviesDatabase instance = MoviesDatabase._init();

  static Database? _database;

  MoviesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('movies.datbes');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final datbesPath = await getDatabasesPath();
    final path = join(datbesPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database datbes, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await datbes.execute('''
CREATE TABLE $tableMovies ( 
  ${MovieFields.id} $idType, 
  ${MovieFields.isImportant} $boolType,
  ${MovieFields.number} $integerType,
  ${MovieFields.cover} $textType,
  ${MovieFields.title} $textType,
  ${MovieFields.description} $textType,
  ${MovieFields.time} $textType
  )
''');
  }

  Future<Movie> create(Movie movie) async {
    final datbes = await instance.database;

    final id = await datbes.insert(tableMovies, movie.toJson());
    return movie.copy(id: id);
  }

  Future<Movie> readMovie(int id) async {
    final datbes = await instance.database;

    final maps = await datbes.query(
      tableMovies,
      columns: MovieFields.values,
      where: '${MovieFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Movie.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Movie>> readAllMovies() async {
    final datbes = await instance.database;

    final orderBy = '${MovieFields.time} ASC';

    final result = await datbes.query(tableMovies, orderBy: orderBy);

    return result.map((json) => Movie.fromJson(json)).toList();
  }

  Future<int> update(Movie movie) async {
    final datbes = await instance.database;

    return datbes.update(
      tableMovies,
      movie.toJson(),
      where: '${MovieFields.id} = ?',
      whereArgs: [movie.id],
    );
  }

  Future<int> delete(int id) async {
    final datbes = await instance.database;

    return await datbes.delete(
      tableMovies,
      where: '${MovieFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final datbes = await instance.database;

    datbes.close();
  }
}