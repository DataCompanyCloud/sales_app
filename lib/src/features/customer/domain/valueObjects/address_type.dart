enum AddressType {
  billing("Cobrança"),
  delivery("Entrega"),
  others("Outro");

  final String label;
  const AddressType(this.label);
}
