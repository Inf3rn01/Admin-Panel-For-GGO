class ProductFeaturesModel {
  Map<String, dynamic> features;

  ProductFeaturesModel({
    required this.features,
  });

  factory ProductFeaturesModel.fromJson(Map<String, dynamic> json) {
    return ProductFeaturesModel(
      features: json,
    );
  }

  Map<String, dynamic> toJson() {
    return features;
  }
}