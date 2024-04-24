final String tableMovies = 'movies';

class MovieFields {
  static final List<String> values = [
    /// Add all fields
    id, isImportant, number, cover, title, description, time
  ];

  static final String id = '_id';
  static final String isImportant = 'isImportant';
  static final String number = 'number';
  static final String title = 'title';
  static final String cover = 'cover';
  static final String description = 'description';
  static final String time = 'time';
}

class Movie {
  final int? id;
  final bool isImportant;
  final int number;
  final String cover;
  final String title;
  final String description;
  final DateTime createdTime;

  const Movie({
    this.id,
    required this.isImportant,
    required this.number,
    required this.cover,
    required this.title,
    required this.description,
    required this.createdTime,
  });

  Movie copy({
    int? id,
    bool? isImportant,
    int? number,
    String? cover,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      Movie(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
        cover: cover ?? this.cover,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
      );

  static Movie fromJson(Map<String, Object?> json) => Movie(
    id: json[MovieFields.id] as int?,
    isImportant: json[MovieFields.isImportant] == 1,
    number: json[MovieFields.number] as int,
    cover: json[MovieFields.cover] as String,
    title: json[MovieFields.title] as String,
    description: json[MovieFields.description] as String,
    createdTime: DateTime.parse(json[MovieFields.time] as String),
  );

  Map<String, Object?> toJson() => {
    MovieFields.id: id,
    MovieFields.cover: cover,
    MovieFields.title: title,
    MovieFields.isImportant: isImportant ? 1 : 0,
    MovieFields.number: number,
    MovieFields.description: description,
    MovieFields.time: createdTime.toIso8601String(),
  };
}