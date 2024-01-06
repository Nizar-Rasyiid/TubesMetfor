// Mendefinisikan signature (sig) untuk merepresentasikan entitas dalam sistem
abstract sig Item {}
abstract sig User {}
abstract sig Order {
  items: set Item,
  totalAmount: Int,
  status: Status,
  user: one User
}

abstract sig PaymentOption {}

sig CreditCard, DebitCard extends PaymentOption {}

sig PaymentMethod {
  orders: set Order,
  option: one PaymentOption
}

// Merubah Status menjadi abstrak agar nilainya dapat diinstansiasi
abstract sig Status {}

one sig PENDING, PAID, CANCELED extends Status {}

// Mendefinisikan faktor (fact) untuk menambahkan fakta-fakta dalam model
fact {
  // Setiap pesanan memiliki jumlah total yang tidak negatif
  all o: Order | o.totalAmount >= 0
  // Setiap item dalam pesanan harus unik
  all o: Order | no disj i1, i2: o.items | i1 = i2
  // Setiap pesanan memiliki metode pembayaran
  all o: Order | one pm: PaymentMethod | o in pm.orders
  // Setiap pesanan harus dimiliki oleh satu pengguna
  all o: Order | one u: User | o.user = u
}

// Mendefinisikan predikat (pred) untuk membuat pernyataan yang dapat diuji
pred PaymentProcess(order: Order, paymentMethod: PaymentMethod) {
  // Pesanan harus dalam status tertentu sebelum pembayaran
  order.status = PENDING
  // Pesanan harus memiliki jumlah total yang tidak nol
  order.totalAmount > 0
  // Metode pembayaran harus mendukung pesanan
  paymentMethod.orders = order
  // Setelah pembayaran, pesanan berubah menjadi status PAID
  order.status' = PAID
}

// Mendefinisikan asersi (assert) untuk menguji properti-properti dalam model
assert PaymentProperties {
  // Setiap pesanan harus dalam satu dari tiga status: PENDING, PAID, CANCELED
  all o: Order | o.status in Status
  // Setiap item harus termasuk dalam set items dari setiap pesanan
  all i: Item | all o: Order | i in o.items
  // Setiap pesanan harus dimiliki oleh satu pengguna
  all o: Order | one u: User | o.user = u
}

// Menjalankan asersi pada model
check PaymentProperties for 5

// Menjalankan predikat untuk contoh proses pembayaran
run PaymentProcess for 5 but 2 Order, 3 PaymentMethod, 2 User

// Tambahkan opsi pembayaran Credit Card dan Debit Card
one sig CreditCardOption extends PaymentOption {}
one sig DebitCardOption extends PaymentOption {}

// Tambahkan opsi pembayaran ke metode pembayaran
fact {
  all pm: PaymentMethod | pm.option in CreditCardOption + DebitCardOption
}
