class OpenAiService {
  final String apiKey;
  const OpenAiService(this.apiKey);

  Future<String> generatePrompt({
    String model = 'minimax/minimax-m2.1',
    required String prompt,
  }) async {
    throw UnimplementedError();
  }
}
