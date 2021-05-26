import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/photo.dart';
import 'package:news_app/pages/customphotoview.dart';
import 'package:news_app/services/ApiService.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Photo>> _photosList;
  final _photos = <Photo>[];

  @override
  void initState() {
    _photosList = ApiService().getPhotos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Photos")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: FutureBuilder<List<Photo>>(
            future: _photosList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                _photos.addAll(snapshot.data);
                return _buildGrid(_photos);
              } else if (snapshot.hasError) {
                return Center(child: Text("Something wen't wrong"));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(List<Photo> photos) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 150,
            childAspectRatio: 1 / 1,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          var photoItem = photos[index];
          return _buildContainer(photoItem, index);
        });
  }

  Widget _buildContainer(Photo photoItem, int index) {
    return InkResponse(
      onTap: () => _openImage(index,photoItem),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: CachedNetworkImage(
          imageUrl: photoItem.thumbnailUrl,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              Container(
                  width: 30.0,
                  height: 30.0,
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress)),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }

  void _openImage(int index, Photo photoItem) {
    PageController _pageController = PageController(initialPage: index);

    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return CustomPhotoView(
        photos: _photos,
        pageController: _pageController,
      );
    }));
  }
}

