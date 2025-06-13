import 'package:android_tool/page/common/base_page.dart';
import 'package:android_tool/page/common/icon_font.dart';
import 'package:android_tool/page/feature_page/feature_view_model.dart';
import 'package:android_tool/widget/text_view.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeaturePage extends StatefulWidget {
  final String deviceId;

  const FeaturePage({
    Key? key,
    required this.deviceId,
  }) : super(key: key);

  @override
  _FeaturePageState createState() => _FeaturePageState();
}

class _FeaturePageState extends BasePage<FeaturePage, FeatureViewModel> {
  @override
  createViewModel() {
    return FeatureViewModel(
      context,
      widget.deviceId,
    );
  }

  @override
  void initState() {
    super.initState();
    viewModel.init();
  }

  @override
  Widget contentView(BuildContext context) {
    return DropTarget(
      onDragDone: (details) {
        viewModel.onDragDone(details);
      },
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildCommonFeaturesCard(),
                    _buildAppFeaturesCard(context),
                    _buildSystemFeaturesCard(),
                    _buildKeyFeaturesCard(),
                    _buildScreenFeaturesCard(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommonFeaturesCard() {
    return _featureCardView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("常用功能"),
          const SizedBox(height: 5),
          _buildButtonRow([
            _buildFeatureButton(IconFont.install, "安装应用", viewModel.install),
            _buildFeatureButton(IconFont.input, "输入文本", viewModel.inputText),
            _buildFeatureButton(
                IconFont.screenshot, "截图保存到电脑", viewModel.screenshot),
            _buildFeatureButton(IconFont.currentActivity, "查看当前Activity",
                viewModel.getForegroundActivity),
          ]),
        ],
      ),
    );
  }

