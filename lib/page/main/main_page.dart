import 'package:android_tool/page/android_log/android_log_page.dart';
import 'package:android_tool/page/common/base_page.dart';
import 'package:android_tool/page/feature_page/feature_page.dart';
import 'package:android_tool/page/flie_manager/file_manager_page.dart';
import 'package:android_tool/page/main/devices_model.dart';
import 'package:android_tool/widget/adb_setting_dialog.dart';
import 'package:android_tool/widget/text_view.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'main_view_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends BasePage<MainPage, MainViewModel> {
  @override
  createViewModel() {
    return MainViewModel(context);
  }

  @override
  initState() {
    super.initState();
    viewModel.init();
  }

  @override
  Widget contentView(BuildContext context) {
    var select = context
        .watch<MainViewModel>()
        .selectedTab;
    return Row(
      children: <Widget>[
        DropTarget(
          onDragDone: (details) {
            viewModel.onDragDone(details);
          },
          child: Container(
            color: Colors.blue.withOpacity(0.05),
            width: 200,
            child: Column(
              children: [
                const SizedBox(height: 20),
                _logoView(),
                _devicesView(),
                const SizedBox(height: 20),
                ..._leftItemsView()
              ],
            ),
          ),
        ),
        // const VerticalDivider(width: 1),
        Expanded(
          child: Column(
            children: [
              // packageNameView(context, select),
              Expanded(
                child: _buildBoy(select),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBoy(MainTab tab) {
    if (tab.isHome) {
      return FeaturePage(
        deviceId: viewModel.deviceId,
      );
    } else if (tab.isFile) {
      return FileManagerPage(viewModel.deviceId);
    } else if (tab.isLogCat) {
      return AndroidLogPage(deviceId: viewModel.deviceId);
    } else if (tab.isSetting) {
      return AdbSettingDialog(viewModel.adbPath);
    } else {
      return Container();
    }
  }


  Widget _logoView() {
    return Image.asset("images/app_icon.png", width: 60, height: 60);
  }

  Widget _devicesView() {
    return InkWell(
      onTap: () {
        viewModel.devicesSelect(context);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 10),
          Selector<MainViewModel, DevicesModel?>(
            selector: (context, viewModel) => viewModel.device,
            builder: (context, device, child) {
              return Container(
                constraints: const BoxConstraints(
                  maxWidth: 150,
                ),
                child: Text(
                  device?.itemTitle ?? "未连接设备",
                  overflow: TextOverflow.visible,
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 12,
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            width: 5,
          ),
          const Icon(
            Icons.arrow_drop_down,
            color: Color(0xFF666666),
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }


  List<Widget> _leftItemsView() {
    var itemList = <Widget>[];
    for (var tab in MainTab.values) {
      var widget = Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            viewModel.onLeftItemClick(tab);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: tab == viewModel.selectedTab
                  ? Colors.blue.withOpacity(0.32)
                  : Colors.transparent,
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Row(
              children: <Widget>[
                SvgPicture.asset(
                  tab.assetName,
                  width: 23,
                  height: 23,
                ),
                const SizedBox(width: 10),
                TextView(tab.title),
              ],
            ),
          ),
        ),
      );
      itemList.add(widget);
    }
    return itemList;
  }
}
