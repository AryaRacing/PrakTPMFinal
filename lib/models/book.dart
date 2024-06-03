class Book {
  final String id;
  final String thumbnail;
  final String title;
  final String authors;
  final String description;
  final double rating;
  final int pageCount;
  final String language;
  final String previewLink;
  final String accessViewStatus;

  Book({
    required this.id,
    required this.thumbnail,
    required this.title,
    required this.authors,
    required this.description,
    required this.rating,
    required this.pageCount,
    required this.language,
    required this.previewLink,
    required this.accessViewStatus,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      thumbnail: json['volumeInfo']['imageLinks'] != null
          ? json['volumeInfo']['imageLinks']['thumbnail']
          : 'https://via.placeholder.com/150',
      title: json['volumeInfo']['title'] ?? 'No title available',
      authors: json['volumeInfo']['authors'] != null
          ? (json['volumeInfo']['authors'] as List).join(', ')
          : 'No authors available',
      description:
          json['volumeInfo']['description'] ?? 'No description available',
      rating: json['volumeInfo']['averageRating'] != null
          ? json['volumeInfo']['averageRating'].toDouble()
          : 0.0,
      pageCount: json['volumeInfo']['pageCount'] ?? 0,
      language: json['volumeInfo']['language'] ?? 'N/A',
      previewLink: json['volumeInfo']['previewLink'] ?? '',
      accessViewStatus: json['accessInfo']['accessViewStatus'] ?? '',
    );
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      thumbnail: map['thumbnail'],
      title: map['title'],
      authors: map['authors'],
      description: map['description'],
      rating: map['rating'],
      pageCount: map['pageCount'],
      language: map['language'],
      previewLink: map['previewLink'],
      accessViewStatus: map['accessViewStatus'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'thumbnail': thumbnail,
      'title': title,
      'authors': authors,
      'description': description,
      'rating': rating,
      'pageCount': pageCount,
      'language': language,
      'previewLink': previewLink,
      'accessViewStatus': accessViewStatus,
    };
  }
}
