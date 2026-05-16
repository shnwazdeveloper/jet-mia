import 'dart:convert';
import 'dart:io';

import 'package:localsend_app/config/app_info.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UpdateInfo {
  final String version;
  final Uri url;

  const UpdateInfo({
    required this.version,
    required this.url,
  });
}

Future<UpdateInfo?> checkForUpdate({
  Duration timeout = const Duration(seconds: 6),
}) async {
  final client = HttpClient()..connectionTimeout = timeout;

  try {
    final packageInfo = await PackageInfo.fromPlatform().timeout(timeout);
    final request = await client
        .getUrl(Uri.parse('https://api.github.com/repos/SHNWAZX/jet-mia/releases/latest'))
        .timeout(timeout);
    request.headers.set(HttpHeaders.acceptHeader, 'application/vnd.github+json');
    request.headers.set(HttpHeaders.userAgentHeader, 'Jet-Mia/${packageInfo.version}');

    final response = await request.close().timeout(timeout);
    if (response.statusCode != HttpStatus.ok) {
      return null;
    }

    final body = await utf8.decoder.bind(response).join().timeout(timeout);
    final json = jsonDecode(body);
    if (json is! Map<String, dynamic>) {
      return null;
    }

    final latestTag = (json['tag_name'] as String?)?.trim();
    if (latestTag == null || latestTag.isEmpty) {
      return null;
    }

    if (_compareVersions(_parseVersion(latestTag), _parseVersion(packageInfo.version)) <= 0) {
      return null;
    }

    final releaseUrl = (json['html_url'] as String?)?.trim();
    return UpdateInfo(
      version: latestTag,
      url: Uri.parse(
        releaseUrl == null || releaseUrl.isEmpty ? '$appRepositoryUrl/releases/latest' : releaseUrl,
      ),
    );
  } catch (_) {
    return null;
  } finally {
    client.close(force: true);
  }
}

List<int> _parseVersion(String value) {
  final match = RegExp(r'\d+(?:\.\d+)*').firstMatch(value);
  if (match == null) {
    return const [0];
  }

  return match.group(0)!.split('.').map((part) => int.tryParse(part) ?? 0).toList();
}

int _compareVersions(List<int> left, List<int> right) {
  final length = left.length > right.length ? left.length : right.length;
  for (var i = 0; i < length; i++) {
    final l = i < left.length ? left[i] : 0;
    final r = i < right.length ? right[i] : 0;
    if (l != r) {
      return l.compareTo(r);
    }
  }

  return 0;
}
