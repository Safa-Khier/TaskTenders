import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tasktender_frontend/utils/app.theme.dart';

class InboxScreenPlaceholder extends StatelessWidget {
  const InboxScreenPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Shimmer.fromColors(
        baseColor:
            Theme.of(context).extension<CustomThemeExtension>()?.baseShimmer ??
                Colors.grey[100]!,
        highlightColor: Theme.of(context)
                .extension<CustomThemeExtension>()
                ?.highlightShimmer ??
            Colors.grey[50]!,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final itemHeight = 70.0; // Approximate height of each item
              final itemCount = (constraints.maxHeight / itemHeight).ceil() -
                  2; // Calculate how many items fit vertically

              return Column(
                children: List.generate(itemCount, (index) {
                  return Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: Row(
                        spacing: 15,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              height: 60,
                              width: 60,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(35)),
                                color: Colors.white,
                              ),
                              child: null),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 10,
                            children: [
                              const SizedBox(),
                              Container(
                                  height: 10,
                                  width: 80,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: Colors.white,
                                  ),
                                  child: null),
                              Container(
                                  height: 10,
                                  width: 120,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: Colors.white,
                                  ),
                                  child: null),
                            ],
                          ),
                        ],
                      ));
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}
