import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageWidget extends StatelessWidget {
  final File image;
  final ValueChanged<ImageSource> onClicked;

  const ImageWidget({Key? key, required this.image, required this.onClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buildCircle({
      required Widget child,
      required double all,
      required Color color,
    }) =>
        ClipOval(
          child: Container(
            padding: EdgeInsets.all(all),
            color: color,
            child: child,
          ),
        );

    Widget buildEditIcon() => buildCircle(
          color: Colors.white,
          all: 3,
          child: buildCircle(
            color: Color(0xFF31AFE1),
            all: 8,
            child: Icon(
              Icons.edit,
              size: 20,
              color: Colors.white,
            ),
          ),
        );

    Future<ImageSource?> showImageSource(BuildContext context) async {
      if (Platform.isIOS) {
        return showCupertinoModalPopup<ImageSource>(
          context: context,
          builder: (context) => CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                child: Text('Camera'),
                onPressed: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              CupertinoActionSheetAction(
                child: Text('Gallery'),
                onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
            ],
          ),
        );
      } else {
        return showModalBottomSheet(
          context: context,
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Gallery'),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              )
            ],
          ),
        );
      }
    }

    Widget buildImage(BuildContext context) {
      final imagePath = this.image.path;
      final image = imagePath.contains('https://')
          ? NetworkImage(imagePath)
          : FileImage(File(imagePath));

      return ClipOval(
        child: Material(
          color: Colors.transparent,
          child: Ink.image(
            image: image as ImageProvider,
            fit: BoxFit.cover,
            width: 160,
            height: 160,
            child: InkWell(
              onTap: () async {
                final source = await showImageSource(context);
                if (source == null) return;
                onClicked(source);
              },
            ),
          ),
        ),
      );
    }

    return Center(
      child: Stack(
        children: [
          buildImage(context),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(),
          ),
        ],
      ),
    );
  }
}
