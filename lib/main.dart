import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';


void main() {
  MediaKit.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VideoScreen(),
    );
  }
}


// Hookとは相性が悪そう
class MyHomePage extends HookWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final player = useState(Player());
    player.value.open(Media('https://user-images.githubusercontent.com/28951144/229373695-22f88f13-d18f-4288-9bf1-c3e078d83722.mp4'));
    final controller = useState(VideoController(player.value));
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Kit Video'),
      ),
      body: Column(
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 9.0 / 16.0,
            child: Video(controller: controller.value),
          ),
        ],
      ),
    );
  }
}

List<String> videoList = [
  "https://cdn.pixabay.com/vimeo/176282263/sea-4006.mp4?width=1280&hash=904059a834922d2067cb4a3d8d06e5f0e8279533",
  "https://cdn.pixabay.com/vimeo/396036988/sea-33194.mp4?width=2560&hash=01278e1cc094c2fa6f3ecfcb2a2672a67ae0291e",
  "https://cdn.pixabay.com/vimeo/155244112/islands-2119.mp4?width=1280&hash=b443c511d5272a1ef29b855769e9c1d627ae5a27",
  "https://cdn.pixabay.com/vimeo/386628887/nature-31377.mp4?width=2560&hash=c49bca9c6939af0fc87bd75c2d79678ce406747f",
  "https://cdn.pixabay.com/vimeo/340670744/sea-24216.mp4?width=1280&hash=22987663f1d5bfb74ea9b6d19ae71fef58a66096",
  // 下記は1~5個目の要素と同じ
  "https://cdn.pixabay.com/vimeo/176282263/sea-4006.mp4?width=1280&hash=904059a834922d2067cb4a3d8d06e5f0e8279533",
  "https://cdn.pixabay.com/vimeo/396036988/sea-33194.mp4?width=2560&hash=01278e1cc094c2fa6f3ecfcb2a2672a67ae0291e",
  "https://cdn.pixabay.com/vimeo/155244112/islands-2119.mp4?width=1280&hash=b443c511d5272a1ef29b855769e9c1d627ae5a27",
  "https://cdn.pixabay.com/vimeo/386628887/nature-31377.mp4?width=2560&hash=c49bca9c6939af0fc87bd75c2d79678ce406747f",
  "https://cdn.pixabay.com/vimeo/340670744/sea-24216.mp4?width=1280&hash=22987663f1d5bfb74ea9b6d19ae71fef58a66096",
];

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});
  @override
  State<VideoScreen> createState() => VideoScreenState();
}

class VideoScreenState extends State<VideoScreen> {
  late final player = Player();
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();
    // Play a [Media] or [Playlist].
    player.open(Media(videoList[0]));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Media Kit Video')),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 9.0 / 16.0,
            child: Stack(
              children: [
                Video(
                  controller: controller,
                  pauseUponEnteringBackgroundMode: false, // バックグラウンドでも再生を続ける
                  controls: (state) {
                    return MaterialVideoControls(state);
                  },
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    onPressed: (){
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 200,
                            margin: const EdgeInsets.only(top: 64),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    await player.setRate(1.0);

                                    Navigator.pop(context);
                                  },
                                  child: const Text("1.0倍速"),
                                ),
                                InkWell(
                                  onTap: () async {
                                    await player.setRate(1.5);

                                    Navigator.pop(context);
                                  },
                                  child: const Text("1.5倍速"),
                                ),
                                InkWell(
                                  onTap: () async {
                                    await player.setRate(2.0);

                                    Navigator.pop(context);
                                  },
                                  child: const Text("2.0倍速"),
                                ),
                              ],
                            )
                          );
                        }
                      );
                    }, 
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: videoList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.all(8),
                  title: Text('Item ${index + 1}'),
                  onTap: () => player.open(Media(videoList[index])),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});
  @override
  State<VideoListScreen> createState() => VideoListScreenState();
}

class VideoListScreenState extends State<VideoListScreen> {
  late final player = Player();
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();
    // Play a [Media] or [Playlist].

    ///
    /// Playlistの特徴
    ///
    ///　・再生中の動画が終了したら、次の動画を自動で再生する
    ///　・最後の要素で終了したら、動画の再生がストップする
    ///
    
    player.open(
      Playlist(
        videoList.map((e) => Media(e)).toList(),
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Media Kit Video List')),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 9.0 / 16.0,
            child: Video(
              controller: controller,
              pauseUponEnteringBackgroundMode: false, // バックグラウンドでも再生を続ける
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: videoList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.all(8),
                  title: Text('Item ${index + 1}'),
                  onTap: () => player.jump(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}