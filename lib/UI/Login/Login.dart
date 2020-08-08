import 'package:beru_admin/Auth/AuthService.dart';
import 'package:beru_admin/Schema/Admin.dart';
import 'package:beru_admin/UI/CommonFunctions/BeruLodingBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BeruAdminLogin extends StatefulWidget {
  @override
  _BeruAdminLoginState createState() => _BeruAdminLoginState();
}

class _BeruAdminLoginState extends State<BeruAdminLogin> {
  final _form = GlobalKey<FormState>();
  final user = Admin();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 600,
          width: 600,
          child: CustomSingleChildLayout(
            delegate: ChildDelegate(),
            child: Container(
              child: FractionallySizedBox(
                  heightFactor: 0.8,
                  widthFactor: 0.8,
                  child: Center(
                      child: Card(
                    child: Form(
                      key: _form,
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: AutofillGroup(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Beru Admin Panel Login",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextFormField(
                                autofocus: true,
                                autofillHints: [AutofillHints.email],
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(hintText: "Email"),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return "Enter the Email";
                                  } else if (value.isNotEmpty &&
                                      !value.contains(new RegExp(
                                          r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$'))) {
                                    return "Please Enter Email on the formate\nEg: example@email.com";
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  user.email = value;
                                },
                              ),
                              TextFormField(
                                autofillHints: [AutofillHints.password],
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: "Passward",
                                ),
                                autofocus: true,
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return "Enter the Password";
                                  } else if (value.isNotEmpty &&
                                      value.length < 4) {
                                    return "Pasword Must has a length of 4";
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  user.password = value;
                                },
                              ),
                              RaisedButton(
                                onPressed: () async {
                                  if (_form.currentState.validate()) {
                                    _form.currentState.save();
                                    showDialog(
                                      context: context,
                                      builder: (context) => beruLoadingBar(),
                                    );
                                    await Provider.of<AuthService>(context,
                                            listen: false)
                                        .adminLogin(user, context);
                                  }
                                },
                                child: Text("Admin Login"),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ))),
            ),
          ),
        ),
      ),
    );
  }
}

class ChildDelegate extends SingleChildLayoutDelegate {
  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return constraints.loosen();
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset((size.width / 2) - (childSize.width / 2),
        (size.height / 2) - (childSize.height / 2));
  }

  @override
  bool shouldRelayout(SingleChildLayoutDelegate oldDelegate) {
    return false;
  }
}