  Widget _buildAppFeaturesCard(BuildContext context) {
    return _featureCardView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(child: _buildSectionTitle("应用相关")),
              _buildPackageNameSelector(context),
            ],
          ),
          const SizedBox(height: 5),
          _buildButtonRow([
            _buildFeatureButton(
                IconFont.uninstall, "卸载应用", viewModel.uninstallApk),
            _buildFeatureButton(IconFont.start, "启动应用", viewModel.startApp),
            _buildFeatureButton(IconFont.stop, "停止运行", viewModel.stopApp),
            _buildFeatureButton(IconFont.rerun, "重启应用", viewModel.restartApp),
          ]),
          _buildButtonRow([
            _buildFeatureButton(IconFont.clean, "清除数据", viewModel.clearAppData),
            _buildFeatureButton(IconFont.cleanRerun, "清除数据并重启应用", () async {
              await viewModel.clearAppData();
              await viewModel.startApp();
            }),
            _buildFeatureButton(
                IconFont.reset, "重置权限", viewModel.resetAppPermission),
            _buildFeatureButton(IconFont.resetRerun, "重置权限并重启应用", () async {
              await viewModel.stopApp();
              await viewModel.resetAppPermission();
              await viewModel.startApp();
            }),
          ]),
          _buildButtonRow([
            _buildFeatureButton(
                IconFont.authorize, "授权所有权限", viewModel.grantAppPermission),
            _buildFeatureButton(
                IconFont.apkPath, "查看应用安装路径", viewModel.getAppInstallPath),
            _buildFeatureButton(
                IconFont.save, "保存应用APK到电脑", viewModel.saveAppApk),
            const Spacer(flex: 1),
          ]),
        ],
      ),
    );
  }

  Widget _buildSystemFeaturesCard() {
    return _featureCardView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("系统相关"),
          const SizedBox(height: 5),
          _buildButtonRow([
            _buildFeatureButton(
                IconFont.screenRecording, "开始录屏", viewModel.recordScreen),
            _buildFeatureButton(IconFont.stopRecording, "结束录屏保存到电脑",
                viewModel.stopRecordAndSave),
            _buildFeatureButton(
                IconFont.android, "查看AndroidId", viewModel.getAndroidId),
            _buildFeatureButton(
                IconFont.version, "查看系统版本", viewModel.getDeviceVersion),
          ]),
          _buildButtonRow([
            _buildFeatureButton(
                IconFont.ip, "查看IP地址", viewModel.getDeviceIpAddress),
            _buildFeatureButton(
                IconFont.macAddress, "查看Mac地址", viewModel.getDeviceMac),
            _buildFeatureButton(IconFont.restart, "重启手机", viewModel.reboot),
            _buildFeatureButton(
                IconFont.systemProperty, "查看系统属性", viewModel.getSystemProperty),
          ]),
          _buildButtonRow([
            _buildFeatureButton(
                IconFont.home, "查看wifi信息", viewModel.getWifiInfo),
            const Spacer(flex: 3),
          ]),
        ],
      ),
    );
  }

  Widget _buildKeyFeaturesCard() {
    return _featureCardView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("按键相关"),
          const SizedBox(height: 5),
          _buildButtonRow([
            _buildFeatureButton(IconFont.home, "HOME键", viewModel.pressHome),
            _buildFeatureButton(IconFont.back, "返回键", viewModel.pressBack),
            _buildFeatureButton(IconFont.menu, "菜单键", viewModel.pressMenu),
            _buildFeatureButton(IconFont.power, "电源键", viewModel.pressPower),
          ]),
          _buildButtonRow([
            _buildFeatureButton(
                IconFont.volumeUp, "增加音量", viewModel.pressVolumeUp),
            _buildFeatureButton(
                IconFont.volumeDown, "降低音量", viewModel.pressVolumeDown),
            _buildFeatureButton(IconFont.mute, "静音", viewModel.pressVolumeMute),
            _buildFeatureButton(
                IconFont.switchApp, "切换应用", viewModel.pressSwitchApp),
          ]),
          _buildButtonRow([
            _buildFeatureButton(IconFont.remoteControl, "遥控器",
                () => viewModel.showRemoteControlDialog(context)),
            const Spacer(flex: 3),
          ]),
        ],
      ),
    );
  }

  Widget _buildScreenFeaturesCard() {
    return _featureCardView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("屏幕输入"),
          const SizedBox(height: 5),
          _buildButtonRow([
            _buildFeatureButton(
                IconFont.swipeUp, "向上滑动", viewModel.pressSwipeUp),
            _buildFeatureButton(
                IconFont.swipeDown, "向下滑动", viewModel.pressSwipeDown),
            _buildFeatureButton(
                IconFont.swipeLeft, "向左滑动", viewModel.pressSwipeLeft),
            _buildFeatureButton(
                IconFont.swipeRight, "向右滑动", viewModel.pressSwipeRight),
          ]),
          _buildButtonRow([
            _buildFeatureButton(IconFont.click, "屏幕点击", viewModel.pressScreen),
            const Spacer(flex: 3),
          ]),
        ],
      ),
    );
  }

  Container _featureCardView({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Ink(
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: child,
      ),
    );
  }

  Widget _buildButtonRow(List<Widget> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: buttons,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
              color: viewModel.getColor(title),
              borderRadius: BorderRadius.circular(5),
            )),
        const SizedBox(width: 5),
        TextView(title),
      ],
    );
  }

  Widget _buildFeatureButton(
      IconData icon, String title, Function() onPressed) {
    Color color = viewModel.getColor(title);
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            // color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [
                        color.withOpacity(0.5),
                        color.withOpacity(1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )),
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              TextView(
                title,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPackageNameSelector(BuildContext context) {
    return InkWell(
      onTap: () {
        viewModel.packageSelect(context);
      },
      onHover: (value) {},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 10),
          Selector<FeatureViewModel, String>(
            selector: (context, viewModel) => viewModel.packageName,
            builder: (context, packageName, child) {
              return Container(
                constraints: const BoxConstraints(minHeight: 20),
                child: TextView(
                  packageName.isEmpty ? "未选择调试应用" : packageName,
                  color: const Color(0xFF666666),
                ),
              );
            },
          ),
          const SizedBox(
            width: 5,
          ),
          const Icon(
            Icons.expand_more,
            color: Color(0xFF999999),
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }
}
