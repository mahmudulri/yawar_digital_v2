import 'dart:convert';

TransactionModel transactionModelFromJson(String str) =>
    TransactionModel.fromJson(json.decode(str));

String transactionModelToJson(TransactionModel data) =>
    json.encode(data.toJson());

class TransactionModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final Payload? payload;

  TransactionModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        success: json["success"],
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
        payload: Payload.fromJson(json["payload"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "message": message,
    "data": data!.toJson(),
    "payload": payload!.toJson(),
  };
}

class Data {
  final List<ResellerBalanceTransaction>? resellerBalanceTransactions;

  Data({this.resellerBalanceTransactions});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    resellerBalanceTransactions: List<ResellerBalanceTransaction>.from(
      json["reseller_balance_transactions"].map(
        (x) => ResellerBalanceTransaction.fromJson(x),
      ),
    ),
  );

  Map<String, dynamic> toJson() => {
    "reseller_balance_transactions": List<dynamic>.from(
      resellerBalanceTransactions!.map((x) => x.toJson()),
    ),
  };
}

class ResellerBalanceTransaction {
  final int? id;
  final String? resellerId;
  final String? amount;
  final String? remainingBalance;
  final String? transactionType;
  final String? transactionSource;
  final dynamic currencyCode;
  final String? currencyId;
  final String? status;
  final String? initiatorId;
  final String? initiatorType;
  final String? transactionReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic performedBy;
  final dynamic deletedAt;
  final dynamic subResellerId;
  final dynamic balanceId;
  final Reseller? reseller;
  final Currency? currency;
  final dynamic order;

  ResellerBalanceTransaction({
    this.id,
    this.resellerId,
    this.amount,
    this.remainingBalance,
    this.transactionType,
    this.transactionSource,
    this.currencyCode,
    this.currencyId,
    this.status,
    this.initiatorId,
    this.initiatorType,
    this.transactionReason,
    this.createdAt,
    this.updatedAt,
    this.performedBy,
    this.deletedAt,
    this.subResellerId,
    this.balanceId,
    this.reseller,
    this.currency,
    this.order,
  });

