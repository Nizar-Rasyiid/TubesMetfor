// Mendefinisikan signature (sig) untuk merepresentasikan entitas dalam sistem
abstract sig Text {}
abstract sig Status {}
abstract sig EncryptedText {}

sig User {
  id: one Text,
  nama: one Text,
  alamat: one Text,
  nohp: one Text
}

sig Login {
  user: User,
  username: Text,
  password: EncryptedText
}

sig Order {
  user: User,
  jarak: Int,
  harga: Int,
  lokJemput: Text,
  lokTujuan: Text,
  status: Status,
  payment: Payment,
}

abstract sig Payment {
  idPembayaran: Text,
  metodePembayaran: Text,
  service: PaymentService,
  status: Status,
}

sig EWallet extends Payment {
  PhoneNumber: Text
}

sig CreditCard extends Payment {
  CardNumber: Text,
  ExpiredDate: Text
}

sig CashOnDelivery extends Payment {
  Confirm: Text
}

sig PaymentService {
  order: Order
}

sig LoginService {
  login: Login
}

one sig Progress, Selesai extends Status {}

pred ValidOrderUser[o: Order] {
  o.user in User
}

pred ValidPaymentService[ps: PaymentService] {
  ps.order in Order
}

pred ValidLoginService[ls: LoginService] {
  ls.login in Login
}

pred ValidPayment[p: Payment] {
  p in Payment
}

pred OrderInProgress[o: Order] {
  o.status != Selesai
}

pred OrderCompleted[o: Order] {
  o.status = Selesai
}

pred PaymentSuccessful[p: Payment] {
  p.status = Selesai
}

pred PaymentFailed[p: Payment] {
  p.status = Selesai
}

fact {
  some u: User | u.id != none and u.nama != none and u.alamat != none
  some l: Login | l.user in User and l.username != none and l.password != none
  some o: Order | o.user != none and o.status != none
  some ps: PaymentService | ps.order != none
  some pay: Payment | pay.metodePembayaran != none and pay.idPembayaran != none and pay.service in PaymentService
  some ew: EWallet | ew.PhoneNumber != none and ew.metodePembayaran != none and ew.idPembayaran != none and ew.service in PaymentService
  some cc: CreditCard | cc.CardNumber != none and cc.ExpiredDate != none and cc.metodePembayaran != none and cc.idPembayaran != none and cc.service in PaymentService
  some cod: CashOnDelivery | cod.Confirm != none and cod.metodePembayaran != none and cod.idPembayaran != none and cod.service in PaymentService
  some ls: LoginService | ls.login != none
}

fact InitialOrderStatus {
  all o: Order | o.status = Selesai
}

fact InitialPaymentStatus {
  all p: Payment | p.status = Progress
}

fact LoginRequiredForOrders {
  all o: Order | some l: Login | o.user = l.user
}

fact PaymentServiceForEachPayment {
  all p: Payment | one ps: PaymentService | p.service = ps
}

assert UserHasUniqueID {
  all disj u1, u2: User | u1.id != u2.id
}

assert LoginHasUniqueUsername {
  all disj l1, l2: Login | l1.username != l2.username
}

assert OrderHasUser {
  all o: Order | o.user != none
}

assert PaymentServiceHasOrder {
  all ps: PaymentService | ps.order in Order
}

assert CreditCardIsPayment {
  all cc: CreditCard | cc in Payment
}

assert EWalletIsPayment {
  all ew: EWallet | ew in Payment
}

assert CashOnDeliveryisPayment {
  all cod: CashOnDelivery | cod in Payment
}

assert PaymentHasService {
  all pay: Payment | pay.service in PaymentService
}

assert ConsistentOrderStatus {
  all o: Order | one s: Status | o.status = s
}

assert UniquePaymentIDs {
  all disj p1, p2: Payment | p1.idPembayaran != p2.idPembayaran
}

assert UniqueLoginInstances {
  all disj l1, l2: Login | l1 != l2 implies (l1.user != l2.user or l1.username != l2.username)
}
/*
check NoConcurrentOrders {
  no o1, o2: Order | o1.status = Progress and o2.status = Progress and o1 != o2
}

check PaymentMatchesOrder {
  all p: Payment | some o: Order | p.service.order = o and p.service.order.user = p.service.order.user
}
*/
run {} for 5 but 3 Int, 5 Text, 3 EncryptedText
