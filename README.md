# XYWdispatcher
根据url地址跳转到相应界面
## 使用场景
- 在网页里点击打开app，或者跳转到app里的详情页。将截获url，打开指定的控制器，并传入ViewController所需参数。
- 收到推送，或者Socket等消息，跳转到消息列表或者内容详情。（需要servere配合传入uri字段。）
- 应用内直接跳转到某个VC中去，无需导入头文件，直接openURl即可打开特定ViewController。
- 例如 ：zuoyoupk://pkdetail?pkID=10010 打开左右app，并跳转pkderailViewController详情页，传入参数pkID为10010。

## 使用方法
1. 拖入XYWdispatcher文件夹到工程
2. 在appdelegate里添加方法，或扩展方法
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
  
