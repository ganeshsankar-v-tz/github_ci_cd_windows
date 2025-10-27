import 'package:flutter/material.dart';

//import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  var url =
      'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf';

  //final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('Yarn Purchase Report'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () async {
              if (await canLaunch(url)) {
                await launch(url);
              }
            },
          )
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Container(),
          ),
          /*Flexible(
            flex: 3,
            child: SfPdfViewer.network(
              url,
              key: _pdfViewerKey,
            ),
          ),*/
        ],
      ),
    );
  }
}

/*
,*/
