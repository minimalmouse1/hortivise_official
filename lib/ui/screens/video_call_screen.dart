import 'package:flutter/material.dart';
import 'package:horti_vige/data/services/video_service.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class DemoAppHome extends StatefulWidget {
  const DemoAppHome({
    super.key,
  });
  static const String routeName = 'DemoAppHome';

  @override
  State<DemoAppHome> createState() => _DemoAppHomeState();
}

class _DemoAppHomeState extends State<DemoAppHome> {
  final bool isMute = false;
  final bool isVideoOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamCallContainer(
        call: VideoService.instance.call,
        callConnectOptions: CallConnectOptions(
          camera: TrackOption.enabled(),
          microphone: TrackOption.enabled(),
        ),
        callContentBuilder: (
          context,
          call,
          callState,
        ) {
          return StreamCallContent(
            call: call,
            callState: callState,
            layoutMode: ParticipantLayoutMode.spotlight,
            callAppBarBuilder: (context, call, callState) {
              return const PreferredSize(
                preferredSize: Size.zero,
                child: SizedBox(),
              );
            },
            callControlsBuilder: (
              context,
              call,
              callState,
            ) {
              final localParticipant = callState.localParticipant!;
              return StreamCallControls(
                elevation: 0,
                borderRadius: BorderRadius.zero,
                backgroundColor: Colors.transparent,
                options: [
                  ToggleMicrophoneOption(
                    call: call,
                    localParticipant: localParticipant,
                    disabledMicrophoneIconColor: AppColors.colorGreen,
                  ),
                  ToggleCameraOption(
                    call: call,
                    localParticipant: localParticipant,
                    enabledCameraBackgroundColor: AppColors.colorGreen,
                    enabledCameraIconColor: AppColors.colorWhite,
                  ),
                  CallControlOption(
                    icon: const Icon(Icons.chat),
                    onPressed: () {
                      // Open your chat window
                    },
                    iconColor: AppColors.colorGreen,
                  ),
                  LeaveCallOption(
                    call: call,
                    onLeaveCallTap: () {
                      call.leave();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
