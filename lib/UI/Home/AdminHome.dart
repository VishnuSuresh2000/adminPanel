import 'package:beru_admin/DataStructure/Sections.dart';
import 'package:beru_admin/Schema/BeruCategory.dart';
import 'package:beru_admin/Schema/Product.dart';
import 'package:beru_admin/Schema/user.dart';
import 'package:beru_admin/Server/ServerCalls.dart';
import 'package:beru_admin/UI/CommonFunctions/BeruLodingBar.dart';
import 'package:beru_admin/UI/Home/BLoCForHome.dart';
import 'package:beru_admin/UI/Home/BeruDrawer.dart';
import 'package:beru_admin/UI/Sections/Category/CategoryAddorUpdate.dart';
import 'package:beru_admin/UI/Sections/Category/CategoryView.dart';
import 'package:beru_admin/UI/Sections/Product/AddOrUpdateProduct.dart';
import 'package:beru_admin/UI/Sections/Product/ViewProduct.dart';
import 'package:beru_admin/UI/Sections/Profile/ViewProfile.dart';
import 'package:beru_admin/UI/Sections/Salles/showSalles.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class AdminHome extends StatefulWidget {
  static const String route = "/AdminHome";
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => BlocForHome(),
        builder: (context, child) {
          return Scaffold(
            floatingActionButton: showButton(context),
            drawer: BeruAdminPanelDrawer(),
            appBar: AppBar(
              title: Text(
                  "Beru Admin Panel On ${Provider.of<BlocForHome>(context).section.string.firstLetterUpperCase()}"),
            ),
            body: switchAndBuild(context),
          );
        });
  }

  Widget switchAndBuild(BuildContext context) {
    switch (Provider.of<BlocForHome>(context).section) {
      case Sections.category:
      case Sections.product:
      case Sections.seller:
      case Sections.salles:
        return Consumer<BlocForHome>(
          builder: (context, value, child) {
            return FutureBuilder(
              future: ServerCalls.serverGet(value.section),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return "No InterNet"
                        .text
                        .red400
                        .size(20)
                        .bold
                        .center
                        .make();
                    break;
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return beruLoadingBar();
                    break;
                  case ConnectionState.done:
                    if (!snapshot.hasError) {
                      return FractionallySizedBox(
                          widthFactor: context.isMobile ? 0.8 : 0.6,
                          child: ShowData(
                            data: snapshot.data,
                          )).centered();
                    } else {
                      print(
                          "Error from futher builder in home ${snapshot.error} ");
                      return "${snapshot.error.toString()}"
                          .text
                          .red700
                          .bold
                          .make()
                          .centered();
                    }
                    break;
                }
                return Container();
              },
            );
          },
        );
        break;
      default:
        return "ON Maintance".text.red400.bold.center.make().centered();
    }
  }

  Widget showButton(BuildContext context) {
    switch (Provider.of<BlocForHome>(context).section) {
      case Sections.category:
        return addButton(() {
          context.nav.push(MaterialPageRoute(
            builder: (context) => AddOrUpdateCategory(
              addOrUpadte: true,
              category: BeruCategory(),
            ),
          ));
        });
        break;
      case Sections.product:
        return addButton(() {
          context.nav.push(MaterialPageRoute(
            builder: (context) => AddOrUpdateProduct(
              product: Product(),
              addOrUpdate: true,
            ),
          ));
        });
      default:
        return Offstage();
    }
  }

  FloatingActionButton addButton(
    Function callback,
  ) {
    return FloatingActionButton(
      onPressed: callback,
      child: "Add".text.make(),
    );
  }
}

class ShowData extends StatelessWidget {
  final List data;

  const ShowData({Key key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    switch (Provider.of<BlocForHome>(context).section) {
      case Sections.category:
        return viewBuilder(data
            .map((e) => BeruCategory.fromMap(e))
            .toList()
            .map((ew) => BeruCategoryView(
                  category: ew,
                ).card.py4.make())
            .toList());
        break;
      case Sections.product:
        return viewBuilder(data
            .map((e) => Product.fromMap(e))
            .toList()
            .map((e) => ViewProduct(
                  product: e,
                ).card.py4.make())
            .toList());
      case Sections.farmer:
      case Sections.seller:
        return viewBuilder(data
            .map((e) => User.fromMap(e))
            .toList()
            .map((e) => ViewProfile(
                  user: e,
                  section: Provider.of<BlocForHome>(context).section,
                ).card.py4.make())
            .toList());
      case Sections.salles:
        return viewBuilder(data
            .map((e) => Product.fromMap(e))
            .toList()
            .map((e) => ShowSalles(
                  e: e,
                ).card.py4.make())
            .toList());
        break;
      default:
        return "ON Maintance".text.red400.bold.center.make().centered();
    }
  }

  ListView viewBuilder(List dataToView) {
    return ListView(
      children: dataToView,
      scrollDirection: Axis.vertical,
    );
  }
}
