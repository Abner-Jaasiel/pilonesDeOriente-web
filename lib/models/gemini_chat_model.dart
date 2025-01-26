class GeminiAIResponse {
  final List<Candidate> candidates;
  final UsageMetadata usageMetadata;
  final String modelVersion;

  GeminiAIResponse({
    required this.candidates,
    required this.usageMetadata,
    required this.modelVersion,
  });

  // Deserialización desde JSON
  factory GeminiAIResponse.fromJson(Map<String, dynamic> json) {
    return GeminiAIResponse(
      candidates: (json['candidates'] as List)
          .map((item) => Candidate.fromJson(item))
          .toList(),
      usageMetadata: UsageMetadata.fromJson(json['usageMetadata']),
      modelVersion: json['modelVersion'],
    );
  }
}

class Candidate {
  final Content content;
  final String finishReason;
  final double avgLogprobs;

  Candidate({
    required this.content,
    required this.finishReason,
    required this.avgLogprobs,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      content: Content.fromJson(json['content']),
      finishReason: json['finishReason'],
      avgLogprobs: (json['avgLogprobs'] as num).toDouble(),
    );
  }
}

class Content {
  final List<Part> parts;
  final String role;

  Content({
    required this.parts,
    required this.role,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      parts:
          (json['parts'] as List).map((item) => Part.fromJson(item)).toList(),
      role: json['role'],
    );
  }
}

class Part {
  final String text;

  Part({
    required this.text,
  });

  factory Part.fromJson(Map<String, dynamic> json) {
    return Part(
      text: json['text'],
    );
  }
}

class UsageMetadata {
  final int promptTokenCount;
  final int candidatesTokenCount;
  final int totalTokenCount;

  UsageMetadata({
    required this.promptTokenCount,
    required this.candidatesTokenCount,
    required this.totalTokenCount,
  });

  factory UsageMetadata.fromJson(Map<String, dynamic> json) {
    return UsageMetadata(
      promptTokenCount: json['promptTokenCount'],
      candidatesTokenCount: json['candidatesTokenCount'],
      totalTokenCount: json['totalTokenCount'],
    );
  }
}
