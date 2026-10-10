# Testing Progress

Tracks unit-test coverage priority. Check off when a file's test is written and passing.

## P0 — core business logic

- [x] `lib/features/products/data/repositories/product_repository_impl.dart`
      → `test/features/products/data/repositories/product_repository_impl_test.dart`
- [ ] `lib/features/products/presentation/bloc/products_bloc.dart`
      → `test/features/products/presentation/bloc/products_bloc_test.dart` (in progress)
- [ ] `lib/features/products/domain/entities/paginated_products.dart`

## P1 — data layer

- [ ] `lib/features/products/data/datasources/local/local_datasource_impl.dart`
- [ ] `lib/core/network/auth_interceptor.dart`
- [ ] `lib/core/storage/auth_storage.dart`

## P2 — thin / trivial

- [ ] `lib/features/products/domain/usecases/get_products.dart`
- [ ] `lib/core/database/convarters/string_list_converter.dart`

## Skipped (no logic / generated)

- `lib/features/products/data/datasources/remote/remote_datasource_impl.dart`
- `lib/core/network/dio_client.dart`
- `lib/core/di/di.dart`
- `lib/core/database/app_database.dart` (+ `.g.dart`)
- `lib/core/database/tables/product_table.dart`
- `lib/features/products/data/datasources/remote/products_api_service.dart` (+ `.g.dart`)
- `lib/features/products/presentation/pages/products_screen.dart` (widget test, separate track)
- `lib/features/products/presentation/widgets/product_card.dart` (widget test, separate track)
