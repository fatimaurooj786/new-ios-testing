import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http/io_client.dart';

class HttpClientHelper {
  // Create an HTTP client that accepts any certificate (unsafe, use only for development)
  static http.Client createHttpClient() {
    // Create an insecure HttpClient that allows invalid certificates
    final HttpClient client = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    // Wrap it in an IOClient
    final ioClient = IOClient(client);
    return ioClient;
  }
}
