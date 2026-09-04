import 'dart:convert';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;

class GoogleDriveService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      drive.DriveApi.driveAppdataScope,
    ],
  );

  GoogleSignInAccount? _currentUser;
  drive.DriveApi? _driveApi;

  GoogleSignInAccount? get currentUser => _currentUser;
  bool get isSignedIn => _currentUser != null;

  Future<GoogleSignInAccount?> signInSilently() async {
    try {
      _currentUser = await _googleSignIn.signInSilently();
      if (_currentUser != null) {
        await _initDriveApi();
      }
      return _currentUser;
    } catch (_) {
      return null;
    }
  }

  Future<GoogleSignInAccount?> signIn() async {
    try {
      _currentUser = await _googleSignIn.signIn();
      if (_currentUser != null) {
        await _initDriveApi();
      }
      return _currentUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _currentUser = null;
    _driveApi = null;
  }

  Future<void> _initDriveApi() async {
    final httpClient = await _googleSignIn.authenticatedClient();
    if (httpClient == null) {
      throw Exception('Failed to get authenticated HTTP client for Google Drive');
    }
    _driveApi = drive.DriveApi(httpClient);
  }

  Future<drive.DriveApi> _ensureDriveApi() async {
    if (_driveApi != null) return _driveApi!;
    final account = await signInSilently() ?? await signIn();
    if (account == null || _driveApi == null) {
      throw Exception('Not authenticated with Google');
    }
    return _driveApi!;
  }

  Future<drive.File> uploadAppDataFile({
    required String fileName,
    required String content,
    String mimeType = 'application/json',
  }) async {
    final api = await _ensureDriveApi();

    final bytes = utf8.encode(content);
    final media = drive.Media(Stream.value(bytes), bytes.length, contentType: mimeType);

    final existingFiles = await api.files.list(
      spaces: 'appDataFolder',
      q: "name = '$fileName' and trashed = false",
      $fields: 'files(id, name, modifiedTime, size)',
    );

    if (existingFiles.files != null && existingFiles.files!.isNotEmpty) {
      final fileId = existingFiles.files!.first.id!;
      final updateMetadata = drive.File()
        ..name = fileName
        ..description = 'Scadar financial data backup';
      return await api.files.update(
        updateMetadata,
        fileId,
        uploadMedia: media,
        $fields: 'id, name, modifiedTime, size',
      );
    } else {
      final createMetadata = drive.File()
        ..name = fileName
        ..parents = ['appDataFolder']
        ..description = 'Scadar financial data backup';
      return await api.files.create(
        createMetadata,
        uploadMedia: media,
        $fields: 'id, name, modifiedTime, size',
      );
    }
  }

  Future<String?> downloadAppDataFile(String fileName) async {
    final api = await _ensureDriveApi();

    final fileList = await api.files.list(
      spaces: 'appDataFolder',
      q: "name = '$fileName' and trashed = false",
      $fields: 'files(id, name, modifiedTime, size)',
    );

    if (fileList.files == null || fileList.files!.isEmpty) {
      return null;
    }

    final fileId = fileList.files!.first.id!;
    final media = await api.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

    final List<int> bytes = [];
    await for (final chunk in media.stream) {
      bytes.addAll(chunk);
    }
    return utf8.decode(bytes);
  }

  Future<drive.File?> getAppDataFileInfo(String fileName) async {
    try {
      final api = await _ensureDriveApi();
      final fileList = await api.files.list(
        spaces: 'appDataFolder',
        q: "name = '$fileName' and trashed = false",
        $fields: 'files(id, name, modifiedTime, size)',
      );

      if (fileList.files == null || fileList.files!.isEmpty) {
        return null;
      }
      return fileList.files!.first;
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteAppDataFile(String fileName) async {
    final api = await _ensureDriveApi();
    final fileList = await api.files.list(
      spaces: 'appDataFolder',
      q: "name = '$fileName' and trashed = false",
      $fields: 'files(id)',
    );

    if (fileList.files != null) {
      for (final file in fileList.files!) {
        if (file.id != null) {
          await api.files.delete(file.id!);
        }
      }
    }
  }
}
