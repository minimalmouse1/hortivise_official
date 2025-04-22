import 'package:flutter/material.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:provider/provider.dart';

extension DataHandler<T> on Provider<T> {
  void consumerWithFutureBuilder(
    Widget child,
    Future<T> future,
    Function(Object data) successData,
  ) {
    Consumer<Provider<T>>(
      builder: (_, provider, __) => FutureBuilder(
        future: future,
        builder: (ctx, snapshots) {
          switch (snapshots.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppColors.colorGreen,
                  backgroundColor: AppColors.colorGrayLight,
                ),
              );
            default:
              if (snapshots.hasError) {
                return const Center(
                  child: Text(
                    'Something went wrong when connecting to server, please try again later!',
                  ),
                );
              } else {
                successData(snapshots.data!);
                return Container();
              }
          }
        },
      ),
    );
  }
}
