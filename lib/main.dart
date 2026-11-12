
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const TriviaShowdownApp());
}

class TriviaShowdownApp extends StatelessWidget {
  const TriviaShowdownApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API-to-Cloud Trivia Showdown',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: const Color(0xFFFFF8FF),
      ),
      home: const TriviaShowdownScreen(),
    );
  }
}

// Decode HTML entities returned by Open Trivia Database.
String cleanText(String text) {
  return text
      .replaceAll('&quot;', '"')
      .replaceAll('&#039;', "'")
      .replaceAll('&amp;', '&')
      .replaceAll('&ldquo;', '"')
      .replaceAll('&rdquo;', '"')
      .replaceAll('&lsquo;', "'")
      .replaceAll('&rsquo;', "'")
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&eacute;', 'é')
      .replaceAll('&uuml;', 'ü');
}

class Question {
  final String questionText;
  final String correctAnswer;
  final List<String> options;

  Question({
    required this.questionText,
    required this.correctAnswer,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final incorrect = List<String>.from(json['incorrect_answers']);
    final correct = json['correct_answer'] as String;

    final allOptions = [...incorrect, correct];
    allOptions.shuffle();

    return Question(
      questionText: cleanText(json['question'] as String),
      correctAnswer: cleanText(correct),
      options: allOptions.map(cleanText).toList(),
    );
  }
}

class TriviaShowdownScreen extends StatefulWidget {
  const TriviaShowdownScreen({super.key});

  @override
  State<TriviaShowdownScreen> createState() =>
      _TriviaShowdownScreenState();
}

class _TriviaShowdownScreenState extends State<TriviaShowdownScreen> {
  List<Question> _questions = [];

  bool _isLoading = true;
  String _error = '';

  int _currentIndex = 0;
  int _score = 0;

  bool _answered = false;
  String? _selectedOption;

  bool _isSynced = false;
  bool _isSyncing = false;

  int _roundId = 0;

  @override
  void initState() {
    super.initState();
    _loadTriviaData();
  }

  // Fetch five questions from Open Trivia Database.
  Future<void> _loadTriviaData() async {
    final roundId = _roundId;

    try {
      final uri = Uri.parse(
        'https://opentdb.com/api.php?amount=5&category=9&difficulty=easy&type=multiple',
      );

      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: 10));

      if (!mounted || roundId != _roundId) return;

      if (response.statusCode != 200) {
        setState(() {
          _error =
              'Server error: ${response.statusCode}. Please try again.';
          _isLoading = false;
        });
        return;
      }

      final data = json.decode(response.body);

      if (data['response_code'] != 0) {
        setState(() {
          _error =
              'Trivia API returned response code ${data['response_code']}. Please try again.';
          _isLoading = false;
        });
        return;
      }

      final results = data['results'] as List;

      if (results.length != 5) {
        setState(() {
          _error =
              'Expected five questions, but received ${results.length}. Please try again.';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _questions = results
            .map((question) => Question.fromJson(question))
            .toList();
        _isLoading = false;
        _error = '';
      });
    } catch (e) {
      if (!mounted || roundId != _roundId) return;

      setState(() {
        _error = 'Connection failed: $e';
        _isLoading = false;
      });
    }
  }

  // Allow only one answer per question.
  void _answerQuestion(String option) {
    if (_answered) return;

    setState(() {
      _answered = true;
      _selectedOption = option;

      if (option == _questions[_currentIndex].correctAnswer) {
        _score++;
      }
    });
  }

  // Move to the next question.
  void _nextQuestion() {
    setState(() {
      if (_currentIndex < _questions.length - 1) {
        _currentIndex++;
        _answered = false;
        _selectedOption = null;
      } else {
        _currentIndex++;
      }
    });
  }

  // Simulate score synchronization.
  // No actual backend request is sent.
  Future<void> _syncScoreToCloud() async {
    if (_isSyncing || _isSynced) return;

    final roundId = _roundId;

    setState(() {
      _isSyncing = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted || roundId != _roundId) return;

    setState(() {
      _isSyncing = false;
      _isSynced = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Simulated sync complete; no backend request was sent.',
        ),
      ),
    );
  }

  // Restart the trivia round.
  void _restart() {
    _roundId++;

    setState(() {
      _isLoading = true;
      _error = '';
      _questions = [];

      _currentIndex = 0;
      _score = 0;

      _answered = false;
      _selectedOption = null;

      _isSynced = false;
      _isSyncing = false;
    });

    _loadTriviaData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Trivia Showdown: API Edition'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _error.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _error,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _restart,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : _currentIndex >= _questions.length
                    ? _buildResultsScreen()
                    : _buildQuestionScreen(),
      ),
    );
  }

  // Display the current question and answer options.
  Widget _buildQuestionScreen() {
    final question = _questions[_currentIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LinearProgressIndicator(
          value: (_currentIndex + 1) / _questions.length,
          backgroundColor: Colors.orange.shade100,
          color: Colors.deepOrange,
        ),
        const SizedBox(height: 16),

        Text(
          'Question ${_currentIndex + 1} of ${_questions.length}',
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              question.questionText,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),

        const SizedBox(height: 20),

        ...question.options.map((option) {
          Color buttonColor = Colors.white;

          if (_answered) {
            if (option == question.correctAnswer) {
              buttonColor = Colors.green.shade200;
            } else if (option == _selectedOption) {
              buttonColor = Colors.red.shade200;
            }
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                disabledBackgroundColor: buttonColor,
                foregroundColor: Colors.black87,
                disabledForegroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _answered
                  ? null
                  : () => _answerQuestion(option),
              child: Text(
                option,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        }),

        const Spacer(),

        if (_answered)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: _nextQuestion,
            child: Text(
              _currentIndex < _questions.length - 1
                  ? 'Next Question →'
                  : 'View Final Score',
            ),
          ),
      ],
    );
  }

  // Display final score and simulated sync.
  Widget _buildResultsScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Showdown Complete!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Final Score: $_score / ${_questions.length}',
            style: const TextStyle(fontSize: 18),
          ),

          const SizedBox(height: 24),

          if (!_isSynced)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: _isSyncing ? null : _syncScoreToCloud,
              icon: const Icon(Icons.cloud_upload),
              label: Text(
                _isSyncing
                    ? 'Simulating sync...'
                    : 'Simulate Score Sync',
              ),
            )
          else
            const Text(
              '✓ Sync Simulation Complete',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

          const SizedBox(height: 16),

          TextButton(
            onPressed: _restart,
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }
}
