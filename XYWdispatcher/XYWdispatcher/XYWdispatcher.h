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
//在appdelegate中捕获url
+(BOOL)HandleOpenURL:(NSURL *)url withScheme:(NSString *)scheme;
@end
