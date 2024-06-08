import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/firebase_firestore_path.dart';
import '../../model/list_models.dart';
import '../../model/models.dart';
import '../services.dart';

class ProductsService extends FirestoreService<Product> {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  DocumentReference get docReference =>
      _firestore.collection(FirebaseFirestorePath.products()).doc();

  @override
  Future<void> update(Product element) async {
    await element.reference?.update(element.toMapUpdate);
  }

  @override
  Future<void> create(Product element) async {
    await element.reference?.set(element.toMapCreate);
  }

  @override
  Future<void> delete(Product element) async {
    await element.reference?.delete();
  }

  //addProductsByCategory
  Future<void> addProductsByCategory(Product product, String category) async {
    product.category = category;
    await create(product);
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection(FirebaseFirestorePath.products())
        .where('category', isEqualTo: category)
        .get();
    return querySnapshot.docs
        .map((doc) => Product.fromDocumentSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
  }

  Future<List<Product>> getSaleProductsByCategory(String category) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection(FirebaseFirestorePath.products())
        .where('category', isEqualTo: category)
        .where('onSale', isEqualTo: true)
        .get();
    return querySnapshot.docs
        .map((doc) => Product.fromDocumentSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
  }

  @override
  Future<void> getList({
    required ListFirestoreClasses<Product> list,
    required int limit,
    required bool refresh,
  }) async {
    Query query = _firestore
        .collection(FirebaseFirestorePath.products())
        //.where('uid', isEqualTo: list.uid)
        .orderBy('title', descending: true)
        .limit(limit);
    if (!refresh && list.lastDoc != null) {
      query = query.startAfterDocument(list.lastDoc!);
    }
    QuerySnapshot resultquery = await query.get();
    List<Product> result = [];
    result.addAll(resultquery.docs
        .map(
          (doc) => Product.fromDocumentSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>),
        )
        .toList());
    list.updateList(
      result,
      resultquery.docs.length == limit,
      resultquery.docs.isEmpty ? null : resultquery.docs.last,
      refresh,
    );
  }

  static Future<void> addProduct(Product product) {
    var productsCollection = getProductsCOllection();
    var doc = productsCollection.doc(); //create new doc
    product.id = doc.id;
    product.createdAt = DateTime.now();
    product.uid = FirebaseAuth.instance.currentUser!.uid;
    return doc.set(product); // get doc -> then set //update
  }

  static CollectionReference<Product> getProductsCOllection() {
    return FirebaseFirestore.instance
        .collection('products')
        .withConverter<Product>(fromFirestore: (snapshot, options) {
      return Product.fromDocumentSnapshot(snapshot);
    }, toFirestore: (product, options) {
      return product.toMapUpdate;
    });
  }
}
