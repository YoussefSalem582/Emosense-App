import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emosense_mobile/features/analysis/voice_analysis/presentation/bloc/bloc_exports.dart';
import 'package:emosense_mobile/shared/widgets/common/animated_background_widget.dart';
import 'package:emosense_mobile/shared/widgets/app_bars/analysis_app_bar.dart';
import 'widgets/widgets.dart';

/// Unified Voice Analysis Screen - Refactored with Modular Widgets
///
/// Comprehensive voice analysis interface supporting:
/// - Recorded Calls Analysis
/// - Voice Message Analysis
/// - Audio File Upload
/// - Real-time voice processing
/// - Call quality assessment
class UnifiedVoiceAnalysisScreen extends StatefulWidget {
  const UnifiedVoiceAnalysisScreen({super.key});

  @override
  State<UnifiedVoiceAnalysisScreen> createState() =>
      _UnifiedVoiceAnalysisScreenState();
}

class _UnifiedVoiceAnalysisScreenState extends State<UnifiedVoiceAnalysisScreen>
    with SingleTickerProviderStateMixin {
  // Controllers
  final TextEditingController _callIdController = TextEditingController();

  // Animation
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _backgroundAnimation;

  // State variables
  String _selectedAudioSource = 'upload';
  bool _isRecording = false;
  bool _hasSampleLoaded = false;
  String _loadedSampleTitle = '';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _callIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const AnalysisAppBar(
        title: 'Voice Analysis Hub',
        subtitle: 'Audio Emotion Analysis',
        hasUnreadNotifications: true,
        notificationCount: 1,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Animated Background
            Positioned.fill(
              child: AnimatedBackgroundWidget(animation: _backgroundAnimation),
            ),
            // Content
            BlocBuilder<VoiceAnalysisBloc, VoiceAnalysisState>(
              builder: (context, state) {
                return AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value.clamp(0.0, 1.0),
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: _buildBody(context, state),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, VoiceAnalysisState state) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Audio Source Selector
              VoiceAnalysisSourceSelector(
                selectedSource: _selectedAudioSource,
                onSourceChanged: (source) {
                  setState(() {
                    _selectedAudioSource = source;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Dynamic Content Based on Selected Source
              _buildSourceSpecificContent(),
              const SizedBox(height: 20),

              // Sample Files Section
              VoiceAnalysisSamplesSection(
                key: ValueKey(
                  '$_hasSampleLoaded-$_loadedSampleTitle',
                ), // Rebuild when sample state changes
                onSampleSelected: (sampleTitle) {
                  _loadSampleFile(sampleTitle);
                },
              ),
              const SizedBox(height: 20),

              // Action Buttons
              BlocBuilder<VoiceAnalysisBloc, VoiceAnalysisState>(
                builder: (context, state) {
                  final isAnalyzing = state is VoiceAnalysisLoading;
                  return Column(
                    children: [
                      VoiceAnalysisActionButtons(
                        isAnalyzing: isAnalyzing,
                        onAnalyze: _startAnalysis,
                        onClear: _clearContent,
                        hasContent: _hasContent(),
                      ),
                      const SizedBox(height: 12),
                      // Quick Demo Button for Testing
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: isAnalyzing ? null : _loadQuickDemo,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF8B5CF6),
                            side: const BorderSide(color: Color(0xFF8B5CF6)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.speed, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                isAnalyzing
                                    ? 'Loading...'
                                    : 'Quick Demo Analysis',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),

              // Results Display
              BlocBuilder<VoiceAnalysisBloc, VoiceAnalysisState>(
                builder: (context, state) {
                  final isLoading = state is VoiceAnalysisLoading;
                  final analysisResults = _getAnalysisResults(state);

                  return VoiceAnalysisResultsDisplay(
                    analysisResults: analysisResults,
                    isLoading: isLoading,
                  );
                },
              ),
              const SizedBox(height: 40),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildSourceSpecificContent() {
    switch (_selectedAudioSource) {
      case 'upload':
        return VoiceAnalysisFileUploadSection(
          onFileSelected: (fileName) {
            _handleFileUpload(fileName);
          },
        );
      case 'record':
        return VoiceAnalysisRecordingSection(
          isRecording: _isRecording,
          onRecordingToggle: _toggleRecording,
        );
      case 'call':
        return VoiceAnalysisCallInputSection(
          callIdController: _callIdController,
          onFetchCall: _fetchCallRecording,
        );
      default:
        return VoiceAnalysisFileUploadSection(
          onFileSelected: (fileName) {
            _handleFileUpload(fileName);
          },
        );
    }
  }

  // Event Handlers
  void _handleFileUpload(String fileName) {
    // Handle file upload logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('File uploaded: $fileName'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );

    // Set content flag for analysis
    setState(() {
      // File is now available for analysis
    });
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });

    HapticFeedback.mediumImpact();

    if (_isRecording) {
      // Start recording logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recording started...'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
    } else {
      // Stop recording logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recording stopped'),
          backgroundColor: Color(0xFF64748B),
        ),
      );
    }
  }

  void _fetchCallRecording() {
    final callId = _callIdController.text.trim();
    if (callId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a call ID'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    // Fetch call recording logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fetching call recording: $callId'),
        backgroundColor: const Color(0xFF3B82F6),
      ),
    );
  }

  void _loadSampleFile(String sampleTitle) {
    log('📁 Loading sample: $sampleTitle', name: 'VoiceAnalysis');

    // Load sample file and immediately trigger analysis
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Analyzing sample: $sampleTitle'),
        backgroundColor: const Color(0xFF3B82F6),
        duration: const Duration(seconds: 2),
      ),
    );

    // Set the audio source to show we have content
    setState(() {
      _selectedAudioSource = 'upload';
      _hasSampleLoaded = true;
      _loadedSampleTitle = sampleTitle;
    });

    log(
      '✅ Sample loaded: $_loadedSampleTitle, hasContent: $_hasSampleLoaded',
      name: 'VoiceAnalysis',
    );

    // Immediately trigger analysis for the sample
    String analysisType = _getAnalysisTypeForSample(sampleTitle);
    log(
      '🎯 Auto-analyzing sample with type: $analysisType',
      name: 'VoiceAnalysis',
    );

    // Trigger analysis immediately
    context.read<VoiceAnalysisBloc>().add(
      VoiceAnalysisDemoRequested(analysisType),
    );
  }

  void _loadQuickDemo() {
    log('🚀 Loading quick demo analysis', name: 'VoiceAnalysis');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Running quick demo analysis...'),
        backgroundColor: Color(0xFF8B5CF6),
        duration: Duration(seconds: 2),
      ),
    );

    // Load demo data directly without sample selection
    context.read<VoiceAnalysisBloc>().add(
      const VoiceAnalysisDemoRequested('Customer Support Analysis'),
    );
  }

  void _startAnalysis() {
    if (!_hasContent()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select or provide audio content to analyze'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    HapticFeedback.lightImpact();

    // Check if we have a sample that's already analyzed
    final currentState = context.read<VoiceAnalysisBloc>().state;
    if (_hasSampleLoaded &&
        _loadedSampleTitle.isNotEmpty &&
        currentState is VoiceAnalysisDemo) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$_loadedSampleTitle analysis is already complete!'),
          backgroundColor: const Color(0xFF10B981),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // Determine the analysis type based on whether a sample is loaded
    String analysisType;
    if (_hasSampleLoaded && _loadedSampleTitle.isNotEmpty) {
      analysisType = _getAnalysisTypeForSample(_loadedSampleTitle);

      // Debug: Show what we're about to analyze
      log('🎯 Re-analyzing sample: $_loadedSampleTitle', name: 'VoiceAnalysis');
      log('📊 Analysis type: $analysisType', name: 'VoiceAnalysis');

      // For samples, use loadDemoData to get sample-specific results
      context.read<VoiceAnalysisBloc>().add(
        VoiceAnalysisDemoRequested(analysisType),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Re-analyzing $_loadedSampleTitle...'),
          backgroundColor: const Color(0xFF3B82F6),
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      // Regular analysis for uploaded files, recordings, or calls
      String filePath = _getFilePathForAnalysis();
      analysisType = _getAnalysisType();

      log('🎯 Starting regular analysis: $analysisType', name: 'VoiceAnalysis');
      log('📁 File path: $filePath', name: 'VoiceAnalysis');

      // Trigger analysis through the cubit
      context.read<VoiceAnalysisBloc>().add(
        VoiceAnalysisAnalyzeRequested(
          filePath: filePath,
          analysisType: analysisType,
        ),
      );
    }
  }

  void _clearContent() {
    setState(() {
      _callIdController.clear();
      _isRecording = false;
      _hasSampleLoaded = false;
      _loadedSampleTitle = '';
    });

    // Clear the analysis state in the cubit
    context.read<VoiceAnalysisBloc>().add(const VoiceAnalysisReset());

    HapticFeedback.selectionClick();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Content cleared'),
        backgroundColor: Color(0xFF64748B),
      ),
    );
  }

  bool _hasContent() {
    // Check if there's any content to analyze
    return _callIdController.text.isNotEmpty ||
        _selectedAudioSource == 'upload' ||
        _selectedAudioSource == 'record' ||
        _isRecording ||
        _hasSampleLoaded;
  }

  String _getFilePathForAnalysis() {
    switch (_selectedAudioSource) {
      case 'upload':
        return '/audio/uploaded_file.mp3'; // In real app, this would be the actual uploaded file path
      case 'record':
        return '/audio/recorded_audio.wav'; // In real app, this would be the recorded file path
      case 'call':
        final callId = _callIdController.text.trim();
        return '/audio/call_recording_$callId.mp3'; // In real app, fetch from call ID
      default:
        return '/audio/default_sample.mp3';
    }
  }

  String _getAnalysisType() {
    switch (_selectedAudioSource) {
      case 'upload':
        return 'File Analysis';
      case 'record':
        return 'Real-time Recording Analysis';
      case 'call':
        return 'Call Recording Analysis';
      default:
        return 'Emotion Analysis';
    }
  }

  String _getAnalysisTypeForSample(String sampleTitle) {
    switch (sampleTitle) {
      case 'Customer Service Call':
        return 'Customer Support Analysis';
      case 'Sales Meeting':
        return 'Business Communication Analysis';
      case 'Interview Session':
        return 'Interview Performance Analysis';
      case 'Voice Message':
        return 'Personal Voice Analysis';
      default:
        return 'Sample Audio Analysis';
    }
  }

  Map<String, dynamic>? _getAnalysisResults(VoiceAnalysisState state) {
    log(
      '🔍 Current analysis state: ${state.runtimeType}',
      name: 'VoiceAnalysis',
    );

    if (state is VoiceAnalysisSuccess) {
      final result = state.result;
      log('✅ Success result: ${result.analysisType}', name: 'VoiceAnalysis');
      return {
        'overall_score': result.confidence,
        'dominant_emotion': _extractDominantEmotion(result.emotions),
        'emotions': result.emotions,
        'metrics': result.metrics,
        'transcription':
            result.details.isNotEmpty
                ? result.details.join(' ')
                : 'No transcription available',
        'summary': result.summary,
        'analysis_type': result.analysisType,
        'timestamp': result.timestamp.toString(),
      };
    } else if (state is VoiceAnalysisDemo) {
      final result = state.demoResult;
      log('🎭 Demo result: ${result.analysisType}', name: 'VoiceAnalysis');
      log('📊 Emotions: ${result.emotions}', name: 'VoiceAnalysis');
      return {
        'overall_score': result.confidence,
        'dominant_emotion': _extractDominantEmotion(result.emotions),
        'emotions': result.emotions,
        'metrics': result.metrics,
        'transcription':
            result.details.isNotEmpty
                ? result.details.join(' ')
                : 'Demo transcription: This is a sample analysis of ${result.analysisType.toLowerCase()}',
        'summary': result.summary,
        'analysis_type': result.analysisType,
        'timestamp': result.timestamp.toString(),
      };
    } else if (state is VoiceAnalysisError) {
      log('❌ Error state: ${state.message}', name: 'VoiceAnalysis');
      // Show error in UI
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Analysis Error: ${state.message}'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      });
    } else if (state is VoiceAnalysisLoading) {
      log('⏳ Loading state detected', name: 'VoiceAnalysis');
    } else {
      log('🔄 Initial state', name: 'VoiceAnalysis');
    }
    return null;
  }

  String _extractDominantEmotion(Map<String, double> emotions) {
    if (emotions.isEmpty) return 'Neutral';

    String dominantEmotion = emotions.keys.first;
    double highestValue = emotions.values.first;

    emotions.forEach((emotion, value) {
      if (value > highestValue) {
        highestValue = value;
        dominantEmotion = emotion;
      }
    });

    return dominantEmotion.substring(0, 1).toUpperCase() +
        dominantEmotion.substring(1).toLowerCase();
  }
}
