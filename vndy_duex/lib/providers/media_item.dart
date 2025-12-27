enum MediaType { image, video, gif }

class MediaItem {
  final String url;
  final MediaType type;
  final String? thumbUrl;

  MediaItem({
    required this.url,
    required this.type,
    this.thumbUrl,
  });

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    final typeString = json['type'] ?? 'image';

    // return MediaItem(
    //   url: json['url'] ?? '',
    //   type: MediaType.values.firstWhere(
    //         (t) => t.name == typeString,
    //     orElse: () => MediaType.image,
    //   ),
    // );
    return MediaItem(
      url: json['url'],
      type: json['type'] == 'video' ? MediaType.video : MediaType.image,
      thumbUrl: json['thumbUrl'],
    );

  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'type': type.name,
      if (thumbUrl != null) 'thumbUrl': thumbUrl,
    };
  }
}
