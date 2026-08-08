class ScheduledOrderModel {
  int? id;
  Driver? driver;
  Shop? shop;
  double? amount;
  String? bookingDateTime;
  String? orderStatus;
  String? paymentMethod;
  double? payableAmount;
  int? itemsCount;
  DeliveryAddress? deliveryAddress;

  ScheduledOrderModel({
    this.id,
    this.driver,
    this.shop,
    this.amount,
    this.bookingDateTime,
    this.orderStatus,
    this.paymentMethod,
    this.payableAmount,
    this.itemsCount,
    this.deliveryAddress,
  });

  ScheduledOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driver = json['driver'] != null ? Driver.fromJson(json['driver']) : null;
    shop = json['shop'] != null ? Shop.fromJson(json['shop']) : null;
    amount = json['amount'] != null ? double.tryParse(json['amount'].toString()) : null;
    bookingDateTime = json['booking_date_time'];
    orderStatus = json['order_status'];
    paymentMethod = json['payment_method'];
    payableAmount = json['payable_amount'] != null ? double.tryParse(json['payable_amount'].toString()) : null;
    itemsCount = json['items_count'];
    deliveryAddress = json['delivery_address'] != null ? DeliveryAddress.fromJson(json['delivery_address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    if (driver != null) data['driver'] = driver!.toJson();
    if (shop != null) data['shop'] = shop!.toJson();
    data['amount'] = amount;
    data['booking_date_time'] = bookingDateTime;
    data['order_status'] = orderStatus;
    data['payment_method'] = paymentMethod;
    data['payable_amount'] = payableAmount;
    data['items_count'] = itemsCount;
    if (deliveryAddress != null) data['delivery_address'] = deliveryAddress!.toJson();
    return data;
  }
}

class Driver {
  int? id;
  String? fullName;
  String? phoneNumber;
  String? profileImage;

  Driver({this.id, this.fullName, this.phoneNumber, this.profileImage});

  Driver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    phoneNumber = json['phone_number'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['full_name'] = fullName;
    data['phone_number'] = phoneNumber;
    data['profile_image'] = profileImage;
    return data;
  }
}

class Shop {
  int? id;
  String? nameEn;

  Shop({this.id, this.nameEn});

  Shop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameEn = json['name_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name_en'] = nameEn;
    return data;
  }
}

class DeliveryAddress {
  int? id;
  String? address;
  String? city;

  DeliveryAddress({this.id, this.address, this.city});

  DeliveryAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['address'] = address;
    data['city'] = city;
    return data;
  }
}
