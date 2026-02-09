import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:movie_app/core/constants/routes.dart';
import 'package:movie_app/core/dependency_injection/injector.dart';
import 'package:movie_app/features/wishlist/domain/usecases/wishlist_usecases.dart';
import 'package:movie_app/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:movie_app/features/wishlist/presentation/cubit/wishlist_state.dart';
import 'package:movie_app/shared/config/dimens.dart';
import 'package:movie_app/shared/theme/app_colors.dart';
import 'package:movie_app/shared/theme/text_styles.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  late final WishlistCubit _wishlistCubit;

  @override
  void initState() {
    super.initState();
    _wishlistCubit = WishlistCubit(injector<WishlistUseCases>());
    _wishlistCubit.loadWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _wishlistCubit,
      child: Scaffold(
        backgroundColor: AppColors.appBackGround,
        appBar: AppBar(
          title: const Text('My Wishlist'),
          backgroundColor: AppColors.colorSecondary,
          elevation: Dimens.elevation_2,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(RoutesName.defaultPath);
              }
            },
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Dimens.spacing_16),
            child: BlocConsumer<WishlistCubit, WishlistState>(
              listener: _listener,
              builder: _builder,
            ),
          ),
        ),
      ),
    );
  }

  void _listener(BuildContext context, WishlistState state) {
    if (state.isFailure && state.message.isNotEmpty) {
      // ✅ Inline SnackBar instead of CustomToast
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _wishlistCubit.resetError();
      log("WISHLIST ERROR → ${state.message}");
    }
  }

  Widget _builder(BuildContext context, WishlistState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.items.isEmpty) {
      return Center(
        child: Text(
          'No movies in wishlist',
          style: AppTextStyles.openSansRegular14
              .copyWith(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.separated(
      itemCount: state.items.length,
      separatorBuilder: (context, index) =>
      const SizedBox(height: Dimens.standard_12),
      itemBuilder: (context, index) {
        final item = state.items[index];
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.standard_12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(Dimens.standard_12),
            leading: item.poster != 'N/A'
                ? ClipRRect(
              borderRadius: BorderRadius.circular(Dimens.standard_8),
              child: Image.network(
                item.poster,
                width: 60,
                fit: BoxFit.cover,
              ),
            )
                : const Icon(Icons.movie, size: 40),
            title: Text(
              item.title,
              style: AppTextStyles.openSansBold16
                  .copyWith(color: AppColors.textPrimary),
            ),
            onTap: () {
              context.push('${RoutesName.movieDetail}/${item.imdbID}');
            },
          ),
        );
      },
    );
  }
}