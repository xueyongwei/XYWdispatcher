//
//  XYWdispatcher.m
//  roter
//
//  Created by xueyongwei on 16/11/14.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "XYWdispatcher.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
@interface XYWdispatcher()
@property (class,nonatomic,copy)NSString *scheme;
@property (class,nonatomic,strong,readonly) NSMutableDictionary *routerDictionary;
@end
@implementation XYWdispatcher

static NSString* _scheme = nil;
static NSMutableDictionary* _paramDic = nil;

+ (NSString*)scheme{
    return _scheme;
}
+ (void)setScheme:(NSString *)scheme{
    _scheme = scheme;
}

// 路由信息
+(NSMutableDictionary *)routerDictionary{
    if (_paramDic == nil){
        _paramDic = [self defaultRouterPlistDictionary];
    }
    return _paramDic;
}

+ (void) registerScheme:(NSString *)scheme{
    self.scheme = scheme;
}

+(BOOL) handleURL:(NSURL *) url{
    if (self.scheme != nil && [url.scheme isEqualToString:self.scheme]){
        [self nativeHandleUrl:url];
        return true;
    }else{
        return false;
    }
}
+(void)nativeHandleUrl:(NSURL *)url{
    NSString *host = [url host];
    NSString *path = [url path];
    NSArray *itms = [[url query] componentsSeparatedByString:@"&"];
    
    [self jumpVC:host withquerys:itms];
}
/**
 *  控制器的跳转
 *
 *  @param host   url的host
 *  @param querys 请求参数
 */
+ (void)jumpVC:(NSString *)host withquerys:(NSArray *)querys
{
    NSDictionary *hostInfo  = [self getInfoOfHost:host];
    
    NSString *vcClz = [self getClassNameInHostInfo:hostInfo];
    
    if (vcClz == nil){
        NSLog(@"无路由信息%@",vcClz);
        UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"需要升级才能完成操作" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alv show];
        return;
    }
    
    id myObj = [[NSClassFromString(vcClz) alloc] init];
    
    
    
    if (myObj == nil) {
        NSLog(@"不支持的类%@",vcClz);
        UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"需要升级才能完成操作" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alv show];
        return;
    }else{
        for (NSString *itm in querys) {
            
            NSArray *queryKeyValue = [itm componentsSeparatedByString:@"="];
            
            NSString *VCkey = [self getClassVarNameOfQuery:queryKeyValue.firstObject inHostInfo:hostInfo];
            
            if ([self getVariableWithClass:[myObj class] varName: VCkey]) {
                [myObj setValue:queryKeyValue.lastObject forKey:VCkey];
            }else{
                NSLog(@"不支持的参数%@,但是仍会跳转。",VCkey);
                UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"需要升级才能完成操作" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
                [alv show];
                break;
            }
        }
    }
    UIViewController *currentVC = [self getCurrentVC];
    if (currentVC.navigationController) {
        currentVC.hidesBottomBarWhenPushed = YES;
        [currentVC.navigationController pushViewController:myObj animated:YES];
    }else{
        [currentVC presentViewController:myObj animated:YES completion:nil];
    }
}

/**
 *  得到当前显示的VC
 *
 */
+ (UIViewController *)getCurrentVC{
    
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    
    return result;
}

/**
 *  判断某个类是否有某个参数，防止 setvalue forkey 崩溃
 *
 */
+ (BOOL)getVariableWithClass:(Class) myClass varName:(NSString *)name{
    unsigned int outCount, i;
    Ivar *ivars = class_copyIvarList(myClass, &outCount);
    for (i = 0; i < outCount; i++) {
        Ivar property = ivars[i];
        NSString *keyName = [NSString stringWithCString:ivar_getName(property) encoding:NSUTF8StringEncoding];
        keyName = [keyName stringByReplacingOccurrencesOfString:@"_" withString:@""];
        if ([keyName isEqualToString:name]) {
            return YES;
        }
    }
    return NO;
}
/**
 *  返回VC的各参数名
 *
 */
+(NSString *)getClassVarNameOfQuery:(NSString *)query inHostInfo:(NSDictionary *)info
{
    NSDictionary *param = [info objectForKey:@"param"];
    return [param objectForKey:query];
}

+(NSDictionary *)getInfoOfHost:(NSString *)host{
    NSDictionary *hostDic = [self.routerDictionary objectForKey:host];
    return hostDic;
}

/**
 *  返回VC的类名
 *
 */
+(NSString *)getClassNameInHostInfo:(NSDictionary *)info{
    return info[@"className"];
}

/**
 路由信息字典

 @return 字典
 */
+(NSMutableDictionary *)defaultRouterPlistDictionary{
    NSURL *plistPath = [self routerPlistUrl];
    NSMutableDictionary *routerData = [NSMutableDictionary dictionaryWithContentsOfURL:plistPath];
    return routerData;
}

/**
 路由文件路径

 @return 路径
 */
+(NSURL *)bundlePlistPath{
    
    NSURL *bundlePlistUrl = [[NSBundle mainBundle] URLForResource:@"XYWdispatcherRouter" withExtension:@"plist"];
    return bundlePlistUrl;
   
}

/**
 更新分发器
 */
+ (void) updateDispatcher{
    [self downloadRouterFile];
}


/**
 下载远端配置文件,以动态设置转发参数
 */
+ (void)downloadRouterFile{
    
    NSString *urlStr = @"https://raw.githubusercontent.com/xueyongwei/RemoteConfig/master/hidden/114la/XYWdispatcherRouter.plist";
    
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            
            NSError *saveError;
            
            //把下载的内容从cache复制到document下
            NSURL *saveUrl = [self routerPlistUrl];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:saveUrl.path]){
                [[NSFileManager defaultManager] removeItemAtURL:saveUrl error:nil];
            }
            
            [[NSFileManager defaultManager] copyItemAtURL:location toURL:saveUrl error:&saveError];
            
            if (!saveError) {
                [self updateDispatcherDataWith:saveUrl];
            }else{
                NSLog(@"save error:%@",saveError.localizedDescription);
            }
            
        }else{
            NSLog(@"download error:%@",error.localizedDescription);
        }
        
    }];
    
    [downloadTask resume];
    
}

+(NSURL *)routerPlistUrl{
    
    NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *filePath = [dirPath stringByAppendingPathComponent:@"XYWRouterConfig.plist"];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        //如果还没有文件，从bundle中的默认文件拷贝出来作为配置
        NSURL *bundlePlistUrl = [self bundlePlistPath];
        
        NSError *moveError;
        [[NSFileManager defaultManager] moveItemAtURL:bundlePlistUrl toURL:fileUrl error:&moveError];
        if (moveError){
            NSLog(@"无法从bundle中拷贝配置文件:%@",moveError.localizedDescription);
        }else{
            NSLog(@"从bundle中拷贝配置文件");
        }
    }
    
    return fileUrl;
}

/**
 使用下载的新的路由配置

 @param fileUrl 本地文件路径
 */
+ (void)updateDispatcherDataWith:(NSURL *)fileUrl{

    NSDictionary *newRouterData = [NSDictionary dictionaryWithContentsOfURL:fileUrl];
    NSString *localPlistPath = [self routerPlistUrl].path;
    if ([newRouterData writeToFile:localPlistPath atomically:YES]){
        NSLog(@"远程路由配置已更新");
    }else{
        NSLog(@"远程路由配置更新失败！");
    }
    
}

@end


