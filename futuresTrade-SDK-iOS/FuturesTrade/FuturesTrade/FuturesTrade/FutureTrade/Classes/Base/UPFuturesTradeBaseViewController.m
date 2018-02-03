//
//  UPCTPTradeBaseViewController.m
//  FuturesTradeDemo
//
//  Created by LiuLian on 17/8/25.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeBaseViewController.h"

//NSString * const BROKER_ID = @"9999";
//NSString * const BROKER_ID = @"0091";
NSString * const BROKER_ID = @"4BFAEAE8"; // 金仕达仿真环境

@interface UPFuturesTradeBaseViewController ()

@end

@implementation UPFuturesTradeBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setNavBarTranslucent

- (void)setNavBarTranslucent:(BOOL)isTranslucent {
    if (isTranslucent) {
        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    } else {
        self.navigationController.navigationBar.translucent = NO;
    }
}

#pragma mark - Hide Back Button

- (void)hideBackBtn {
    [self.navigationController.navigationItem setHidesBackButton:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar.backItem setHidesBackButton:YES];
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
