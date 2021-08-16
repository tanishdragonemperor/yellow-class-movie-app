
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    final safeArea =
    EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);

    final provider = Provider.of<NavigationProvider>(context);
    final isCollapsed = provider.isCollapsed;

    return Container(
      width: isCollapsed ? MediaQuery.of(context).size.width * 0.2 : null,
      child: Drawer(

        child: Container(
          color: Color(0xFF1a2f45),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 24).add(safeArea),
                width: double.infinity,
                color: Colors.white12,
                child: buildHeader(isCollapsed),
              ),
              const SizedBox(height: 24),
              buildList(items: itemsFirst, isCollapsed: isCollapsed),
              const SizedBox(height: 24),
              Divider(color: Colors.white70),
              const SizedBox(height: 24),
              buildList(
                indexOffset: itemsFirst.length,
                items: itemsSecond,
                isCollapsed: isCollapsed,
              ),
              Spacer(),
              buildCollapseIcon(context, isCollapsed),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildList({
    bool isCollapsed,
    List<DrawerItem> items,
    int indexOffset = 0,
  }) =>
      ListView.separated(
        padding: isCollapsed ? EdgeInsets.zero : padding,
        shrinkWrap: true,
        primary: false,
        itemCount: items.length,
        separatorBuilder: (context, index) => SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = items[index];

          return buildMenuItem(
            isCollapsed: isCollapsed,
            text: item.title,
            icon: item.icon,
            onClicked: () => selectItem(context, indexOffset + index),
          );
        },
      );

  void selectItem(BuildContext context, int index) {
    final navigateTo = (page) => Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => page,
    ));

    Navigator.of(context).pop();

    switch (index) {
      case 0:
        navigateTo(GetStartedPage());
        break;
      case 1:
        navigateTo(SamplesPage());
        break;
      case 2:
        navigateTo(TestingPage());
        break;
      case 3:
        navigateTo(PerformancePage());
        break;
      case 4:
        navigateTo(DeploymentPage());
        break;
      case 5:
        navigateTo(ResourcesPage());
        break;
    }
  }

  Widget buildMenuItem({
    bool isCollapsed,
    String text,
    IconData icon,
    VoidCallback onClicked,
  }) {
    final color = Colors.white;
    final leading = Icon(icon, color: color);

    return Material(


      color: Colors.transparent,
      child: isCollapsed
          ? ListTile(
        title: leading,
        onTap: onClicked,
      )
          : ListTile(
        leading: leading,
        title: Text(text, style: TextStyle(color: color, fontSize: 16)),
        onTap: onClicked,
      ),
    );
  }

  Widget buildCollapseIcon(BuildContext context, bool isCollapsed) {
    final double size = 52;
    final icon = isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios;
    final alignment = isCollapsed ? Alignment.center : Alignment.centerRight;
    final margin = isCollapsed ? null : EdgeInsets.only(right: 16);
    final width = isCollapsed ? double.infinity : size;

    return Container(
      alignment: alignment,
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: Container(
            width: width,
            height: size,
            child: Icon(icon, color: Colors.white),
          ),
          onTap: () {
            final provider =
            Provider.of<NavigationProvider>(context, listen: false);

            provider.toggleIsCollapsed();
          },
        ),
      ),
    );
  }

  Widget buildHeader(bool isCollapsed) => isCollapsed
      // ? FlutterLogo(size: 48)
  ?ClipOval(
    child: Image.asset('assets/splash.png'),
  )
      : Row(
    children: [
      const SizedBox(width: 24),
      // FlutterLogo(size: 48),
      Container(
        width: 200,
          height: 100,
          child: CircleAvatar(child: Image.asset('assets/splash.png'),backgroundColor: Colors.yellowAccent,)),
      const SizedBox(width: 16),

    ],
  );

}
class NavigationProvider extends ChangeNotifier {
  bool _isCollapsed = false;

  bool get isCollapsed => _isCollapsed;

  void toggleIsCollapsed() {
    _isCollapsed = !isCollapsed;

    notifyListeners();
  }
}
class DrawerItem {
  final String title;
  final IconData icon;

  const DrawerItem({
    this.title,
    this.icon,
  });
}
final itemsFirst = [
  DrawerItem(title: 'Web App', icon: Icons.people),
  DrawerItem(title: 'Samples & Tutorials', icon: Icons.phone_android),
  DrawerItem(title: 'Testing & Debugging', icon: Icons.settings_applications),
  DrawerItem(title: 'Settings', icon: Icons.build),
];

final itemsSecond = [
  DrawerItem(title: 'Deployment', icon: Icons.cloud_upload),
  DrawerItem(title: 'Resources', icon: Icons.extension),

];
class DeploymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Deployment'),
      centerTitle: true,
      backgroundColor: Colors.teal,
    ),

  );
}
class GetStartedPage extends StatefulWidget {
  @override
  _GetStartedPageState createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage>{
  openURL()async{

      await launch("https://www.yellowclass.com/");

  }
  @override
  Widget build(BuildContext context) => Scaffold(

    appBar: AppBar(
      title: Text('Web App'),
      centerTitle: true,
      backgroundColor: Colors.green,
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              child: Container(decoration: BoxDecoration(
                shape: BoxShape.circle
              ),
                child: MaterialButton(color: Colors.yellowAccent

                    ,onPressed:(){
                    print("LInk Pressed");
                  openURL();
                    },child: Text("🌐 Visit Web App Yellow Class WebApp"), ),
              ),
            ),
          ],
        )
      ],
    ),
  );
}
class PerformancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Settings'),
      centerTitle: true,
      backgroundColor: Colors.indigo,
    ),
  );
}
class ResourcesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Resources'),
      centerTitle: true,
      backgroundColor: Colors.pink,
    ),
  );
}

class SamplesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Samples & Tutorials'),
      centerTitle: true,
      backgroundColor: Colors.orange,
    ),
  );
}
class TestingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(

    appBar: AppBar(
      title: Text('Testing & Debugging'),
      centerTitle: true,
      backgroundColor: Colors.red,
    ),
  );
}