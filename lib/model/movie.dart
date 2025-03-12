import 'dart:convert';

List<Movie> moviesFromJson(String str) =>
    List<Movie>.from(json.decode(str).map((x) => Movie.fromJson(x)));

String moviesToJson(List<Movie> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Movie {
  final int id;
  final String title;
  final int year;
  final List<String> genre;
  final double rating;
  final String director;
  final List<String> actors;
  final String plot;
  final String poster;
  final String trailer;
  final int runtime;
  final String awards;
  final String country;
  final String language;
  final String boxOffice;
  final String production;
  final String website;

  Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.genre,
    required this.rating,
    required this.director,
    required this.actors,
    required this.plot,
    required this.poster,
    required this.trailer,
    required this.runtime,
    required this.awards,
    required this.country,
    required this.language,
    required this.boxOffice,
    required this.production,
    required this.website,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json["id"],
        title: json["title"],
        year: json["year"],
        genre: List<String>.from(json["genre"].map((x) => x)),
        rating: json["rating"]?.toDouble(),
        director: json["director"],
        actors: List<String>.from(json["actors"].map((x) => x)),
        plot: json["plot"],
        poster: json["poster"],
        trailer: json["trailer"],
        runtime: json["runtime"],
        awards: json["awards"],
        country: json["country"],
        language: json["language"],
        boxOffice: json["boxOffice"],
        production: json["production"],
        website: json["website"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "year": year,
        "genre": List<dynamic>.from(genre.map((x) => x)),
        "rating": rating,
        "director": director,
        "actors": List<dynamic>.from(actors.map((x) => x)),
        "plot": plot,
        "poster": poster,
        "trailer": trailer,
        "runtime": runtime,
        "awards": awards,
        "country": country,
        "language": language,
        "boxOffice": boxOffice,
        "production": production,
        "website": website,
      };
}
