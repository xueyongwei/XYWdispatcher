# XYWdispatcher
根据url地址跳转到相应界面，通过plist关联host与viewController。
## 使用场景
- 在网页里点击打开app，或者跳转到app里的详情页。将截获url，打开指定的控制器，并传入ViewController所需参数。
- 收到推送，或者Socket等消息，跳转到消息列表或者内容详情。（需要servere配合传入uri字段。）
- 应用内直接跳转到某个VC中去，无需导入头文件，直接openURl即可打开特定ViewController。
- 例如 ：zuoyoupk://pkdetail?pkID=10010 打开左右app，并跳转pkderailViewController详情页，传入参数pkID为10010。

## 使用方法
1. 拖入XYWdispatcher文件夹到工程
2. 在XYWdispatcherRouter.plist路由表里添加host和viewController的对应关系，以及参数的对应关系（防止参数不一致或参数出现关键字）。
3. 在appdelegate里添加方法，或扩展方法，传入当前应用的scheme
<pre><code>
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
  
    {
      if ([XYWdispatcher HandleOpenURL:url withScheme:@"XYWdispatcher"]) {
         return YES;
     }else{//其他sdk代码
         return NO;
      }
   //    return [XYWdispatcher HandleOpenURL:url withScheme:@"roter"];
   }
</code></pre>

## 测试效果
1. 网页打开应用：使用浏览器输入XYWdispatcher://test1ViewController?str=hahahha即可打开应用并跳转到test1界面且传入str为“hahahha”
2. 应用内跳转控制器：使用：[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"XYWdispatcher://test1ViewController?str=hahahha"]];
3. 推送或socket：接收到消息后，以5的方法打开uri即可。
## 容错
- 遇到不识别的host和参数，都会弹窗提示“需要升级才能完成操作”，防止新版本的url旧版本无法识别而造成不可预知的错误。
