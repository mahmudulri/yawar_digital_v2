import 'package:get/get.dart';
import 'package:yawar_digital/models/categories_service_model.dart';
import 'package:yawar_digital/services/categoris_service_list.dart';
import 'package:yawar_digital/services/country_list_service.dart';

import '../models/country_list_model.dart';

class ACategorisListController extends GetxController {
  var isLoading = false.obs;
  var allcategorieslist = NewServiceCatModel().obs;

  // Variables to store country and category data
  var countryList = [].obs;
  var categoryList = [].obs;

  final List<Map<String, dynamic>> nonsocialArray = [];

  final List<Map<String, dynamic>> finalArrayCatList = [];

  void fetchcategories() async {
    try {
      isLoading(true);
      await CategoriesListApi().fetchcategoriesList().then((value) {
        // Clear previous data
        nonsocialArray.clear();

        finalArrayCatList.clear();

        final Map<String, dynamic> nonsocial = {};

        // print("result" + socialArray.toList().toString());

        for (var category in value.data!.servicecategories ?? []) {
          final String? type = category.type;
          final int? categoryId = category.id;
          final String? categoryName = category.categoryName;

          // Ensure necessary values are not null
          if (type != null && categoryId != null && categoryName != null) {
            for (var service in category.services ?? []) {
              final String? country = service.company?.country?.countryName;
              final String? countryId = service.company?.countryId;
              final String? countryImage =
                  service.company?.country?.countryFlagImageUrl;
              final String? phoneNumberLength =
                  service.company?.country?.phoneNumberLength;

              if (country != null && countryId != null) {
                // Handle nonsocial categories
                if (type == "nonsocial") {
                  nonsocial.putIfAbsent(country, () {
                    return {
                      'country_id': countryId,
                      'countryImage': countryImage,
                      'phone_number_length': phoneNumberLength,
                      'categories': <String, dynamic>{},
                    };
                  });

                  // Access and update categories map
                  final categories =
                      nonsocial[country]['categories'] as Map<String, dynamic>;
                  categories.putIfAbsent(categoryId.toString(), () {
                    return {
                      'categoryName': categoryName,
                      'country_id': countryId,
                      'countryImage': countryImage,
                      'phone_number_length': phoneNumberLength,
                    };
                  });
                }
              }
            }
          }
        }

        // Convert the nonsocial map to the desired array format
        nonsocial.entries.forEach((entry) {
          final String countryName = entry.key;
          final Map<String, dynamic> countryValue = entry.value;

          final String? countryId = countryValue['country_id'];
          final String? countryImage = countryValue['countryImage'];
          final String? phoneNumberLength = countryValue['phone_number_length'];
          final Map<String, dynamic> categories =
              countryValue['categories'] as Map<String, dynamic>;

          categories.forEach((categoryId, categoryValue) {
            nonsocialArray.add({
              'countryName': countryName,
              'countryId': countryId,
              'countryImage': countryImage,
              'phoneNumberLength': phoneNumberLength,
              'categoryId': categoryId,
              'categoryName': categoryValue['categoryName'],
              "type": "nonsocial",
            });
          });
        });

        // Combine nonsocialArray and socialArray into finalArrayCatList

        finalArrayCatList.addAll(nonsocialArray);

        // Print finalArrayCatList length for verification

        // print("Nonsocial Categories: ${nonsocialArray}");

        isLoading(false);
      });
    } catch (e) {
      print("Error fetching categories: ${e.toString()}");
      isLoading(false);
    }
  }
}

class CategorisListController extends GetxController {
  @override
  void onInit() {
    fetchcategories();
    super.onInit();
  }

  var isLoading = false.obs;

  var allcategorieslist = Rx<NewServiceCatModel?>(null);

  void fetchcategories() async {
    try {
      isLoading(true);
      await CategoriesListApi().fetchcategoriesList().then((value) {
        allcategorieslist.value = value;

        // print(allcategorieslist.toJson());

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}
