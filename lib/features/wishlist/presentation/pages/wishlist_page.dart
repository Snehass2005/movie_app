import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/core/constants/routes.dart';
import 'package:movie_app/features/wishlist/data/datasources/wishlist_local_datasource.dart';
import 'package:movie_app/features/wishlist/data/respositories/wishlist_respository_impl.dart';
import 'package:movie_app/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:movie_app/features/wishlist/presentation/cubit/wishlist_state.dart';
import 'package:movie_app/features/wishlist/domain/usecases/wishlist_usecases.dart';
import 'package:movie_app/shared/theme/app_colors.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final repository = WishlistRepositoryImpl(WishlistLocalDataSource());
        final usecase = WishlistUseCase(repository);
        return WishlistCubit(usecase, repository)..loadWishlist();
      },
      child: Scaffold(
        backgroundColor: AppColors.colorSecondary,
        appBar: AppBar(
          title: const Text('My Wishlist'),
          backgroundColor: AppColors.colorSecondary,
          elevation: 2,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop(); // ✅ pop if stack exists
              } else {
                context.go(RoutesName.defaultPath); // ✅ fallback to home
              }
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<WishlistCubit, WishlistState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.items.isEmpty) {
                return const Center(
                  child: Text(
                    'No movies in wishlist',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                );
              }
              return ListView.separated(
                itemCount: state.items.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: item.poster != 'N/A'
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.poster,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                      )
                          : const Icon(Icons.movie, size: 40),
                      title: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        context.push('${RoutesName.movieDetail}/${item.imdbID}'); // ✅ push instead of go
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}