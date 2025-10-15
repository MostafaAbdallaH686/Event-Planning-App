import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;

class SupabaseImageStorage {
  final SupabaseClient client;
  final String bucket; // e.g. 'event_images' or 'user_images'
  SupabaseImageStorage(this.client, {this.bucket = 'event_images'});

  Future<String> uploadEventImage({
    required File file,
    required String uid,
  }) async {
    final ext = p.extension(file.path).replaceFirst('.', ''); // e.g. jpg
    final objectPath =
        '${uid}_${DateTime.now().millisecondsSinceEpoch}.$ext'; // e.g. userId_timestamp.jpg

    // Upload (object path only, no bucket prefix)
    await client.storage.from(bucket).upload(
          objectPath,
          file,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
        );

    // Public bucket:
    final url = client.storage.from(bucket).getPublicUrl(objectPath);
    return url;

    // If private bucket, use:
    // final signed = await client.storage.from(bucket).createSignedUrl(objectPath, 3600);
    // return signed;
  }
}
