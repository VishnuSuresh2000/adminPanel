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
import 'package:velocity_x/velocity_x.dart';

class AddOrUpdateProduct extends StatelessWidget {
  AddOrUpdateProduct({
    Key key,
    @required this.product,
    this.addOrUpdate,
  }) : super(key: key);
  final _form = GlobalKey<FormState>();

  final Product product;
  final bool addOrUpdate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AlertDialog(
          content: ChangeNotifierProvider(
            create: (context) => StateHandlerForProduct(),
            builder: (context, child) => formForProduct(product, context),
          ),
        ),
      ),
    );
  }

  formForProduct(Product product, BuildContext context) {
    return Form(
        key: _form,
        child:
            Consumer<StateHandlerForProduct>(builder: (context, value, child) {
          if (value == null ||
              (value.listCategory == null && value.error == null)) {
            return beruLoadingBar();
          } else if (value.error != null) {
            return Text("Error ${value.error}");
          } else if (value.listCategory == null) {
            return beruLoadingBar();
          } else if (value.listCategory != null) {
            if (product.inKg == null) {
              product.inKg = value.inKg;
            } else {
              value.inKg = product.inKg;
            }
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DropdownButtonFormField(
                      value: !addOrUpdate
                          ? Provider.of<StateHandlerForProduct>(context)
                              .listCategory
                              .singleWhere((element) =>
                                  element.name == product.category.name)
                          : null,
                      hint: Text("Select Category"),
                      onSaved: (newValue) => product.category = newValue,
                      items: Provider.of<StateHandlerForProduct>(context)
                          .listCategory
                          .map(
                            (e) => DropdownMenuItem(
                              child: Text("${e.name.firstLetterUpperCase()}"),
                              value: e,
                            ),
                          )
                          .toList(),
                      onChanged: (value) => product.category = value),
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
                    decoration:
                        InputDecoration(hintText: "Enter Product Amount"),
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
                    decoration:
                        InputDecoration(hintText: "Enter Product Discription"),
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
                  Consumer<StateHandlerForProduct>(
                    builder: (context, value, child) {
                      return CheckboxListTile(
                          title: Text(
                              "Select the Scale ${value.inKg ? 'inKg' : 'inPiece'}"),
                          value: value.inKg,
                          onChanged: (valu) {
                            product.inKg = valu;
                            value.inKg = valu;
                          });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RaisedButton(
                        onPressed: () async {
                          if (_form.currentState.validate()) {
                            _form.currentState.save();
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
                                  cakllback: () => context.nav
                                      .pushNamedAndRemoveUntil(
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
          return Container();
        }));
  }
}

class StateHandlerForProduct extends ChangeNotifier {
  List<BeruCategory> listCategory;
  Exception error;
  bool _inKg = true;

  bool get inKg => _inKg;

  set inKg(bool inKg) {
    _inKg = inKg;
    notifyListeners();
  }

  StateHandlerForProduct() {
    try {
      ServerCalls.serverGet(Sections.category).then((value) {
        listCategory = value.map((e) => BeruCategory.fromMap(e)).toList();
        print(listCategory[0].toMap());
        notifyListeners();
      }, onError: (e) {
        error = e;
        notifyListeners();
      });
    } catch (e) {
      print("error from con $e");
    }
  }
}
