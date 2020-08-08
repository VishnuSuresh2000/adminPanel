import 'package:beru_admin/DataStructure/Sections.dart';
import 'package:beru_admin/Schema/Product.dart';
import 'package:beru_admin/UI/CommonFunctions/ShowImg.dart';
import 'package:beru_admin/UI/PlatformInDependent/UploadImg.dart';
import 'package:beru_admin/UI/Sections/Product/AddOrUpdateProduct.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ViewProduct extends StatelessWidget {
  final Product product;

  ViewProduct({Key key, this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: context.isMobile ? 0.8 : 0.6,
      child: ExpansionTile(
        title: "${product.name.firstLetterUpperCase()}".text.make(),
        children: [
          ListTile(
            title: "Discription : ${product.description}".text.make(),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                "Category : ${product.category.name.firstLetterUpperCase()}"
                    .text
                    .make(),
                "Cost : ${product.amount}".text.make(),
                "Sales : ${product.salles.length ?? 0}".text.make(),
                "${product.inKg ? 'In Kg' : 'In Piece'}".text.make()
              ],
            ),
          ),
          ListTile(
            title: Text("${product.hasImg ? 'Update' : 'Upload'} Image"),
            subtitle: Text("The File must be in PNG Formate."),
            trailing: RaisedButton(
                child: Text("${product.hasImg ? 'Update' : 'Upload'}"),
                onPressed: () =>
                    uploadImageToServer(product.id, Sections.product, context)),
          ),
          showImage(product.hasImg, Sections.product, product.id, context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RaisedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AddOrUpdateProduct(
                    product: product,
                    addOrUpdate: false,
                  ),
                ),
                child: "update".text.make(),
              ),
              RaisedButton(
                onPressed: () {},
                child: "Disable".text.make(),
              ),
            ],
          )
        ],
      ).card.py4.make(),
    );
  }
}
