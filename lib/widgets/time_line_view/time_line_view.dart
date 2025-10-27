import 'package:abtxt/model/report_models/WarpSearchModel.dart';
import 'package:flutter/material.dart';
import 'package:timelines_plus/timelines_plus.dart';

class TimeLineView extends StatefulWidget {
  final List<WarpTracking> jsonData;

  const TimeLineView({super.key, required this.jsonData});

  @override
  TimeLineViewState createState() => TimeLineViewState();
}

class TimeLineViewState extends State<TimeLineView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(color: Colors.grey[700]),
      child: Timeline.tileBuilder(
        theme: TimelineThemeData(
          color: const Color(0xffa33fff),
          indicatorTheme: const IndicatorThemeData(
            position: 0,
            size: 20.0,
          ),
          connectorTheme: const ConnectorThemeData(thickness: 2.5),
        ),
        builder: TimelineTileBuilder.connected(
          contentsAlign: ContentsAlign.alternating,
          itemCount: widget.jsonData.length,
          contentsBuilder: (context, index) {
            WarpTracking item = widget.jsonData[index];
            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 15,
                      offset: const Offset(-3, 6),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 4,
                    children: [
                      Text(
                        '${item.entryType ?? ""} ${item.ledgerName ?? ""}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text((item.newWarpId != null && item.newWarpId!.isNotEmpty) ? "New Id: ${item.newWarpId}" : ""),
                      Text((item.oldWarpId != null && item.oldWarpId!.isNotEmpty) ? "Old Id: ${item.newWarpId ?? ""}" : ""),
                    ],
                  ),
                ),
              ),
            );
          },
          oppositeContentsBuilder: (context, index) => const Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 75),
            child: Text(
              '21 October 2024',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey),
            ),
          ),
          indicatorBuilder: (context, index) {
            return const DotIndicator(
              color: Color(0xffa33fff),
              size: 28,
              child: Icon(
                Icons.delivery_dining_rounded,
                color: Colors.white,
                size: 16,
              ),
            );
          },
          connectorBuilder: (context, index, type) {
            return const SolidLineConnector(
              color: Color(0xffa33fff),
              thickness: 3,
            );
          },
        ),
      ),
    );
  }
}
