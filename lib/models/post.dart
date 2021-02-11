class Post {
  String title;
  String text;
  String author;
  String textHtml;
  DateTime created;
  int pk;

  Post({
    this.pk,
    this.title,
    this.text,
    this.author,
    this.textHtml,
    this.created,
  });

  Post.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    text = json['text'];
    author = json['author'];
    textHtml = json['textHtml'];
    created = DateTime.parse(json['created']);
    pk = json['pk'];
  }
}
