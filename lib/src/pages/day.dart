import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trancend/src/modal/modal_sheet_helper.dart';
import 'package:trancend/src/ui/clay/clay_container.dart';

const color1 = Color.fromRGBO(244, 236, 236, 1); // Very light khaki
const color2 = Color.fromARGB(255, 247, 238, 230); // Light peach
const textColor = Color.fromARGB(153, 46, 43, 43);

class TimelineEntry {
  final String title;
  final String description;
  final Duration duration;
  final String? imageUrl;
  final DateTime time;

  TimelineEntry({
    required this.title,
    required this.description,
    required this.duration,
    required this.time,
    this.imageUrl,
  });
}

class TimelineCard extends StatelessWidget {
  final TimelineEntry entry;
  final bool isFirst;
  final bool isLast;
  final Color backgroundColor;

  const TimelineCard({
    Key? key,
    required this.entry,
    required this.isFirst,
    required this.isLast,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return GestureDetector(
      onTap: () {
        // Go directly to the modality page (index 3)
        ModalSheetHelper.showModalSheet(context, initialPage: 3);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline gutter with dot and line
            SizedBox(
              width: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 170,
                    child: Stack(
                      children: [
                        // Connecting line
                        if (isFirst)
                          Positioned(
                            top: 50,
                            left: 24,
                            child: ClayContainer(
                              color: backgroundColor,
                              parentColor: color2,
                              height: 300,
                              width: 2,
                              emboss: true,
                              spread: 2,
                              depth: 40,
                            ),
                          ),
                        if (!isLast && !isFirst)
                          Positioned(
                            top: 0,
                            left: 24,
                            child: ClayContainer(
                              color: backgroundColor,
                              parentColor: color2,
                              height: 300,
                              width: 2,
                              emboss: true,
                              spread: 2,
                              depth: 40,
                            ),
                          ),
                        if (isLast)
                          Positioned(
                            top: 0,
                            left: 24,
                            child: ClayContainer(
                              color: backgroundColor,
                              parentColor: color2,
                              height: 50,
                              width: 2,
                              emboss: true,
                              spread: 2,
                              depth: 40,
                            ),
                          ),
                        // Dot
                        Positioned(
                          top: 50,
                          left: 10,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ClayContainer(
                                color: backgroundColor,
                                parentColor: color2,
                                height: 30,
                                width: 30,
                                borderRadius: 15,
                                emboss: true,
                                spread: 2,
                                depth: 40,
                              ),
                              if (isFirst)
                                ClayContainer(
                                  width: 24,
                                  height: 24,
                                  color: color1,
                                  // color: Theme.of(context).colorScheme.primary,
                                  parentColor: backgroundColor,
                                  borderRadius: 12,
                                  depth: 60,
                                  spread: 2,
                                  emboss: false,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Card content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0, bottom: 24.0),
                child: ClayContainer(
                  color: backgroundColor,
                  parentColor: color2,
                  height: 140,
                  borderRadius: 12,
                  depth: 14,
                  spread: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                entry.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: textColor,
                                    ),
                              ),
                              const SizedBox(height: 12),
                              _buildTimeInfo(context),
                            ],
                          ),
                        ),
                        if (entry.imageUrl != null) ...[
                          const SizedBox(width: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              entry.imageUrl!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
        );
      },
    );
  }

  Widget _buildTimeInfo(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.access_time,
          size: 16,
          color: textColor,
        ),
        const SizedBox(width: 4),
        Text(
          '${entry.duration.inMinutes} minutes',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
        ),
        // const SizedBox(width: 12),
        // const Icon(
        //   Icons.schedule,
        //   size: 16,
        //   color: Colors.black45,
        // ),
        // const SizedBox(width: 4),
        // Text(
        //   '${entry.time.hour.toString().padLeft(2, '0')}:${entry.time.minute.toString().padLeft(2, '0')}',
        //   style: Theme.of(context).textTheme.bodySmall?.copyWith(
        //     color: Colors.black45,
        //     fontWeight: FontWeight.w500,
        //   ),
        // ),
      ],
    );
  }
}

class Day extends StatelessWidget {
  const Day({
    Key? key,
  }) : super(key: key);

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color1, // Very light khaki
            color2, // Light peach
          ],
          stops: [0.0, 0.15], // Fade only happens in top 15%
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Expanded(
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white10,
                      Colors.white70,
                    ],
                    stops: [0.0, 0.9], // Fade only happens in top 15%
                  ).createShader(bounds),
                  child: Text(
                    '${_getGreeting()}',
                    style: GoogleFonts.titilliumWeb(
                      textStyle: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 24.0),
            //   child: Expanded(
            //     child: ShaderMask(
            //       shaderCallback: (bounds) => LinearGradient(
            //         begin: Alignment.topCenter,
            //         end: Alignment.bottomCenter,
            //         colors: [
            //           Colors.white24,
            //           Colors.white60,
            //         ],
            //         stops: [0.0, 0.15], // Fade only happens in top 15%
            //       ).createShader(bounds),
            //       child: AutoSizeText(
            //         '${userName} ',
            //         maxLines: 1,
            //         style: Theme.of(context).textTheme.displayLarge?.copyWith(
            //               color: Theme.of(context).colorScheme.onSurface,
            //               fontWeight: FontWeight.bold,
            //             ),
            //       ),

            //       // AutoSizeText(
            //       //   '${userName} waejklfawl',
            //       //   style: GoogleFonts.titilliumWeb(
            //       //     textStyle: const TextStyle(
            //       //       // fontSize: 80,
            //       //       fontWeight: FontWeight.w800,
            //       //       color: Colors.white,
            //       //     ),
            //       //   ),
            //       // ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 34.0),
              child: AutoSizeText(
                'Start your day',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: textColor.withOpacity(.5),
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Expanded(
              child: _TimelineView(
                entries: [
                  TimelineEntry(
                    title: 'Morning Meditation',
                    description:
                        'Begin your day with a guided meditation focused on clarity and intention setting',
                    duration: const Duration(minutes: 15),
                    time: DateTime.now().add(const Duration(hours: 1)),
                    // imageUrl: 'assets/images/meditation.jpg',
                  ),
                  TimelineEntry(
                    title: 'Cognitive Hypnotherapy',
                    description:
                        'Deep relaxation session focused on building confidence and reducing anxiety',
                    duration: const Duration(minutes: 30),
                    time: DateTime.now().add(const Duration(hours: 3)),
                    // imageUrl: 'assets/images/hypnotherapy.jpg',
                  ),
                  TimelineEntry(
                    title: 'Evening Breathwork',
                    description:
                        'Wind down with calming breath exercises to prepare for restful sleep',
                    duration: const Duration(minutes: 20),
                    time: DateTime.now().add(const Duration(hours: 8)),
                    // imageUrl: 'assets/images/breathwork.jpg',
                  ),
                  TimelineEntry(
                    title: 'Sleep Programming',
                    description:
                        'Drift into deep sleep with subconscious reprogramming for positive change',
                    duration: const Duration(minutes: 45),
                    time: DateTime.now().add(const Duration(hours: 10)),
                    // imageUrl: 'assets/images/sleep.jpg',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _TimelineView extends StatelessWidget {
  final List<TimelineEntry> entries;

  const _TimelineView({
    Key? key,
    required this.entries,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: entries.length,
      padding: const EdgeInsets.only(top: 16),
      itemBuilder: (context, index) {
        return TimelineCard(
          entry: entries[index],
          isFirst: index == 0,
          isLast: index == entries.length - 1,
          backgroundColor: color2,
        );
      },
    );
  }
}
