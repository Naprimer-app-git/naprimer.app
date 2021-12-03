import 'package:naprimer_app_v2/services/networking/abstract_network_service.dart';
import 'package:dio/dio.dart';

class DioNetworkService extends AbstractNetworkService {
  Dio dio = Dio();

  @override
  void addHeader({required String key, required String value}) {
    // TODO: implement addHeader
  }

  @override
  Future<dynamic> makeRequest(
      {required String url,
      RequestMethod requestMethod = RequestMethod.POST,
      body,
      String? contentType,
      Map<String, String>? headers,
      Map<String, dynamic>? query,
      decoder,
      uploadProgress,
      bool ignoreBaseUrl = false}) {
    String method = 'POST';
    switch (requestMethod) {
      case RequestMethod.GET:
        method = 'GET';
        break;
      case RequestMethod.POST:
        method = 'POST';
        break;
      case RequestMethod.PUT:
        method = 'PUT';
        break;
      case RequestMethod.PATCH:
        method = 'PATCH';
        break;
      case RequestMethod.DELETE:
        method = 'DELETE';
        break;
    }

    return dio.request(url,
        data: body,
        options: Options(
            method: method,
            headers: headers,
            contentType: contentType,
            responseDecoder: decoder),
      queryParameters: query,
      onSendProgress: uploadProgress
    );
  }

  @override
  void setBaseUrl(String baseUrl) {
    // TODO: implement setBaseUrl
  }
}
