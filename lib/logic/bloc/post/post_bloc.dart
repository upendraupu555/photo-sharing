import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/post.dart';
import '../../../data/repositories/post_repository.dart';

// Events
abstract class PostEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddPost extends PostEvent {
  final Post post;
  AddPost(this.post);
}

class LoadPosts extends PostEvent {}

// States
abstract class PostState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<Post> posts;
  PostLoaded(this.posts);
}

class PostError extends PostState {}

// Bloc
class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;

  PostBloc({required this.postRepository}) : super(PostInitial()) {
    on<LoadPosts>((event, emit) {
      emit(PostLoading());
      final posts = postRepository.getAllPosts();
      emit(PostLoaded(posts));
    });

    on<AddPost>((event, emit) {
      postRepository.addPost(event.post);
      add(LoadPosts()); // Reload posts after adding
    });
  }
}
