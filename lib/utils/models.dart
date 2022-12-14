import 'package:instagramexample/utils/storage_service.dart';
import 'package:timeago/timeago.dart' as timeago;

final Storage storage = Storage();

const placeholderStories = <Story>[Story()];

const nickwu241 =
    User(name: 'nickwu241', imageUrl: 'assets/images/nickwu241.jpg');
const grootlover = User(
    name: 'ilikeredbananas',
    imageUrl: 'assets/images/grootlover.jpg',
    stories: placeholderStories);
const starlord = User(
    name: 'starlord',
    imageUrl: 'assets/images/starlord.jpg',
    stories: placeholderStories);
const gamora = User(
    name: 'gamora',
    imageUrl: 'assets/images/gamora.jpg',
    stories: placeholderStories);
const rocket = User(
    name: 'rocket',
    imageUrl: 'assets/images/rocket.jpg',
    stories: placeholderStories);
const nebula = User(
    name: 'nebula',
    imageUrl: 'assets/images/nebula.jpg',
    stories: placeholderStories);

var currentUser = rocket;

var setCurrentUser = (User user) => {currentUser = user};

class Post {
  final String id;
  List<String> imageUrls;
  final User user;
  final DateTime postedAt;

  String location;

  String timeAgo() {
    final now = DateTime.now();
    return timeago.format(now.subtract(now.difference(postedAt)));
  }

  Future<bool> isLikedBy(String id, User user) async {
    var status = await storage.checkIsLikedBy(id, user);
    return status;
  }

  Future<bool> addLikeIfUnlikedFor(String id, User user) async {
    var status = await storage.addLike(id, user);
    return status;
  }

  Future<bool> toggleLikeFor(String id, User user) async {
    final status;
    if (await isLikedBy(id, user)) {
      status = await storage.removeLike(id, user);
    } else {
      status = await addLikeIfUnlikedFor(id, user);
    }
    return status;
  }

  Post({
    required this.id,
    required this.imageUrls,
    required this.user,
    required this.postedAt,
    required this.location,
  });
}

class User {
  final String name;

  final String imageUrl;
  final String networkImageUrl;
  final List<Story> stories;

  const User(
      {required this.name,
      this.imageUrl = '',
      this.networkImageUrl = '',
      this.stories = const <Story>[]});
}

class Comment {
  final String docRefId;
  String text;
  final User user;
  final DateTime commentedAt;
  List<Like> likes;

  bool isLikedBy(User user) {
    return likes.any((like) => like.user.name == user.name);
  }

  Future<bool> toggleLikeFor(User user) async {
    final status;
    if (await isLikedBy(user)) {
      status = await storage.removeCommentLike(user, this);
    } else {
      status = await storage.addCommentLike(user, this);
    }
    return status;
  }

  Comment({
    required this.docRefId,
    required this.text,
    required this.user,
    required this.commentedAt,
    required this.likes,
  });
}

class Like {
  final String id;
  final User user;

  Like({required this.id, required this.user});
}

class Story {
  const Story();
}
