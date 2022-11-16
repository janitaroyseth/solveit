import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/message_input_field.dart';
import 'package:project/widgets/search_bar.dart';
import 'package:http/http.dart' as http;

/// The type to display in the gif picker.
enum GifType {
  gif,
  sticker,
}

/// Content for an bottom modal sheet for displaying and
/// picking gifs to send.
class GifPicker extends StatefulWidget {
  /// Which tupe of content, [GifType], the gif picker should display.
  final GifType gifType;

  /// [Function] handler for the chosen gif.
  final Function handler;

  /// Creates an instance of [GifPicker], if no [GifType] is set, it
  /// will by default show gifs.
  const GifPicker(
      {super.key, this.gifType = GifType.gif, required this.handler});

  @override
  State<GifPicker> createState() => _GifPickerState();
}

class _GifPickerState extends State<GifPicker> {
  final TextEditingController _searchController = TextEditingController();

  late Future<http.Response> currentGifSearch;

  late GifType gifType;

  String url = "https://tenor.googleapis.com/v2";

  String trendingPath = "/featured";

  String searchPath = "/search";

  String apiKeyParam = "key=${dotenv.env["TENOR_API_KEY"]}";

  /// Builds and returns a [String] url to send request.
  String buildUrlRequestString(
    String url,
    String apiPath,
    Map<String, dynamic>? params,
  ) {
    String parameters = "";

    if (params != null) {
      for (String param in params.keys) {
        parameters += "&$param=${params[param]}";
      }
    }

    return "$url$apiPath?$apiKeyParam$parameters";
  }

  /// Sends a request to retrieve the trending gifs from Tenor.
  Future<http.Response> getTrendingGifs() async {
    String requestUrl = buildUrlRequestString(url, trendingPath, {"limit": 30});
    return await http.get(Uri.parse(requestUrl));
  }

  /// Sends a request to search through Tenor gifs with the given [String] `query`. Returns
  /// the gifs matching the `query`.
  Future<http.Response> searchGifs(String query) async {
    String requestUrl =
        buildUrlRequestString(url, searchPath, {"q": query, "limit": 30});

    return await http.get(Uri.parse(requestUrl));
  }

  /// Sends a request to retireve the trending stickers from Tenor.
  Future<http.Response> getTrendingStickers() async {
    String requestUrl = buildUrlRequestString(url, trendingPath, {
      "searchfilter": "sticker",
      "limit": 50,
    });
    return await http.get(Uri.parse(requestUrl));
  }

  /// Sends a request to search through Tenor gifs with the given [String] `query`. Returns
  /// the gifs matching the `query`.
  Future<http.Response> searchStickers(String query) async {
    String requestUrl = buildUrlRequestString(url, searchPath, {
      "searchfilter": "sticker",
      "q": query,
      "limit": 50,
    });

    return await http.get(Uri.parse(requestUrl));
  }

  /// Switches to the `gif`[GifType].
  void showGifs() {
    setState(() {
      gifType = GifType.gif;
      if (_searchController.text.isEmpty) {
        currentGifSearch = getTrendingGifs();
      } else {
        currentGifSearch = searchGifs(_searchController.text);
      }
    });
  }

  /// Switches to the `stickers`[GifType].
  void showStickers() {
    setState(() {
      gifType = GifType.sticker;
      if (_searchController.text.isEmpty) {
        currentGifSearch = getTrendingStickers();
      } else {
        currentGifSearch = searchStickers(_searchController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      maxChildSize: 0.8,
      minChildSize: 0.6,
      initialChildSize: 0.6,
      builder: (context, scrollController) => FutureBuilder(
        future: currentGifSearch,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var result = snapshot.data;
            var resultBody = (result as http.Response).body;
            var trendingGifs = json.decode(resultBody)["results"];
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                children: [
                  buildTopHorizontalLine(),
                  buildButtonTabs(),
                  SearchBar(
                    placeholderText: "Search Tenor",
                    searchFunction: (String query) {
                      if (query.isEmpty) {
                        setState(() {
                          gifType == GifType.gif
                              ? currentGifSearch = getTrendingGifs()
                              : currentGifSearch = getTrendingStickers();
                        });
                      } else {
                        setState(() {
                          gifType == GifType.gif
                              ? currentGifSearch = searchGifs(query)
                              : currentGifSearch = searchStickers(query);
                        });
                      }
                    },
                    textEditingController: _searchController,
                  ),
                  buildGifGrid(scrollController, trendingGifs),
                ],
              ),
            );
          }
          return buildLoadingView();
        },
      ),
    );
  }

  Container buildTopHorizontalLine() {
    return Container(
      height: 3,
      width: 100,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(
          Radius.circular(50.0),
        ),
      ),
    );
  }

  Row buildButtonTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (gifType == GifType.gif)
          ElevatedButton(
            onPressed: () {},
            style: Themes.softPrimaryElevatedButtonStyle,
            child: const Text("GIF"),
          )
        else
          TextButton(
            onPressed: showGifs,
            style: Themes.textButtonStyle,
            child: const Text("GIF"),
          ),
        if (gifType == GifType.sticker)
          ElevatedButton(
            onPressed: () {},
            style: Themes.softPrimaryElevatedButtonStyle,
            child: const Text("Stickers"),
          )
        else
          TextButton(
            onPressed: showStickers,
            style: Themes.textButtonStyle,
            child: const Text("Stickers"),
          ),
      ],
    );
  }

  Expanded buildGifGrid(ScrollController scrollController, trendingGifs) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: MasonryGridView.count(
          controller: scrollController,
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          itemCount: trendingGifs.length,
          itemBuilder: (context, index) {
            String gifUrl = trendingGifs[index]["media_formats"]["gif"]["url"];

            return _Gif(handler: widget.handler, gifUrl: gifUrl);
          },
        ),
      ),
    );
  }

  Center buildLoadingView() {
    return const Center(
      child: SizedBox(
        height: 100,
        width: 100,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  void initState() {
    currentGifSearch = getTrendingGifs();
    gifType = widget.gifType;
    super.initState();
  }
}

/// Shows a gif used for [GifPicker].
class _Gif extends StatelessWidget {
  /// Creates an instance of [_Gif], with the given [Function] handler and [String] gifUrl.
  const _Gif({
    required this.handler,
    required this.gifUrl,
  });

  /// [Function] handles tap events on a gif.
  final Function handler;

  /// [String] the url of the gif.
  final String gifUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        handler(gifUrl, MessageType.gif);
        Navigator.of(context).pop();
      },
      child: ClipRRect(
        child: Image.network(
          gifUrl,
        ),
      ),
    );
  }
}
