/// Video / text / voice analysis vertical slices (`text_analysis`,
/// `video_analysis`, `voice_analysis`) plus `shared/` presentation barrels.
library;

export 'video_analysis/data/datasources/video_analysis_remote_data_source.dart';
export 'video_analysis/data/services/video_analysis_api_service.dart';
export 'video_analysis/domain/repositories/video_analysis_repository.dart';
export 'text_analysis/domain/repositories/text_analysis_repository.dart';
export 'text_analysis/data/datasources/text_analysis_remote_data_source.dart';
export 'voice_analysis/domain/repositories/voice_analysis_repository.dart';
export 'shared/presentation/pages/analysis_screens.dart';