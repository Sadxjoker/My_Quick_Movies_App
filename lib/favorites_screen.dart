import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickmovies/controllers/movie_id_controller.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({super.key});

  final MovieIdController controller = Get.find<MovieIdController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.deepOrange, size: 30)),
        centerTitle: true,
        title: Text('Favorites', style: Theme.of(context).textTheme.titleLarge),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey.shade500,
            height: 1.0,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.favoritesList.isEmpty) {
          return Center(
            child: Text(
              'No favorite Movie added.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.favoritesList.length,
          itemBuilder: (context, index) {
            final movie = controller.favoritesList[index];
            return ListTile(
              // ignore: unnecessary_null_comparison
              leading: movie.posterPath != null
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.movie, size: 40),
              title: Text(movie.title),
              subtitle: Text(movie.releaseDate),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  controller.removeFromFavorites(movie);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
