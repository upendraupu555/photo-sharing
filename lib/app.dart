import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_sharing_app/config/theme.dart';
import 'package:photo_sharing_app/data/repositories/local_auth_repository.dart';
import 'package:photo_sharing_app/data/repositories/post_repository.dart';
import 'package:photo_sharing_app/logic/bloc/auth/auth_bloc.dart';
import 'package:photo_sharing_app/logic/bloc/post/post_bloc.dart';
import 'package:photo_sharing_app/presentation/screens/new_post_screen.dart';
import 'presentation/screens/auth_screen.dart';
import 'presentation/screens/home_screen.dart';

class PhotoSharingApp extends StatelessWidget {
  const PhotoSharingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: LocalAuthRepository()),
        ),
        BlocProvider<PostBloc>(
          create: (context) =>
              PostBloc(postRepository: PostRepository())..add(LoadPosts()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Photo Sharing App',
        theme: appTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthScreen(),
          '/home': (context) => const HomeScreen(),
          '/new_post': (context) =>  NewPostScreen(),
        },
      )
    );
  }
}
