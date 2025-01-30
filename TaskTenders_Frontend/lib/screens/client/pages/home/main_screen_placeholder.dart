import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tasktender_frontend/utils/app.theme.dart';

class ShimmerLoadingEffect extends StatelessWidget {
  const ShimmerLoadingEffect({super.key});

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
              final itemHeight = 180.0; // Approximate height of each item
              final itemCount = (constraints.maxHeight / itemHeight).ceil() -
                  1; // Calculate how many items fit vertically

              return Column(
                children: List.generate(itemCount, (index) {
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              height: 10,
                              width: 120,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: Colors.white,
                              ),
                              child: null),
                          const Expanded(
                            child: SizedBox(),
                          ),
                          Container(
                              height: 10,
                              width: 50,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: Colors.white,
                              ),
                              child: null),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: Container(
                                height: 130,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  color: Colors.white,
                                ),
                                child: null),
                          ),
                          Expanded(
                            child: Container(
                                height: 130,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  color: Colors.white,
                                ),
                                child: null),
                          ),
                          Expanded(
                            child: Container(
                                height: 130,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  color: Colors.white,
                                ),
                                child: null),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}