  factory ResellerBalanceTransaction.fromJson(Map<String, dynamic> json) =>
      ResellerBalanceTransaction(
        id: json["id"] == null ? null : json["id"],
        resellerId: json["reseller_id"] == null ? null : json["reseller_id"],
        amount: json["amount"] == null ? null : json["amount"],
        remainingBalance: json["remaining_balance"] == null
            ? null
            : json["remaining_balance"],
        transactionType: json["transaction_type"] == null
            ? null
            : json["transaction_type"],
        transactionSource: json["transaction_source"] == null
            ? null
            : json["transaction_source"],
        currencyCode: json["currency_code"] == null
            ? null
            : json["currency_code"],
        currencyId: json["currency_id"] == null ? null : json["currency_id"],
        status: json["status"] == null ? null : json["status"],
        initiatorId: json["initiator_id"] == null ? null : json["initiator_id"],
        initiatorType: json["initiator_type"] == null
            ? null
            : json["initiator_type"],
        transactionReason: json["transaction_reason"] == null
            ? null
            : json["transaction_reason"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        performedBy: json["performed_by"] == null ? null : json["performed_by"],
        deletedAt: json["deleted_at"] == null ? null : json["deleted_at"],
        subResellerId: json["sub_reseller_id"] == null
            ? null
            : json["sub_reseller_id"],
        balanceId: json["balance_id"] == null ? null : json["balance_id"],
        reseller: json["reseller"] == null
            ? null
            : Reseller.fromJson(json["reseller"]),
        currency: json["currency"] == null
            ? null
            : Currency.fromJson(json["currency"]),
        order: json["order"] == null ? null : json["order"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "reseller_id": resellerId,
    "amount": amount,
    "remaining_balance": remainingBalance,
    "transaction_type": transactionType,
    "transaction_source": transactionSource,
    "currency_code": currencyCode,
    "currency_id": currencyId,
    "status": status,
    "initiator_id": initiatorId,
    "initiator_type": initiatorType,
    "transaction_reason": transactionReason,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "performed_by": performedBy,
    "deleted_at": deletedAt,
    "sub_reseller_id": subResellerId,
    "balance_id": balanceId,
    "reseller": reseller!.toJson(),
    "currency": currency!.toJson(),
    "order": order,
  };
}

class Currency {
  final int? id;
  final String? name;
  final String? code;
  final String? symbol;
  final String? ignoreDigitsCount;
  final String? exchangeRatePerUsd;
  final dynamic deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Currency({
    this.id,
    this.name,
    this.code,
    this.symbol,
    this.ignoreDigitsCount,
    this.exchangeRatePerUsd,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    code: json["code"] == null ? null : json["code"],
    symbol: json["symbol"] == null ? null : json["symbol"],
    ignoreDigitsCount: json["ignore_digits_count"] == null
        ? null
        : json["ignore_digits_count"],
    exchangeRatePerUsd: json["exchange_rate_per_usd"] == null
        ? null
        : json["exchange_rate_per_usd"],
    deletedAt: json["deleted_at"] == null ? null : json["deleted_at"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "symbol": symbol,
    "ignore_digits_count": ignoreDigitsCount,
    "exchange_rate_per_usd": exchangeRatePerUsd,
    "deleted_at": deletedAt,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}

class Reseller {
  final int? id;
  final dynamic resellerIdentityAttachment;
  final dynamic extraOptionalProof;
  final String? resellerGroupId;
  final String? userId;
  final dynamic parentId;
  final String? uuid;
  final String? resellerName;
  final String? contactName;
  final String? resellerType;
  final dynamic emailVerifiedAt;
  final String? accountPassword;
  final String? personalPin;
  final dynamic rememberToken;
  final dynamic profileImageUrl;
  final String? email;
  final String? phone;
  final String? countryId;
  final String? provinceId;
  final String? districtsId;
  final String? isResellerVerified;
  final String? status;
  final String? isSelfRegistered;
  final String? payment;
  final String? balance;
  final String? totalEarningBalance;
  final String? loanBalance;
  final String? totalPaymentsReceived;
  final String? totalBalanceSent;
  final String? netPaymentBalance;
  final dynamic fcmToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? performedBy;
  final dynamic deletedAt;
  final String? canCreateSubResellers;
  final String? subResellerLimit;
  final String? subResellersCanCreateSubResellers;
  final dynamic subResellerCommissionGroupId;
  final String? canSetCommissionGroup;
  final String? canSetSellingPriceGroup;
  final String? canSendPaymentRequest;
  final String? canAskLoanBalance;
  final String? canSeeOurContact;
  final String? canSeeParentContact;
  final String? canSendHawala;
  final String? maxLoanBalanceRequestAmount;
  final String? minLoanBalanceRequestAmount;
  final String? afgCustomRechargeAdjustType;
  final String? afgCustomRechargeAdjustMode;
  final String? afgCustomRechargeAdjustValue;
  final User? user;

  Reseller({
    this.id,
    this.resellerIdentityAttachment,
    this.extraOptionalProof,
    this.resellerGroupId,
    this.userId,
    this.parentId,
    this.uuid,
    this.resellerName,
    this.contactName,
    this.resellerType,
    this.emailVerifiedAt,
    this.accountPassword,
    this.personalPin,
    this.rememberToken,
    this.profileImageUrl,
    this.email,
    this.phone,
    this.countryId,
    this.provinceId,
    this.districtsId,
    this.isResellerVerified,
    this.status,
    this.isSelfRegistered,
    this.payment,
    this.balance,
    this.totalEarningBalance,
    this.loanBalance,
    this.totalPaymentsReceived,
    this.totalBalanceSent,
    this.netPaymentBalance,
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
    this.performedBy,
    this.deletedAt,
    this.canCreateSubResellers,
    this.subResellerLimit,
    this.subResellersCanCreateSubResellers,
    this.subResellerCommissionGroupId,
    this.canSetCommissionGroup,
    this.canSetSellingPriceGroup,
    this.canSendPaymentRequest,
    this.canAskLoanBalance,
    this.canSeeOurContact,
    this.canSeeParentContact,
    this.canSendHawala,
    this.maxLoanBalanceRequestAmount,
    this.minLoanBalanceRequestAmount,
    this.afgCustomRechargeAdjustType,
    this.afgCustomRechargeAdjustMode,
    this.afgCustomRechargeAdjustValue,
    this.user,
  });

  factory Reseller.fromJson(Map<String, dynamic> json) => Reseller(
    id: json["id"] == null ? null : json["id"],
    resellerIdentityAttachment: json["reseller_identity_attachment"] == null
        ? null
        : json["reseller_identity_attachment"],
    extraOptionalProof: json["extra_optional_proof"] == null
        ? null
        : json["extra_optional_proof"],
    resellerGroupId: json["reseller_group_id"] == null
        ? null
        : json["reseller_group_id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    parentId: json["parent_id"] == null ? null : json["parent_id"],
    uuid: json["uuid"] == null ? null : json["uuid"],
    resellerName: json["reseller_name"] == null ? null : json["reseller_name"],
    contactName: json["contact_name"] == null ? null : json["contact_name"],
    resellerType: json["reseller_type"] == null ? null : json["reseller_type"],
    emailVerifiedAt: json["email_verified_at"] == null
        ? null
        : json["email_verified_at"],
    accountPassword: json["account_password"] == null
        ? null
        : json["account_password"],
    personalPin: json["personal_pin"] == null ? null : json["personal_pin"],
    rememberToken: json["remember_token"] == null
        ? null
        : json["remember_token"],
    profileImageUrl: json["profile_image_url"] == null
        ? null
        : json["profile_image_url"],
    email: json["email"] == null ? null : json["email"],
    phone: json["phone"] == null ? null : json["phone"],
    countryId: json["country_id"] == null ? null : json["country_id"],
    provinceId: json["province_id"] == null ? null : json["province_id"],
    districtsId: json["districts_id"] == null ? null : json["districts_id"],
    isResellerVerified: json["is_reseller_verified"] == null
        ? null
        : json["is_reseller_verified"],
    status: json["status"] == null ? null : json["status"],
    isSelfRegistered: json["is_self_registered"] == null
        ? null
        : json["is_self_registered"],
    payment: json["payment"] == null ? null : json["payment"],
    balance: json["balance"] == null ? null : json["balance"],
    totalEarningBalance: json["total_earning_balance"] == null
        ? null
        : json["total_earning_balance"],
    loanBalance: json["loan_balance"] == null ? null : json["loan_balance"],
    totalPaymentsReceived: json["total_payments_received"] == null
        ? null
        : json["total_payments_received"],
    totalBalanceSent: json["total_balance_sent"] == null
        ? null
        : json["total_balance_sent"],
    netPaymentBalance: json["net_payment_balance"] == null
        ? null
        : json["net_payment_balance"],
    fcmToken: json["fcm_token"] == null ? null : json["fcm_token"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    performedBy: json["performed_by"] == null ? null : json["performed_by"],
    deletedAt: json["deleted_at"] == null ? null : json["deleted_at"],
    canCreateSubResellers: json["can_create_sub_resellers"] == null
        ? null
        : json["can_create_sub_resellers"],
    subResellerLimit: json["sub_reseller_limit"] == null
        ? null
        : json["sub_reseller_limit"],
    subResellersCanCreateSubResellers:
        json["sub_resellers_can_create_sub_resellers"] == null
        ? null
        : json["sub_resellers_can_create_sub_resellers"],
    subResellerCommissionGroupId:
        json["sub_reseller_commission_group_id"] == null
        ? null
        : json["sub_reseller_commission_group_id"],
    canSetCommissionGroup: json["can_set_commission_group"] == null
        ? null
        : json["can_set_commission_group"],
    canSetSellingPriceGroup: json["can_set_selling_price_group"] == null
        ? null
        : json["can_set_selling_price_group"],
    canSendPaymentRequest: json["can_send_payment_request"] == null
        ? null
        : json["can_send_payment_request"],
    canAskLoanBalance: json["can_ask_loan_balance"] == null
        ? null
        : json["can_ask_loan_balance"],
    canSeeOurContact: json["can_see_our_contact"] == null
        ? null
        : json["can_see_our_contact"],
    canSeeParentContact: json["can_see_parent_contact"] == null
        ? null
        : json["can_see_parent_contact"],
    canSendHawala: json["can_send_hawala"] == null
        ? null
        : json["can_send_hawala"],
    maxLoanBalanceRequestAmount: json["max_loan_balance_request_amount"] == null
        ? null
        : json["max_loan_balance_request_amount"],
    minLoanBalanceRequestAmount: json["min_loan_balance_request_amount"] == null
        ? null
        : json["min_loan_balance_request_amount"],
    afgCustomRechargeAdjustType: json["afg_custom_recharge_adjust_type"] == null
        ? null
        : json["afg_custom_recharge_adjust_type"],
    afgCustomRechargeAdjustMode: json["afg_custom_recharge_adjust_mode"] == null
        ? null
        : json["afg_custom_recharge_adjust_mode"],
    afgCustomRechargeAdjustValue:
        json["afg_custom_recharge_adjust_value"] == null
        ? null
        : json["afg_custom_recharge_adjust_value"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "reseller_identity_attachment": resellerIdentityAttachment,
    "extra_optional_proof": extraOptionalProof,
    "reseller_group_id": resellerGroupId,
    "user_id": userId,
    "parent_id": parentId,
    "uuid": uuid,
    "reseller_name": resellerName,
    "contact_name": contactName,
    "reseller_type": resellerType,
    "email_verified_at": emailVerifiedAt,
    "account_password": accountPassword,
    "personal_pin": personalPin,
    "remember_token": rememberToken,
    "profile_image_url": profileImageUrl,
    "email": email,
    "phone": phone,
    "country_id": countryId,
    "province_id": provinceId,
    "districts_id": districtsId,
    "is_reseller_verified": isResellerVerified,
    "status": status,
    "is_self_registered": isSelfRegistered,
    "payment": payment,
    "balance": balance,
    "total_earning_balance": totalEarningBalance,
    "loan_balance": loanBalance,
    "total_payments_received": totalPaymentsReceived,
    "total_balance_sent": totalBalanceSent,
    "net_payment_balance": netPaymentBalance,
    "fcm_token": fcmToken,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "performed_by": performedBy,
    "deleted_at": deletedAt,
    "can_create_sub_resellers": canCreateSubResellers,
    "sub_reseller_limit": subResellerLimit,
    "sub_resellers_can_create_sub_resellers": subResellersCanCreateSubResellers,
    "sub_reseller_commission_group_id": subResellerCommissionGroupId,
    "can_set_commission_group": canSetCommissionGroup,
    "can_set_selling_price_group": canSetSellingPriceGroup,
    "can_send_payment_request": canSendPaymentRequest,
    "can_ask_loan_balance": canAskLoanBalance,
    "can_see_our_contact": canSeeOurContact,
    "can_see_parent_contact": canSeeParentContact,
    "can_send_hawala": canSendHawala,
    "max_loan_balance_request_amount": maxLoanBalanceRequestAmount,
    "min_loan_balance_request_amount": minLoanBalanceRequestAmount,
    "afg_custom_recharge_adjust_type": afgCustomRechargeAdjustType,
    "afg_custom_recharge_adjust_mode": afgCustomRechargeAdjustMode,
    "afg_custom_recharge_adjust_value": afgCustomRechargeAdjustValue,
    "user": user!.toJson(),
  };
}

class User {
  final int? id;
  final String? uuid;
  final String? name;
  final String? email;
  final String? phone;
  final String? userType;
  final dynamic emailVerifiedAt;
  final String? currencyPreferenceCode;
  final String? currencyPreferenceId;
  final dynamic fcmToken;
  final dynamic deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Currency? currency;

  User({
    this.id,
    this.uuid,
    this.name,
    this.email,
    this.phone,
    this.userType,
    this.emailVerifiedAt,
    this.currencyPreferenceCode,
    this.currencyPreferenceId,
    this.fcmToken,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.currency,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] == null ? null : json["id"],
    uuid: json["uuid"] == null ? null : json["uuid"],
    name: json["name"] == null ? null : json["name"],
    email: json["email"] == null ? null : json["email"],
    phone: json["phone"] == null ? null : json["phone"],
    userType: json["user_type"] == null ? null : json["user_type"],
    emailVerifiedAt: json["email_verified_at"] == null
        ? null
        : json["email_verified_at"],
    currencyPreferenceCode: json["currency_preference_code"] == null
        ? null
        : json["currency_preference_code"],
    currencyPreferenceId: json["currency_preference_id"] == null
        ? null
        : json["currency_preference_id"],
    fcmToken: json["fcm_token"] == null ? null : json["fcm_token"],
    deletedAt: json["deleted_at"] == null ? null : json["deleted_at"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    currency: json["currency"] == null
        ? null
        : Currency.fromJson(json["currency"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uuid": uuid,
    "name": name,
    "email": email,
    "phone": phone,
    "user_type": userType,
    "email_verified_at": emailVerifiedAt,
    "currency_preference_code": currencyPreferenceCode,
    "currency_preference_id": currencyPreferenceId,
    "fcm_token": fcmToken,
    "deleted_at": deletedAt,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "currency": currency!.toJson(),
  };
}

class Payload {
  final Pagination? pagination;

  Payload({this.pagination});

  factory Payload.fromJson(Map<String, dynamic> json) =>
      Payload(pagination: Pagination.fromJson(json["pagination"]));

  Map<String, dynamic> toJson() => {"pagination": pagination!.toJson()};
}

class Pagination {
  final int? page;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;

  final int? itemsPerPage;
  final int? total;

  Pagination({
    this.page,
    this.firstPageUrl,
    this.from,
    this.lastPage,

    this.itemsPerPage,
    this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    page: json["page"] == null ? null : json["page"],
    firstPageUrl: json["first_page_url"] == null
        ? null
        : json["first_page_url"],
    from: json["from"] == null ? null : json["from"],
    lastPage: json["last_page"] == null ? null : json["last_page"],

    itemsPerPage: json["items_per_page"] == null
        ? null
        : json["items_per_page"],
    total: json["total"] == null ? null : json["total"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,

    "items_per_page": itemsPerPage,
    "total": total,
  };
}
