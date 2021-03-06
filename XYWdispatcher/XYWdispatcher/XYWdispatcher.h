//
//  XYWdispatcher.h
//  roter
//
//  Created by xueyongwei on 16/11/14.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  先在路由表中配置host与viewController的对应关系
 */
@interface XYWdispatcher : NSObject
//注册捕获的scheme
+ (void) registerScheme:(NSString *)scheme;
//在appdelegate中捕获url
+(BOOL) handleURL:(NSURL *) url;

// 更新分发器
+(void)updateDispatcher;

@end
