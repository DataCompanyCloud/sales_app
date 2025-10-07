enum PaymentMethod {
  boleto("Boleto Bancário"),
  cartaoCredito("Cartão de Crédito"),
  cartaoDebito("Cartão de Débito"),
  pix("PIX"),
  transferencia("Transferência Bancária"),
  cheque("Cheque"),
  dinheiro("Dinheiro"),
  outros("Outros");

  final String label;
  const PaymentMethod(this.label);
}


final a = PaymentMethod.boleto;
