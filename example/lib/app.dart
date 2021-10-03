import 'dart:html' as webFile;
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vrm_dart/vrm_dart.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePageState {
  final VrmMeta meta;
  final Uint8List? thumbnailData;

  HomePageState({required this.meta, this.thumbnailData});
}

final homePageViewModelProvider =
    StateNotifierProvider<HomePageViewModel, AsyncValue<HomePageState>>(
        (ref) => HomePageViewModel(AsyncValue.loading()));

class HomePageViewModel extends StateNotifier<AsyncValue<HomePageState>> {
  HomePageViewModel(AsyncValue<HomePageState> state) : super(state);

  Future<void> downloadThumbnail() async {
    state.whenData((value) {
      if (value.thumbnailData == null) {
        return;
      }

      var blob = webFile.Blob(
          <dynamic>[value.thumbnailData], 'application/octet-stream', 'native');

      webFile.AnchorElement(
        href: webFile.Url.createObjectUrlFromBlob(blob).toString(),
      )
        ..setAttribute("download", "thumbnail.png")
        ..click();
    });
  }

  Future<void> load() async {
    state = AsyncValue.loading();
    try {
      final path = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['vrm']);

      if (path == null) {
        state = AsyncValue.loading();
        return;
      }

      final vrmFileParser =
          VrmFileParser(ByteData.view(path.files.first.bytes!.buffer));
      vrmFileParser.parse();

      state = AsyncValue.data(HomePageState(
        meta: vrmFileParser.vrmMeta,
        thumbnailData: vrmFileParser.thumbnailByteData,
      ));
    } catch (ex) {
      state = AsyncValue.error(ex);
    }
  }
}

class HomePage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homePageViewModelProvider);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () =>
                  ref.read(homePageViewModelProvider.notifier).load(),
              child: Text('Select File')),
          state.map(
            data: (data) {
              return Column(
                children: [
                  Text(data.value.meta.toJson().toString()),
                  SizedBox.square(
                    dimension: 256,
                    child: Image.memory(data.value.thumbnailData!),
                  ),
                  if (data.value.thumbnailData != null)
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(homePageViewModelProvider.notifier)
                            .downloadThumbnail();
                      },
                      child: Text('Download thumbnail'),
                    )
                ],
              );
            },
            loading: (loading) => Container(),
            error: (error) => Center(
              child: Text(error.toString()),
            ),
          ),
        ],
      ),
    );
  }
}
