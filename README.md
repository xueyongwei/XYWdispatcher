# XYWdispatcher
根据url地址跳转到相应界面
##作用简介
- 通过浏览器打开应用，并跳转到指定界面
- 收到推送，打开指定界面
- 例如 ：zuoyoupk://pkdetail?pkID=10010 打开左右app，并观看pkID为10010的详情页。

##使用背景
- 在网页里点击打开app，或者跳转到app里的详情页，直接截获url，打开控制器，并传入参数。
- 收到推送，或者Socket等消息，跳转到消息列表或者内容详情。需要servere配合传入userInfo的uri字段。

##使用方法
1. 拖入XYWdispatcher文件夹到工程
2. 在appdelegate里添加方法，或扩展方法

##
