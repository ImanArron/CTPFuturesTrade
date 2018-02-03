//
//  ViewController.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/8/28.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "ViewController.h"
#import <FuturesTrade/UPFuturesTradeManager.h>
//#import "UPHsOpenAccountManager.h"

@interface ViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *environmentLabel;
@property (nonatomic) BOOL isTest;
@property (weak, nonatomic) IBOutlet UISwitch *environmentSwitch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"期货交易开户";
    [self setupEnvironmentLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupEnvironmentLabel {
    _environmentLabel.text = [UPFuturesTradeManager isTestEnvironment] ? @"测试环境" : @"生产环境";
    [_environmentSwitch setOn:![UPFuturesTradeManager isTestEnvironment] animated:YES];
}

- (IBAction)environmentSwitchValueChanged:(UISwitch *)sender {
    _isTest = !sender.isOn;
    [UPFuturesTradeManager setTestEnvironment:_isTest];
    [self setupEnvironmentLabel];
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请退出app后重进，重置环境才会生效" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];*/
}

- (IBAction)loginClicked:(id)sender {
    [UPFuturesTradeManager startFuturesTrade:self instrumentID:nil tradeType:[UPFuturesTradeManager isTestEnvironment] ? UPCTPSimulateTrade : UPCTPRealTrade];
}

- (IBAction)openAccountClicked:(id)sender {
    //[[UPHsOpenAccountManager sharedOpenAccountManager] startHsOpenAccount:self];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (1 == buttonIndex) {
        [UPFuturesTradeManager setTestEnvironment:_isTest];
        [self setupEnvironmentLabel];
        exit(1);
    }
}

@end
