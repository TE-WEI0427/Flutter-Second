library my_prj.globals;

import 'package:localstorage/localstorage.dart';

///定義前往指定頁面
final LocalStorage goPage = LocalStorage("goPage");

///使用者登入身分
final LocalStorage token = LocalStorage("token");

///使用者登入信箱
final LocalStorage email = LocalStorage("email");
