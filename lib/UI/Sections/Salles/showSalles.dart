import 'package:beru_admin/Schema/Product.dart';
import 'package:beru_admin/Schema/Salles.dart';
import 'package:beru_admin/Server/ServerCalls.dart';
import 'package:beru_admin/UI/CommonFunctions/BeruAlertWithCallBack.dart';
import 'package:beru_admin/UI/CommonFunctions/BeruLodingBar.dart';
import 'package:beru_admin/UI/CommonFunctions/ErrorAlert.dart';
import 'package:beru_admin/UI/Home/AdminHome.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ShowSalles extends StatelessWidget {
  final Product e;
  const ShowSalles({Key key, this.e}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: e.name.firstLetterUpperCase().text.make(),
      children: [
        ListTile(
          title: Wrap(
            direction: context.isMobile ? Axis.vertical : Axis.horizontal,
            alignment: WrapAlignment.spaceAround,
            children: [
              "Amount : ${e.amount}".text.make(),
              "Category : ${e.category.name?.firstLetterUpperCase()}"
                  .text
                  .make(),
            ],
          ),
        ),
        ...e.salles
            .map((ef) => ListTile(
                  title: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction:
                        context.isMobile ? Axis.vertical : Axis.horizontal,
                    alignment: WrapAlignment.spaceAround,
                    children: [
                      "Count : ${ef.count} ${e.inKg ? 'Kg' : 'Pices'}"
                          .text
                          .make(),
                      "Seller : ${ef.seller.fullName}".text.make(),
                      "Farmer : ${ef.farmer.fullName}".text.make(),
                      RaisedButton(
                        onPressed: () => changeShow(context, ef),
                        child: "Show : ${ef.toShow ? 'Yes' : 'No'}".text.make(),
                      )
                    ],
                  ),
                ))
            .toList()
      ],
    );
  }

  void changeShow(BuildContext context, Salles ef) async {
    showDialog(
      context: context,
      builder: (context) => beruLoadingBar(),
    );
    try {
      var data = await ServerCalls.serverSallesToShow(ef.id, ef.toShow);
      context.pop();
      alertWithCallBack(
          context: context,
          cakllback: () => context.nav.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => AdminHome(),
              ),
              (route) => false),
          callBackName: "Home",
          content: data.toString());
    } on Exception catch (e) {
      print("error from ToShow Update $e ");
      context.pop();
      errorAlert(context, e.toString());
    }
  }
}
