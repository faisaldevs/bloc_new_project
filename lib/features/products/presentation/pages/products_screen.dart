import 'package:bloc_arch_setup/core/di/di.dart';
import 'package:bloc_arch_setup/features/products/presentation/bloc/products_bloc.dart';
import 'package:bloc_arch_setup/features/products/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductsBloc>()..add(GetProductStarted()),
      child: ProductsScreenView(),
    );
  }
}

class ProductsScreenView extends StatefulWidget {
  const ProductsScreenView({super.key});

  @override
  State<ProductsScreenView> createState() => _ProductsScreenViewState();
}

class _ProductsScreenViewState extends State<ProductsScreenView> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    final position = scrollController.position;
    if (position.pixels >= position.maxScrollExtent * 0.9) {
      context.read<ProductsBloc>().add(MoreProductLoded());
    }
  }

  // If the loaded items don't fill the viewport there is nothing to scroll,
  // so the listener never fires. Check after layout and load more if needed.
  void _fillViewportIfNeeded() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _onScroll();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products"), centerTitle: true),
      body: BlocConsumer<ProductsBloc, ProductsState>(
        listenWhen: (previous, current) =>
            current.status == ProductStatus.success && !current.hasReachedMax,
        listener: (context, state) => _fillViewportIfNeeded(),
        builder: (context, state) {
          switch (state.status) {
            case ProductStatus.initial:
            case ProductStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case ProductStatus.failure:
              return _ErrorView(
                message: state.errorMessage ?? "Unknown Error",
                onRetry: () =>
                    context.read<ProductsBloc>().add(GetProductStarted()),
              );
            default:
              break;
          }

          final products = state.productData;
          if (products.isEmpty) {
            return const Center(child: Text("No products found"));
          }

          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.62,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(product: products[index]);
                  },
                ),
              ),

              state.status == ProductStatus.loadMore
                  ? CircularProgressIndicator()
                  : SizedBox(),
              state.status == ProductStatus.loadMoreFailure
                  ? Text(state.errorMessage ?? "")
                  : SizedBox(),
            ],
          );
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
