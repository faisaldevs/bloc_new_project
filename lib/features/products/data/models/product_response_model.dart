import 'dart:convert';

import 'package:bloc_arch_setup/features/products/domain/entities/paginated_products.dart';
import 'package:bloc_arch_setup/features/products/domain/entities/product.dart';

class ProductResponseModel {
  final List<Product>? products;
  final int? total;
  final int? skip;
  final int? limit;

  ProductResponseModel({this.products, this.total, this.skip, this.limit});

  ProductResponseModel copyWith({
    List<Product>? products,
    int? total,
    int? skip,
    int? limit,
  }) => ProductResponseModel(
    products: products ?? this.products,
    total: total ?? this.total,
    skip: skip ?? this.skip,
    limit: limit ?? this.limit,
  );

  factory ProductResponseModel.fromRawJson(String str) =>
      ProductResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) =>
      ProductResponseModel(
        products: json["products"] == null
            ? []
            : List<Product>.from(
                json["products"]!.map((x) => Product.fromJson(x)),
              ),
        total: json["total"],
        skip: json["skip"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
    "products": products == null
        ? []
        : List<dynamic>.from(products!.map((x) => x.toJson())),
    "total": total,
    "skip": skip,
    "limit": limit,
  };

  PaginatedProducts toEntity() => PaginatedProducts(
    total: total ?? 0,
    skip: skip ?? 0,
    limit: limit ?? 0,
    products: products?.map((x) => x.toEntity()).toList() ?? [],
  );
}

class Product {
  final int id;
  final String? title;
  final String? description;
  final String? category;
  final double? price;
  final double? discountPercentage;
  final double? rating;
  final int? stock;
  final String? brand;
  final String? sku;
  final int? weight;
  final String? warrantyInformation;
  final String? shippingInformation;
  final String? availabilityStatus;
  final String? returnPolicy;
  final int? minimumOrderQuantity;
  final List<String>? images;
  final String? thumbnail;

  Product({
    required this.id,
    this.title,
    this.description,
    this.category,
    this.price,
    this.discountPercentage,
    this.rating,
    this.stock,

    this.brand,
    this.sku,
    this.weight,
    this.warrantyInformation,
    this.shippingInformation,
    this.availabilityStatus,

    this.returnPolicy,
    this.minimumOrderQuantity,

    this.images,
    this.thumbnail,
  });

  Product copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    double? price,
    double? discountPercentage,
    double? rating,
    int? stock,
    List<String>? tags,
    String? brand,
    String? sku,
    int? weight,

    String? warrantyInformation,
    String? shippingInformation,
    String? availabilityStatus,

    String? returnPolicy,
    int? minimumOrderQuantity,

    List<String>? images,
    String? thumbnail,
  }) => Product(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    category: category ?? this.category,
    price: price ?? this.price,
    discountPercentage: discountPercentage ?? this.discountPercentage,
    rating: rating ?? this.rating,
    stock: stock ?? this.stock,

    brand: brand ?? this.brand,
    sku: sku ?? this.sku,
    weight: weight ?? this.weight,
    warrantyInformation: warrantyInformation ?? this.warrantyInformation,
    shippingInformation: shippingInformation ?? this.shippingInformation,
    availabilityStatus: availabilityStatus ?? this.availabilityStatus,

    returnPolicy: returnPolicy ?? this.returnPolicy,
    minimumOrderQuantity: minimumOrderQuantity ?? this.minimumOrderQuantity,

    images: images ?? this.images,
    thumbnail: thumbnail ?? this.thumbnail,
  );

  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    category: json["category"],
    price: json["price"]?.toDouble(),
    discountPercentage: json["discountPercentage"]?.toDouble(),
    rating: json["rating"]?.toDouble(),
    stock: json["stock"],

    brand: json["brand"],
    sku: json["sku"],
    weight: json["weight"],

    warrantyInformation: json["warrantyInformation"],
    shippingInformation: json["shippingInformation"],
    availabilityStatus: json["availabilityStatus"],

    returnPolicy: json["returnPolicy"],
    minimumOrderQuantity: json["minimumOrderQuantity"],

    thumbnail: json["thumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "category": category,
    "price": price,
    "discountPercentage": discountPercentage,
    "rating": rating,
    "stock": stock,
    "brand": brand,
    "sku": sku,
    "weight": weight,
    "warrantyInformation": warrantyInformation,
    "shippingInformation": shippingInformation,
    "availabilityStatus": availabilityStatus,
    "returnPolicy": returnPolicy,
    "minimumOrderQuantity": minimumOrderQuantity,

    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "thumbnail": thumbnail,
  };

  ProductEntity toEntity() => ProductEntity(
    id: id ?? 0,
    title: title ?? '',
    description: description,
    category: category,
    price: price ?? 0,
    discountPercentage: discountPercentage,
    rating: rating,
    stock: stock,
    brand: brand,
    sku: sku,
    weight: weight,
    warrantyInformation: warrantyInformation,
    shippingInformation: shippingInformation,
    availabilityStatus: availabilityStatus,
    returnPolicy: returnPolicy,
    minimumOrderQuantity: minimumOrderQuantity,
    thumbnail: thumbnail,
    images: images,
  );
}
