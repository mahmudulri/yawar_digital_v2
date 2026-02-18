class ApiEndPoints {
  // static String baseUrl =
  //     "https://app-yw-api-2025-v2.yawardigital.com/api/reseller/";

  // static String publicUrl =
  //     "https://app-yw-api-2025-v2.yawardigital.com/api/reseller/";
  // .............................................................//

  static String baseUrl =
      "https://app-api-vpro-wl-waslat.milliekit.com/api/reseller/";

  static String publicUrl =
      "https://app-api-vpro-wl-waslat.milliekit.com/api/public/";

  // static String baseUrl = "https://app-api-vpro-yd.milliekit.com/api/reseller/";
  // static String publicUrl = "https://app-api-vpro-yd.milliekit.com/api/public/";

  static OtherendPoints otherendpoints = OtherendPoints();
}

class OtherendPoints {
  final String loginIink = "login";
  final String signUp = "register";
  final String dashboard = "dashboard";
  final String countrylist = "countries";
  final String subreseller = "sub-resellers";
  final String transactions = "balance_transactions";
  final String subresellerDetails = "sub-resellers/";
  final String servicecategories = "service_categories";
  final String companies = "companies";
  final String services = "services";
  final String currency = "currency";
  final String province = "provinces";
  final String district = "districts";
  final String languages = "languages";
  final String sliders = "advertisements";
  final String commsiongrouplist = "sub-reseller-commission-group";
  final String customrecharge = "custom-recharge";
  final String appsetting = "app-setting";
  final String rechargeconfig = "get-afg-custom-recharge-config";
  final String hawalalist = "hawala-orders";
  final String branch = "hawala-branches";
  final String sellingprice = "reseller-customer-pricing";
  final String createselling = "reseller-customer-pricing";
  final String paymentmethod = "payment-methods";
  final String loanbalance = "reseller-balances";
  final String paymenttypes = "payment-types";
  final String hawalacurrency = "hawala-currency";
  final String earningtransfer = "earning-transfer";
}
