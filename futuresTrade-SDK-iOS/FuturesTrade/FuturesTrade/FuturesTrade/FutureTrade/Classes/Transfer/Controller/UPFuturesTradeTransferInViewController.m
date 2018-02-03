//
//  UPFuturesTradeTransferInViewController.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/8.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeTransferInViewController.h"
#import "UPFuturesTradeTransferUtil.h"

@interface UPFuturesTradeTransferInViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bankLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UILabel *bankAccountLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (nonatomic, strong) UPRspAccountregisterModel *accountregisterModel;
@property (weak, nonatomic) IBOutlet UITextField *fundPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankPwdTextField;

@end

@implementation UPFuturesTradeTransferInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupTextField];
    [self setupConfirmBtn];
    [self queryAccountregister];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTextField {
    _inputTextField.delegate = self;
    _fundPwdTextField.delegate = self;
    _bankPwdTextField.delegate = self;
}

- (void)setupConfirmBtn {
    _confirmBtn.layer.masksToBounds = YES;
    _confirmBtn.layer.cornerRadius = 5.f;
}

- (void)clearTextField {
    _inputTextField.text = @"";
    _fundPwdTextField.text = @"";
    _bankPwdTextField.text = @"";
}

#pragma mark - Button Clicked

- (IBAction)confirmClicked:(id)sender {
    NSString *fundPwd = _fundPwdTextField.text;
    if (!UPFuturesTradeIsValidateString(fundPwd)) {
        [UPHUD showToast:self.view withText:@"请输入资金密码"];
        return;
    }
    
    NSString *bankPwd = _bankPwdTextField.text;
    if (!UPFuturesTradeIsValidateString(bankPwd)) {
        [UPHUD showToast:self.view withText:@"请输入银行密码"];
        return;
    }
    
    NSString *amount = _inputTextField.text;
    if (amount.floatValue <= 0.f) {
        [UPHUD showToast:self.view withText:@"转账金额不能小于0"];
        return;
    }
    
    if (_accountregisterModel) {
        [UPHUD showHUD:self.view];
        UPFuturesTradeWeakSelf(self)
        [self.ctpTradeManager reqBetweenBankAndFuture:_accountregisterModel.BankAccount bankID:_accountregisterModel.BankID bankBranchID:_accountregisterModel.BankBranchID amount:amount.floatValue fundPwd:fundPwd bankPwd:bankPwd transferDirection:0 callback:^(id result, NSError *error) {
            [weakself finishTransfering:result error:error];
        }];
    }
}

- (void)finishTransfering:(id)result error:(NSError *)error {
    [UPHUD hideHUD:self.view];
    if (!error) {
        [UPHUD showToast:self.view withText:@"转账成功"];
        [self clearTextField];
    } else {
        [UPHUD showToast:self.view withText:error.domain ? error.domain : @"转账失败"];
    }
}

#pragma mark - Load Data
- (void)queryAccountregister {
    [UPHUD showHUD:self.view];
    UPFuturesTradeWeakSelf(self)
    [self.ctpTradeManager reqQueryAccountregister:^(id result, NSError *error) {
        [weakself finishQueryingAccountregister:result error:error];
    }];
}

- (void)finishQueryingAccountregister:(id)result error:(NSError *)error {
    [UPHUD hideHUD:self.view];
    if (!error) {
        NSArray<UPRspAccountregisterModel *> *accountregisterModels = result;
        if (accountregisterModels.count > 0) {
            _accountregisterModel = accountregisterModels[0];
            [self refreshView];
        }
    } else {
        [UPHUD showToast:self.view withText:UPFuturesTradeIsValidateString(error.domain)?error.domain:@"查询银期关系失败"];
    }
}

#pragma mark - Refresh View
- (void)refreshView {
    _bankNameLabel.text = [UPFuturesTradeTransferUtil bankName:_accountregisterModel.BankID];
    _bankLogoImageView.image = [UPFuturesTradeTransferUtil bankImage:_accountregisterModel.BankID];
    _bankAccountLabel.text = _accountregisterModel.BankAccount;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
