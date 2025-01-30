import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tasktender_frontend/utils/app.theme.dart';

class CardScreenPlaceholder extends StatelessWidget {
  const CardScreenPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
        itemBuilder: (_, index) {
          return Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .extension<CustomThemeExtension>()
                    ?.listItemBackground,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey.withAlpha(80),
                  width: 0.5,
                ),
              ),
              margin: const EdgeInsets.only(bottom: 10),
              child: Shimmer.fromColors(
                baseColor: Theme.of(context)
                        .extension<CustomThemeExtension>()
                        ?.baseShimmer ??
                    const Color(0xFFF5F5F5),
                highlightColor: Theme.of(context)
                        .extension<CustomThemeExtension>()
                        ?.highlightShimmer ??
                    const Color(0xFFFAFAFA),
                child: Column(
                  children: [
                    // const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 10,
                              width: 80,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: Colors.white,
                              ),
                              child: null,
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 10,
                              width: 150,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: Colors.white,
                              ),
                              child: null,
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              height: 10,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: Colors.white,
                              ),
                              child: null,
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                        padding: EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey,
                              width: 0.33,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 10,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: Colors.white,
                              ),
                              child: null,
                            ),
                            const Spacer(),
                            Icon(
                              Icons.more_horiz,
                              size: 20,
                            ),
                          ],
                        ))
                  ],
                ),
              ));
        });
  }
}
