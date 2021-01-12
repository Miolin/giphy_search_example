import 'package:flutter/material.dart';
import 'package:giphy_search_example/src/models/gif_info.dart';

class GifCard extends StatelessWidget {
  final GifInfo gifInfo;

  const GifCard({
    Key key,
    @required this.gifInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              gifInfo.gifOriginalUrl,
              height: 150,
              width: 150,
              loadingBuilder: (context, child, progress) => progress == null
                  ? child
                  : Container(
                      height: 150,
                      width: 150,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
              errorBuilder: (context, _, __) => Container(
                height: 150,
                width: 150,
                child: Center(
                  child: Text('Failed load gif'),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gifInfo.title,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'By: ${gifInfo.user?.name ?? 'Unknown user'}\n\n${gifInfo.user?.description ?? ''}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
