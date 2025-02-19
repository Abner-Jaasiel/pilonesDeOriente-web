/*class GeminiAIResponse {
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
*/
class GeminiAIResponse {
  final List<Candidate> candidates;
  final UsageMetadata usageMetadata;
  final String modelVersion;

  GeminiAIResponse({
    required this.candidates,
    required this.usageMetadata,
    required this.modelVersion,
  });

  // Deserialización desde JSON con control de errores
  factory GeminiAIResponse.fromJson(Map<String, dynamic> json) {
    try {
      return GeminiAIResponse(
        candidates: (json['candidates'] as List)
            .map((item) => Candidate.fromJson(item))
            .toList(),
        usageMetadata: UsageMetadata.fromJson(json['usageMetadata']),
        modelVersion:
            json['modelVersion'] ?? '', // Default empty string if null
      );
    } catch (e) {
      print('Error deserializando GeminiAIResponse: $e');
      // Opcionalmente, puedes devolver un objeto vacío o con valores por defecto
      return GeminiAIResponse(
        candidates: [],
        usageMetadata: UsageMetadata(
            promptTokenCount: 0, candidatesTokenCount: 0, totalTokenCount: 0),
        modelVersion: '',
      );
    }
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

  // Deserialización desde JSON con control de errores
  factory Candidate.fromJson(Map<String, dynamic> json) {
    try {
      return Candidate(
        content: Content.fromJson(json['content']),
        finishReason:
            json['finishReason'] ?? '', // Default empty string if null
        avgLogprobs: (json['avgLogprobs'] as num?)?.toDouble() ??
            0.0, // Ensure it's a double or default to 0.0
      );
    } catch (e) {
      print('Error deserializando Candidate: $e');
      return Candidate(
        content: Content(parts: [], role: ''),
        finishReason: '',
        avgLogprobs: 0.0,
      );
    }
  }
}

class Content {
  final List<Part> parts;
  final String role;

  Content({
    required this.parts,
    required this.role,
  });

  // Deserialización desde JSON con control de errores
  factory Content.fromJson(Map<String, dynamic> json) {
    try {
      return Content(
        parts:
            (json['parts'] as List).map((item) => Part.fromJson(item)).toList(),
        role: json['role'] ?? '', // Default empty string if null
      );
    } catch (e) {
      print('Error deserializando Content: $e');
      return Content(parts: [], role: '');
    }
  }
}

class Part {
  final String text;

  Part({
    required this.text,
  });

  // Deserialización desde JSON con control de errores
  factory Part.fromJson(Map<String, dynamic> json) {
    try {
      return Part(
        text: json['text'] ?? '', // Default empty string if null
      );
    } catch (e) {
      print('Error deserializando Part: $e');
      return Part(text: '');
    }
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

  // Deserialización desde JSON con control de errores
  factory UsageMetadata.fromJson(Map<String, dynamic> json) {
    try {
      return UsageMetadata(
        promptTokenCount: json['promptTokenCount'] ?? 0, // Default to 0 if null
        candidatesTokenCount:
            json['candidatesTokenCount'] ?? 0, // Default to 0 if null
        totalTokenCount: json['totalTokenCount'] ?? 0, // Default to 0 if null
      );
    } catch (e) {
      print('Error deserializando UsageMetadata: $e');
      return UsageMetadata(
          promptTokenCount: 0, candidatesTokenCount: 0, totalTokenCount: 0);
    }
  }
}
