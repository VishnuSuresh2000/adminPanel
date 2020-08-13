import 'package:beru_admin/DataStructure/Sections.dart';
import 'package:beru_admin/Schema/BeruCategory.dart';
import 'package:beru_admin/Schema/Product.dart';
import 'package:beru_admin/Server/ServerCalls.dart';
import 'package:beru_admin/UI/CommonFunctions/BeruAlertWithCallBack.dart';
import 'package:beru_admin/UI/CommonFunctions/BeruLodingBar.dart';
import 'package:beru_admin/UI/CommonFunctions/ErrorAlert.dart';
import 'package:beru_admin/UI/Home/AdminHome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:velocity_x/velocity_x.dart';

class AddOrUpdateProduct extends StatelessWidget {
  AddOrUpdateProduct({
    Key key,
    @required this.product,
    this.addOrUpdate,
  }) : super(key: key);

  final Product product;
  final bool addOrUpdate;
  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _form,
        child: Center(
          child: ChangeNotifierProvider(
            create: (context) {
              if (product.inKg == null) {
                product.inKg = true;
              }
              return StateHandlerForProduct(product.inKg);
            },
            child: Selector<StateHandlerForProduct,
                    Tuple2<List<BeruCategory>, Exception>>(
                builder: (context, value, child) {
                  if (value.item1 == null && value.item2 == null) {
                    return beruLoadingBar();
                  } else if (value.item2 != null) {
                    print("Error on handler ${value.item2.toString()}");
                    return value.item2
                        .toString()
                        .text
                        .red600
                        .bold
                        .make()
                        .centered();
                  } else {
                    return AlertDialog(
                      content: buildForm(context).wh(400, 400),
                    );
                  }
                },
                selector: (_, handler) =>
                    Tuple2(handler.listCategory, handler.error)),
          ),
        ),
      ),
    );
  }

  SingleChildScrollView buildForm(
    BuildContext context,
  ) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Selector<StateHandlerForProduct, List<BeruCategory>>(
            shouldRebuild: (_, d) => false,
            selector: (_, handler) => handler.listCategory,
            builder: (context, value, child) => DropdownButtonFormField(
                value: !addOrUpdate
                    ? value.singleWhere(
                        (element) => element.name == product.category.name)
                    : null,
                hint: Text("Select Category"),
                onSaved: (newValue) => product.category = newValue,
                items: value
                    .map(
                      (e) => DropdownMenuItem(
                        child: Text("${e.name.firstLetterUpperCase()}"),
                        value: e,
                      ),
                    )
                    .toList(),
                onChanged: (value) => product.category = value),
          ),
          TextFormField(
            initialValue: product.name ?? null,
            decoration: InputDecoration(hintText: "Enter Product Name"),
            validator: (value) {
              if (value.isEmpty) {
                return "Please EnterName";
              }
              return null;
            },
            onSaved: (value) {
              product.name = value;
            },
          ),
          TextFormField(
            initialValue: product.amount?.toString(),
            decoration: InputDecoration(hintText: "Enter Product Amount"),
            validator: (value) {
              if (value.isEmpty) {
                return "Please Enter Amount";
              } else if (value.isNotEmpty) {
                try {
                  int.parse(value);
                } catch (e) {
                  return "Must be Number";
                }
              }
              return null;
            },
            onSaved: (value) {
              product.amount = int.parse(value);
            },
          ),
          TextFormField(
            initialValue: product.description ?? null,
            decoration: InputDecoration(hintText: "Enter Product Discription"),
            validator: (value) {
              if (value.isEmpty) {
                return "Please Discription";
              }
              return null;
            },
            onSaved: (value) {
              product.description = value;
            },
          ),
          Selector<StateHandlerForProduct, Tuple2<bool, Function>>(
            shouldRebuild: (old, next) => old.item1 != next.item1,
            selector: (_, handler) => Tuple2(handler.inKg, handler.setInkg),
            builder: (context, value, child) => CheckboxListTile(
                title: Text(
                    "Select the Scale ${value.item1 ? 'inKg' : 'inPiece'}"),
                value: value.item1,
                onChanged: (valu) {
                  product.inKg = valu;
                  value.item2(valu);
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RaisedButton(
                onPressed: () async {
                  if (_form.currentState.validate()) {
                    _form.currentState.save();
                    print(product.toMap());
                    try {
                      showDialog(
                        context: context,
                        builder: (context) => beruLoadingBar(),
                      );
                      var res = addOrUpdate
                          ? await ServerCalls.serverCreate(
                              product.toMapCreate(), Sections.product)
                          : await ServerCalls.serverUpdate(
                              product.toMapCreate(),
                              product.id,
                              Sections.product);
                      context.pop();
                      alertWithCallBack(
                          cakllback: () => context.nav.pushNamedAndRemoveUntil(
                              AdminHome.route, (route) => false),
                          context: context,
                          callBackName: "Home",
                          content: res.toString());
                    } catch (e) {
                      print("Error from addOr update product $e");
                      errorAlert(context, e.toString());
                    }
                  }
                },
                child: Text("${addOrUpdate ? 'Create' : 'Update'}"),
              ),
              RaisedButton(
                onPressed: () => context.pop(),
                child: Text("Cancel"),
              )
            ],
          )
        ],
      ),
    );
  }
}

class StateHandlerForProduct extends ChangeNotifier {
  List<BeruCategory> listCategory;
  Exception error;
  bool _inKg = true;

  bool get inKg => _inKg;

  void setInkg(bool inKg) {
    _inKg = inKg;
    notifyListeners();
  }

  void loadData() async {
    try {
      var data = await ServerCalls.serverGet(Sections.category);
      listCategory = data.map((e) => BeruCategory.fromMap(e)).toList();
    } catch (e) {
      print("error from con $e");
      error = e;
    } finally {
      notifyListeners();
    }
  }

  StateHandlerForProduct(bool inkg) : this._inKg = inkg {
    loadData();
  }
}
