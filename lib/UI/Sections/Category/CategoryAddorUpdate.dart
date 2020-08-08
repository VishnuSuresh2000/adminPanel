import 'package:beru_admin/DataStructure/Sections.dart';
import 'package:beru_admin/Schema/BeruCategory.dart';
import 'package:beru_admin/Server/ServerCalls.dart';
import 'package:beru_admin/UI/CommonFunctions/BeruAlertWithCallBack.dart';
import 'package:beru_admin/UI/CommonFunctions/BeruLodingBar.dart';
import 'package:beru_admin/UI/CommonFunctions/ErrorAlert.dart';
import 'package:beru_admin/UI/Home/AdminHome.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class AddOrUpdateCategory extends StatelessWidget {
  final _form = GlobalKey<FormState>();
  final BeruCategory category;
  final bool addOrUpadte;

  AddOrUpdateCategory({Key key, this.category, this.addOrUpadte})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FractionallySizedBox(
          heightFactor: 0.5,
          child: AlertDialog(
            content: Form(
                key: _form,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(hintText: "Enter Categoty"),
                      initialValue: category.name ?? null,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Need to Enter Name of Category";
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        category.name = value;
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
                                String res = addOrUpadte
                                    ? await ServerCalls.serverCreate(
                                        category.toMapCreate(), Sections.category)
                                    : await ServerCalls.serverUpdate(
                                        category.toMapCreate(),
                                        category.id,
                                        Sections.category);
                                Navigator.of(context).pop();
                                alertWithCallBack(
                                    context: context,
                                    content: "$res",
                                    callBackName: "Home",
                                    cakllback: () {
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              AdminHome.route, (route) => false);
                                    });
                              } catch (e) {
                                print("Error form Submit Button $e");
                                errorAlert(context, e.toString());
                              }
                            }
                          },
                          child: Text("${addOrUpadte ? 'Create' : 'Update'}"),
                        ),
                        RaisedButton(
                          onPressed: () => context.pop(),
                          child: Text("Cancel"),
                        )
                      ],
                    ).centered()
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
