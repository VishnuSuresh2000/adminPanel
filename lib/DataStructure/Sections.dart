enum Sections {salles, category, product, farmer, seller,  cart }

extension SectionGetString on Sections {
  String get string {
    switch (this) {
      case Sections.category:
        return "category";
        break;
      case Sections.product:
        return "product";
        break;
      case Sections.farmer:
        return "farmer";
        break;
      case Sections.seller:
        return "seller";
        break;
      case Sections.salles:
        return "salles";
        break;
      case Sections.cart:
        return "cart";
        break;
    }
    return null;
  }
 
}
