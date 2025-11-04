class QueryResponseModel<T> {
  final T? data;
  final String message;
  final bool isSuccessful;

  QueryResponseModel({
    this.data,
    this.message = "",
    this.isSuccessful = true,
  });

  QueryResponseModel copyWith({
    T? data,
    String? message,
    bool? isSuccessful,
  }) =>
      QueryResponseModel(
        data: data ?? this.data,
        message: message ?? this.message,
        isSuccessful: isSuccessful ?? this.isSuccessful,
      );
}
