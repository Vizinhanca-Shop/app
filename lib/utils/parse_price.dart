int parsePrice(String formattedPrice) {
  String cleanPrice = formattedPrice.replaceAll('R\$', '').trim();

  String numericPrice = cleanPrice.replaceAll('.', '').replaceAll(',', '.');

  double doublePrice = double.parse(numericPrice);

  return (doublePrice * 100).round();
}
