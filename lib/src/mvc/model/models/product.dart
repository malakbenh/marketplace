import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../tools.dart';
import '../../controller/services.dart';
import '../models.dart';

class Product extends FirebaseModel {
  String? title;
  String? description;
  String? productImage;
  double? originalPrice;
  double? discountPrice;
  String? category;
  bool? onSale;
  String? uid;

  Product({
    super.id,
    this.title,
    this.description,
    this.productImage,
    this.originalPrice,
    this.discountPrice,
    this.category,
    this.onSale,
    this.uid,
    super.createdAt,
    super.updatedAt,
    super.reference,
  });

  factory Product.init({
    required UserSession userSession,
    required String title,
    required String description,
    required String imagePath,
    required double originalPrice,
    required double discountPrice,
    required String category,
    required bool onSale,
  }) {
    DocumentReference reference = ProductsService().docReference;
    return Product(
      id: reference.id,
      title: title,
      description: description,
      productImage: imagePath,
      originalPrice: originalPrice,
      discountPrice: discountPrice,
      category: category,
      onSale: onSale,
      uid: userSession.uid,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      reference: reference,
    );
  }

  factory Product.fromDocumentSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) =>
      Product(
        id: doc.id,
        title: doc.data()!['title'],
        description: doc.data()!['description'],
        productImage: doc.data()!['imagePath'],
        originalPrice: doc.data()!['price'],
        category: doc.data()!['category'],
        onSale: doc.data()!['onSale'],
        uid: doc.data()!['uid'],
        createdAt:
            DateTimeUtils.getDateTimefromTimestamp(doc.data()!['createdAt'])!,
        updatedAt:
            DateTimeUtils.getDateTimefromTimestamp(doc.data()!['updatedAt'])!,
        reference: doc.reference,
      );

  @override
  Map<String, dynamic> get toMapCreate => {
        'id': id,
        'title': title,
        'description': description,
        'imagePath': productImage,
        'originalPrice': originalPrice,
        'discountPrice': discountPrice,
        'category': category,
        'onSale': onSale,
        'uid': uid,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

  @override
  Map<String, dynamic> get toMapUpdate => {
        'title': title,
        'description': description,
        'imagePath': productImage,
        'originalPrice': originalPrice,
        'discountPrice': discountPrice,
        'category': category,
        'onSale': onSale,
        'updatedAt': FieldValue.serverTimestamp(),
      };

  @override
  Future<void> update() async {
    await ProductsService().update(this);
    notifyListeners();
  }

  @override
  Future<void> create() async {
    await ProductsService().create(this);
  }

  @override
  Future<void> delete() async {
    await ProductsService().delete(this);
  }

  String get displayTitle => '$title';
}
