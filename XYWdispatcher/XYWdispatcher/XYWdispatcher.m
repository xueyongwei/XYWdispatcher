//
//  XYWdispatcher.m
//  roter
//
//  Created by xueyongwei on 16/11/14.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "XYWdispatcher.h"
#import <UIKit/UIKit.h>
#import "Test1ViewController.h"
@implementation XYWdispatcher
+(BOOL)HandleOpenURL:(NSURL *)url withScheme:(NSString *)scheme
{
    NSLog(@"%@",url);
    [[self new] handleSchemes:url];
    return [url.scheme isEqualToString:scheme];
}
-(void)handleSchemes:(NSURL *)url
{
    NSString *host = [url host];
    NSArray *itms = [[url query] componentsSeparatedByString:@"&"];
    [self jumpVC:host withquerys:itms];
}
-(void)jumpVC:(NSString *)host withquerys:(NSArray *)querys
{
    NSString *vcClz = [self classWithHost:host];
    id myObj = [[NSClassFromString(vcClz) alloc] init];
    NSAssert(myObj, @"没有这个%@类",vcClz);
    if (myObj) {
        for (NSString *itm in querys) {
            NSArray *keyvalues = [itm componentsSeparatedByString:@"="];
            [myObj setValue:keyvalues.lastObject forKey:keyvalues.firstObject];
        }
    }
    UIViewController *currentVC = [self getCurrentVC];
    if (currentVC.navigationController) {
        [currentVC.navigationController pushViewController:myObj animated:YES];
    }else{
        [[self getCurrentVC] presentViewController:myObj animated:YES completion:nil];
    }
}
- (UIViewController *)getCurrentVC{
    
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
        nextResponder = [frontView nextResponder]; //  这方法下面有详解
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    
    return result;
}
-(NSString *)classWithHost:(NSString *)host
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"XYWdispatcherRouter" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    return [data objectForKey:host];
}
@end
