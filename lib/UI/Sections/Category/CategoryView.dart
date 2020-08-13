import 'package:beru_admin/DataStructure/Sections.dart';
import 'package:beru_admin/Schema/BeruCategory.dart';
import 'package:beru_admin/UI/CommonFunctions/ShowImg.dart';
import 'package:beru_admin/UI/PlatformInDependent/UploadImg.dart';
import 'package:beru_admin/UI/Sections/Category/CategoryAddorUpdate.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class BeruCategoryView extends StatelessWidget {
  final BeruCategory category;
  const BeruCategoryView({Key key, this.category}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text("${category.name.firstLetterUpperCase()}"),
      children: [
        ListTile(
          title: Text("${category.hasImg ? 'Update' : 'Upload'} Image"),
          subtitle: Text("The File must be in PNG Formate."),
          trailing: RaisedButton(
              child: Text("${category.hasImg ? 'Update' : 'Upload'}"),
              onPressed: () => uploadImageToServer(
                  category.id, Sections.category, context)),
        ),
        showImage(category.hasImg, Sections.category, category.id, context),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            RaisedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddOrUpdateCategory(
                    addOrUpadte: false,
                    category: category,
                  ),
                );
              },
              child: "Update".text.make(),
            ),
            RaisedButton(
              onPressed: () {},
              child: "Disable".text.make(),
            )
          ],
        )
      ],
    );
  }
}


