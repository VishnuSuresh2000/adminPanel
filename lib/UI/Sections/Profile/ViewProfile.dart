import 'package:beru_admin/DataStructure/Sections.dart';
import 'package:beru_admin/Schema/user.dart';
import 'package:beru_admin/Server/ServerCalls.dart';
import 'package:beru_admin/UI/CommonFunctions/BeruAlertWithCallBack.dart';
import 'package:beru_admin/UI/CommonFunctions/BeruLodingBar.dart';
import 'package:beru_admin/UI/CommonFunctions/ErrorAlert.dart';
import 'package:beru_admin/UI/Home/AdminHome.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ViewProfile extends StatelessWidget {
  final User user;
  final Sections section;
  const ViewProfile({Key key, this.user, this.section}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: user.fullName.text
          .color(!user.isVerified ? Vx.red800 : Vx.green800)
          .make(),
      children: [
        ListTile(
          title: "PhoneNumber : ${user.phoneNumber}".text.make(),
        ),
        ListTile(
          title: "Email : ${user.email}".text.make(),
        ),
        ListTile(
          title: user.address != null
              ? Wrap(
                  direction: context.isMobile ? Axis.vertical : Axis.horizontal,
                  alignment: WrapAlignment.spaceAround,
                  children: [
                    "Address : ".text.bold.make(),
                    10.heightBox,
                    "${user.address.houseName} ,".text.make(),
                    10.heightBox,
                    "${user.address.locality} ,".text.make(),
                    10.heightBox,
                    "${user.address.district} ,".text.make(),
                    10.heightBox,
                    "${user.address.state} ,".text.make(),
                    10.heightBox,
                    "${user.address.pinCode} ,".text.make(),
                    10.heightBox,
                    "${user.address.alternateNumber ?? 'Not added'}"
                        .text
                        .make(),
                  ],
                )
              : "User is Not added Address".text.make(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            RaisedButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) => beruLoadingBar(),
                );
                try {
                  var value = await ServerCalls.serverVerifie(
                      section, user.id, !user.isVerified);
                  context.pop();
                  alertWithCallBack(
                      context: context,
                      content: value.toString(),
                      cakllback: () => context.nav.pushNamedAndRemoveUntil(
                          AdminHome.route, (route) => false));
                } catch (e) {
                  context.pop();
                  print("Error form Verifie ${e.toString()}");
                  errorAlert(context, e.toString());
                }
              },
              child: "${user.isVerified ? 'Unverifie' : 'Verifie'}"
                  .text
                  .color(user.isVerified ? Vx.red800 : Vx.green800)
                  .make(),
            )
          ],
        )
      ],
    );
  }
}
