import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:news_app/constants/utils.dart';
import 'package:news_app/models/photo.dart';
import 'package:news_app/permissions/storagepermission.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class CustomPhotoView extends StatelessWidget {
  const CustomPhotoView({
    Key key,
    @required List<Photo> photos,
    @required PageController pageController,
  })  : _photos = photos,
        _pageController = pageController;

  final List<Photo> _photos;
  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    var currentPage;
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: PhotoViewGallery.builder(
                pageController: _pageController,
                itemCount: _photos.length,
                builder: (context, index) {
                  currentPage = index;
                  return PhotoViewGalleryPageOptions(
                    imageProvider: CachedNetworkImageProvider(
                      _photos[index].thumbnailUrl,
                    ),
                    minScale: PhotoViewComputedScale.contained * 0.8,
                    maxScale: PhotoViewComputedScale.covered * 2,
                  );
                },
                scrollPhysics: BouncingScrollPhysics(),
                backgroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Theme.of(context).canvasColor,
                ),
                enableRotation: false,
                loadingBuilder: (context, event) => Center(
                  child: Container(
                    width: 30.0,
                    height: 30.0,
                    child: CircularProgressIndicator(
                      value: event == null
                          ? 0
                          : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                    ),
                  ),
                ),
              ),
            ),
            // SizedBox(
            //   height: 150,
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Center(child: Text(_photos[currentPage].title)),
            //   ),
            // )
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton.extended(
          onPressed: () async {
            await StoragePermission().request(onPermanentDenied: () {
              Utils.showSnackBar("Permission Denied", context);
            }, onGranted: () async {
              final externalDir = await getExternalStorageDirectory();
              final taskId = FlutterDownloader.enqueue(
                url: _photos[currentPage].thumbnailUrl,
                savedDir: externalDir.path,
                fileName: _photos[currentPage].title,
                showNotification: true,
                openFileFromNotification: true,
              );
            });
          },
          label: const Text('Download'),
          icon: const Icon(Icons.save),
        ),
      ),
    );
  }
}
