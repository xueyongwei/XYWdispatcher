# XYWdispatcher
通过注册scheme，可直接给出URL，通过url地址跳转到相应界面，同时支持传值。
在使用过程中，建议遵守URLComponents规则。

这里就粗略的举个例子来说明url的组成：

https://johnny:p4ssw0rd@www.example.com:443/script.ext;param=value?query=value#ref

这个url拆解后：

组件名称  |  值
| - | :-: | -: |
scheme  |  https
user  |  johnny
password  |  p4ssw0rd
host  |  www.example.com
port   | 443
path  |  /script.ext
pathExtension  |  ext
pathComponents  |  ["/", "script.ext"]
parameterString  |  param=value
query  |  query=value
fragment  |  ref

## 使用场景
- 在网页里点击链接打开app，或者跳转到app里的某个详情页界面。
- 收到推送，或者Socket等消息，点击后跳转到消息列表或者内容详情。
- APP内无需导入头文件，直接跳转到某个VC中去。
## 使用示例
app分享一组对战，别人通过网页打开，点击“对战详情”时打开app，并且到达此场pk的详情界面：
只需要在网页里的按钮添加点击url:< zuoyoupk://pkdetail?pkID=10010 >
 当在网页里点击时会发生：
1. 打开左右app
2. 跳转pkderailViewController详情页
3. 传入参数pkID为10010,加载id为10010的比赛数据
4. 显示正确的内容

## 使用方法
1. 拖入XYWdispatcher文件夹到工程
2. 在XYWdispatcherRouter.plist路由表里添加host和viewController的对应关系，以及参数的对应关系（为了：跨平台统一，保证URL的path参数对应到控制器的className，也可消除URL参数里包含OC的关键字）。
3. 在appdelegate里的```-(Bool)application openURL```方法捕获scheme
```
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
  
    {
      if ([XYWdispatcher HandleOpenURL:url withScheme:@"XYWdispatcher"]) {
         return YES;
     }else{//其他sdk代码
         return NO;
      }
   //    return [XYWdispatcher HandleOpenURL:url withScheme:@"roter"];
   }
```

## 测试效果
1. 网页打开应用：使用浏览器输入XYWdispatcher://test1ViewController?str=hahahha即可打开应用并跳转到test1界面且传入str为“hahahha”
2. 应用内跳转控制器：使用：[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"XYWdispatcher://test1ViewController?str=hahahha"]];
3. 推送或socket：接收到消息后，获取uri，以[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"XYWdispatcher://test1ViewController?str=hahahha"]]的方法打开uri即可。

## 容错
- 遇到不识别的host和参数，会弹窗提示“需要升级才能完成操作”，防止新版本的url在较早版本的APP里无法识别，而造成不可预知的错误。
