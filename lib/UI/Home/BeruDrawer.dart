import 'package:beru_admin/DataStructure/Sections.dart';
import 'package:beru_admin/UI/Home/BLoCForHome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class BeruAdminPanelDrawer extends StatelessWidget {
  const BeruAdminPanelDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var blockHome = Provider.of<BlocForHome>(context);
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          Container(
            child: Text("Admin Section"),
          ).centered().p8(),
          ...Sections.values
              .map((e) => ListTile(
                    onTap: () => blockHome.section = e,
                    title: Text(
                      e.string.firstLetterUpperCase(),
                      style: TextStyle(
                          color: blockHome.section == e
                              ? Vx.green800
                              : Vx.blue800),
                    ),
                  )
                      .card
                      .color(blockHome.section == e ? Vx.green200 : Vx.blue200)
                      .p8
                      .make())
              .toList(),
        ]),
      ),
    );
  }
}
