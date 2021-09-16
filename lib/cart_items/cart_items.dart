import 'package:ecommerce_app/scoped_model/model_products.dart';
import 'package:scoped_model/scoped_model.dart';



class CartModel extends Model {

  List<ProductModel> cart = [];
  List<ProductModel> get carts => cart;
  ProductModel _productModel = new ProductModel();
  double totalCartValue,totalAmt;
  int totalItem = 0;
  String del = '0';
  double taxVAl;
  int counter = 0;
  List cartMeal = [];
  int get count => counter;
  int get total => cart.length;
  double get totalVal => totalCartValue;
  double get tax => taxVAl;
  int get itemQuantity => totalItem;
  String get delCh =>  _productModel.id.toString();
  double get payAmnt => totalAmt;
  List get selectedMeal => cartMeal;

  void allItems(){
    cartMeal = [
      for (var value in cart.toSet().toList()) {
        "itemId": value.id,
        "name":value.title,
        "quantity":value.description,
        "price": value.price,
      }
    ];
  }
  void addProduct(product) {
    int index = cart.indexWhere((i) => i.id == product.id);
    if (index != -1) {
      updateProduct(product, product.qty);
    }else {
      counter++;
      cart.add(product);
      calculateTotal();
      allItems();
      notifyListeners();
    }
  }

  removeProduct(product) {
    int index = cart.indexWhere((i) => i.id == product.id);
    counter--;
    //cart[index].quantity = 1;
    cart.removeWhere((item) => item.id == product.id);
    calculateTotal();
    notifyListeners();
  }

  void updateProduct(product, qty) {
    int index = cart.indexWhere((i) => i.id == product.id);
    //cart[index].quantity = qty;
   /* if (cart[index].quantity == 0)
      removeProduct(product);
   */ totalAmt = 0;
    index.compareTo(0);
    calculateTotal();
    allItems();
    notifyListeners();
  }
  void clearCart() {
   // cart.forEach((f) => f.quantity = 1);
    cart = [];
    cartMeal = [];
    counter = 0;
    notifyListeners();
  }

  void calculateTotal() {
    totalCartValue = 0;
    totalItem = 0;
    taxVAl = 0;
    cart.forEach((f) {
    //  totalCartValue = totalCartValue + (f.sellingPrice * f.quantity);
      totalItem = (totalItem + f.price) as int;
     // taxVAl  = taxVAl +  (double.parse(f.tax) * f.quantity);
    });
  }
}