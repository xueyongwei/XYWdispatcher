//
//  XYWdispatcher.h
//  roter
//
//  Created by xueyongwei on 16/11/14.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYWdispatcher : NSObject
+(BOOL)HandleOpenURL:(NSURL *)url withScheme:(NSString *)scheme;
@end
