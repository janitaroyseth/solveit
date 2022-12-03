import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/general/loading_spinner.dart';
import 'package:project/widgets/inputs/message_input_field.dart';
import 'package:project/widgets/inputs/search_bar.dart';
import 'package:http/http.dart' as http;

/// The type to display in the gif picker.
enum GifType {
  gif,
  sticker,
}

/// Content for an bottom modal sheet for displaying and
/// picking gifs to send.
class GifPickerModal extends StatefulWidget {
  /// Which tupe of content, [GifType], the gif picker should display.
  final GifType gifType;

  /// [Function] handler for the chosen gif.
  final Function handler;

  /// Creates an instance of [GifPickerModal], if no [GifType] is set, it
  /// will by default show gifs.
  const GifPickerModal(
      {super.key, this.gifType = GifType.gif, required this.handler});

  @override
  State<GifPickerModal> createState() => _GifPickerModalState();
}

class _GifPickerModalState extends State<GifPickerModal> {
  final TextEditingController _searchController = TextEditingController();

  late Future<http.Response> currentGifSearch;

  late GifType gifType;

  /// base url for the tenor api.
  final String _baseUrl = "https://tenor.googleapis.com/v2";

  /// The path used to find featured or trending gifs.
  final String _trendingPath = "/featured";

  /// The path used for search requests to tenor.
  final String _searchPath = "/search";

  /// api key for for the tenor api.
  final String _apiKeyParam = "key=${dotenv.env["TENOR_API_KEY"]}";

  /// Builds and returns a [String] url to send request.
  String _buildUrlRequestString(
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

    return "$url$apiPath?$_apiKeyParam$parameters";
  }

  /// Sends a request to retrieve the trending gifs from Tenor.
  Future<http.Response> _getTrendingGifs() async {
    String requestUrl =
        _buildUrlRequestString(_baseUrl, _trendingPath, {"limit": 30});
    return await http.get(Uri.parse(requestUrl));
  }

  /// Sends a request to search through Tenor gifs with the given [String] `query`. Returns
  /// the gifs matching the `query`.
  Future<http.Response> _searchGifs(String query) async {
    String requestUrl = _buildUrlRequestString(
        _baseUrl, _searchPath, {"q": query, "limit": 30});

    return await http.get(Uri.parse(requestUrl));
  }

  /// Sends a request to retireve the trending stickers from Tenor.
  Future<http.Response> _getTrendingStickers() async {
    String requestUrl = _buildUrlRequestString(_baseUrl, _trendingPath, {
      "searchfilter": "sticker",
      "limit": 50,
    });
    return await http.get(Uri.parse(requestUrl));
  }

  /// Sends a request to search through Tenor gifs with the given [String] `query`. Returns
  /// the gifs matching the `query`.
  Future<http.Response> _searchStickers(String query) async {
    String requestUrl = _buildUrlRequestString(_baseUrl, _searchPath, {
      "searchfilter": "sticker",
      "q": query,
      "limit": 50,
    });

    return await http.get(Uri.parse(requestUrl));
  }

  /// Switches to the `gif`[GifType].
  void _showGifs() {
    setState(() {
      gifType = GifType.gif;
      if (_searchController.text.isEmpty) {
        currentGifSearch = _getTrendingGifs();
      } else {
        currentGifSearch = _searchGifs(_searchController.text);
      }
    });
  }

  /// Switches to the `stickers`[GifType].
  void _showStickers() {
    setState(() {
      gifType = GifType.sticker;
      if (_searchController.text.isEmpty) {
        currentGifSearch = _getTrendingStickers();
      } else {
        currentGifSearch = _searchStickers(_searchController.text);
      }
    });
  }

  @override
  void initState() {
    currentGifSearch = _getTrendingGifs();
    gifType = widget.gifType;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => DraggableScrollableSheet(
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
                    _topHorizontalLine(ref),
                    _topButtonTabs(),
                    SearchBar(
                      placeholderText: "Search Tenor",
                      searchFunction: _searchGifsAndStickers,
                      textEditingController: _searchController,
                    ),
                    _gifGridView(scrollController, trendingGifs),
                  ],
                ),
              );
            }
            return const LoadingSpinner();
          },
        ),
      ),
    );
  }

  /// Search function for searching gifs.
  _searchGifsAndStickers(String query) {
    if (query.isEmpty) {
      setState(() {
        gifType == GifType.gif
            ? currentGifSearch = _getTrendingGifs()
            : currentGifSearch = _getTrendingStickers();
      });
    } else {
      setState(() {
        gifType == GifType.gif
            ? currentGifSearch = _searchGifs(query)
            : currentGifSearch = _searchStickers(query);
      });
    }
  }

  /// Top horizontal line for decoration.
  Container _topHorizontalLine(WidgetRef ref) {
    return Container(
      height: 3,
      width: 100,
      decoration: BoxDecoration(
        color: Themes.textColor(ref),
        borderRadius: const BorderRadius.all(
          Radius.circular(50.0),
        ),
      ),
    );
  }

  /// Returns button tabs for toggling between searching for stickers or gifs.
  Widget _topButtonTabs() {
    return Consumer(
      builder: (context, ref, child) => Row(
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
              onPressed: _showGifs,
              style: Themes.textButtonStyle(ref),
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
              onPressed: _showStickers,
              style: Themes.textButtonStyle(ref),
              child: const Text("Stickers"),
            ),
        ],
      ),
    );
  }

  /// Returns a grid view displaying the gifs found.
  Expanded _gifGridView(ScrollController scrollController, trendingGifs) {
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
}

/// Shows a gif used for [GifPickerModal].
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
