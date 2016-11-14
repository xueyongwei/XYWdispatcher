//
//  test1ViewController.m
//  XYWdispatcher
//
//  Created by xueyongwei on 16/11/14.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "test1ViewController.h"

@interface test1ViewController ()

@end

@implementation test1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(20, 20, 60, 44);
    [btn setTitle:@"back" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onDissmiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
        label.textColor = [UIColor whiteColor];
        label.text = self.str;
        [self.view addSubview:label];
    });
    // Do any additional setup after loading the view.
}
-(void)onDissmiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
