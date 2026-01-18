import 'dart:typed_data';

abstract class IPdfGeneratorService {
  Future<Uint8List> fromPythonScript({required String script});
}

class DaytonaPdfGeneratorService implements IPdfGeneratorService {
  @override
  Future<Uint8List> fromPythonScript({required String script}) {
    throw UnimplementedError();
  }
}
