import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trancend/src/models/track.model.dart';

class AudioCombinerService {
  Future<String> combineAudioTracks(List<Track> tracks, int delaySeconds) async {
    try {
      final dir = await getTemporaryDirectory();
      final outputFile = '${dir.path}/combined_${DateTime.now().millisecondsSinceEpoch}.mp3';
      final fileListPath = '${dir.path}/file_list.txt';
      
      print('Creating file list at $fileListPath');
      final fileList = File(fileListPath);
      await fileList.create(recursive: true);
      
      // Clear the file first
      await fileList.writeAsString('');
      
      // Download and verify each track
      for (final track in tracks) {
        final path = await _downloadTrack(track);
        print('Adding track to file list: $path');
        final escapedPath = path.replaceAll("'", "'\\''");
        await fileList.writeAsString("file '$escapedPath'\n", mode: FileMode.append);
        
        // Add silence between tracks if delay is specified
        if (delaySeconds > 0 && track != tracks.last) {
          final silenceFile = await _createSilenceFile(delaySeconds);
          print('Adding silence file: $silenceFile');
          final escapedSilencePath = silenceFile.replaceAll("'", "'\\''");
          await fileList.writeAsString("file '$escapedSilencePath'\n", mode: FileMode.append);
        }
      }
      
      print('File list contents:');
      print(await fileList.readAsString());
      
      print('Combining tracks using FFmpeg');
      final session = await FFmpegKit.execute('-f concat -safe 0 -i "$fileListPath" -c copy "$outputFile"');
      final returnCode = await session.getReturnCode();
      final logs = await session.getLogs();
      
      print('FFmpeg logs:');
      print(logs.join('\n'));
      
      if (!ReturnCode.isSuccess(returnCode)) {
        throw Exception('Failed to combine audio tracks: ${logs.join('\n')}');
      }
      
      // Verify output file
      final outputFileObj = File(outputFile);
      if (!await outputFileObj.exists()) {
        throw Exception('Output file was not created');
      }
      
      final size = await outputFileObj.length();
      print('Combined file size: $size bytes');
      if (size == 0) {
        throw Exception('Combined file is empty');
      }
      
      return outputFile;
    } catch (e) {
      print('Error combining tracks: $e');
      rethrow;
    }
  }

  Future<String> _downloadTrack(Track track) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${track.id}.mp3');
      
      if (await file.exists()) {
        print('Track already downloaded: ${track.id}');
        return file.path;
      }
      
      print('Downloading track ${track.id} from ${track.url}');
      final uri = Uri.parse(track.url!);
      final request = await HttpClient().getUrl(uri);
      final response = await request.close();
      await response.pipe(file.openWrite());
      
      // Validate the audio file by checking its duration
      final session = await FFmpegKit.execute('-i "${file.path}" -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1');
      final output = (await session.getOutput())?.trim();
      
      if (output == null || double.tryParse(output) == null) {
        throw Exception('Invalid audio file: no duration found');
      }
      
      return file.path;
    } catch (e) {
      print('Error downloading track: $e');
      rethrow;
    }
  }

  Future<String> _createSilenceFile(int durationSeconds) async {
    final dir = await getTemporaryDirectory();
    final outputFile = '${dir.path}/silence_${durationSeconds}s.mp3';
    
    if (await File(outputFile).exists()) {
      return outputFile;
    }
    
    final session = await FFmpegKit.execute(
      '-f lavfi -i anullsrc=r=44100:cl=stereo -t $durationSeconds -c:a libmp3lame -q:a 2 "$outputFile"'
    );
    
    if (!ReturnCode.isSuccess(await session.getReturnCode())) {
      throw Exception('Failed to create silence file');
    }
    
    return outputFile;
  }

  Future<void> cleanupTempFiles() async {
    try {
      final dir = await getTemporaryDirectory();
      final files = dir.listSync();
      for (final file in files) {
        if (file is File && (file.path.endsWith('.mp3') || file.path.endsWith('.txt'))) {
          await file.delete();
        }
      }
    } catch (e) {
      print('Error cleaning up temp files: $e');
    }
  }
} 