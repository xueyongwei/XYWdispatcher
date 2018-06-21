//
//  ViewController.m
//  XYWdispatcher
//
//  Created by xueyongwei on 16/11/14.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "ViewController.h"
#import "XYWdispatcher.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     测试打开test1界面，在浏览器输入
     XYWdispatcher://test1ViewController?str=xueyongwei
     */
    
}
- (IBAction)onUpdate:(UIButton *)sender {
    [XYWdispatcher updateDispatcher];
}
- (IBAction)onClick:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"XYWdispatcher://test1ViewController/search;type=1?str=hahahha"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
