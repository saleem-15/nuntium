// import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

// class MainView extends StatelessWidget {
//   const MainView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return willPopScope(
//       child: GetBuilder<MainController>(
//         builder: (controller) {
//           return PersistentTabView(
//             context,
//             controller: controller.persistentTabController,
//             backgroundColor: Colors.white,
//             navBarStyle: NavBarStyle.style5,
//             confineInSafeArea: true,
//             navBarHeight: ManagerHeight.h90,
//             decoration: NavBarDecoration(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(
//                   ManagerRadius.r16,
//                 ),
//                 topRight: Radius.circular(
//                   ManagerRadius.r16,
//                 ),
//               ),
//             ),
//             screens: controller.screens,
//             items: controller.bottomNavBarItems,
//           );
//         },
//       ),
//     );
//   }
// }