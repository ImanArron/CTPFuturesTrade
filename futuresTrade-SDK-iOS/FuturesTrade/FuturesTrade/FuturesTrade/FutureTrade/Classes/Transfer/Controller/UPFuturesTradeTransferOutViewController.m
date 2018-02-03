//
//  UPFuturesTradeTransferOutViewController.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/8.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeTransferOutViewController.h"

@interface UPFuturesTradeTransferOutViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UILabel *availabelMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UITextField *fundPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankPwdTextField;
@property (nonatomic, strong) UPRspAccountregisterModel *accountregisterModel;
@property (nonatomic, strong) UPRspNotifyQueryAccountModel *accountModel;

@end

@implementation UPFuturesTradeTransferOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupTextField];
    [self setupConfirmBtn];
    [self queryAccountregister:nil];
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

#pragma mark - Query Trading Account

- (void)queryBankAccountMoneyByFuture:(BOOL)needHint {
    [UPHUD showHUD:self.view];
    UPFuturesTradeWeakSelf(self)
    [self.ctpTradeManager reqQueryBankAccountMoneyByFuture:^(id result, NSError *error) {
        [weakself finishQueryingBankAccountMoneyByFuture:result error:error];
    }];
}

- (void)finishQueryingBankAccountMoneyByFuture:(id)result error:(NSError *)error {
    [UPHUD hideHUD:self.view];
    if (!error) {
        _accountModel = result;
    } else {
        [UPHUD showToast:self.view withText:error.domain ? error.domain : @"转账失败"];
    }
    [self refreshView];
    [self queryAccountregister:nil];
}

#pragma mark - Query Accountregister
- (void)queryAccountregister:(UPCompletionBlock)completionBlock {
    [UPHUD showHUD:self.view];
    UPFuturesTradeWeakSelf(self)
    [self.ctpTradeManager reqQueryAccountregister:^(id result, NSError *error) {
        [weakself finishQueryingAccountregister:result error:error completionBlock:completionBlock];
    }];
}

- (void)finishQueryingAccountregister:(id)result error:(NSError *)error completionBlock:(UPCompletionBlock)completionBlock {
    [UPHUD hideHUD:self.view];
    if (!error) {
        NSArray<UPRspAccountregisterModel *> *accountregisterModels = result;
        if (accountregisterModels.count > 0) {
            _accountregisterModel = accountregisterModels[0];
        }
    }
    
    if (completionBlock) {
        completionBlock(_accountregisterModel?YES:NO, error);
    }
}

#pragma mark - Refresh View
- (void)refreshView {
    _availabelMoneyLabel.text = [UPFuturesTradeNumberUtil double2String:_accountModel.BankFetchAmount];
}

#pragma mark - Button Clicked

- (IBAction)confirmClicked:(id)sender {
    NSString *amount = _inputTextField.text;
    if (amount.floatValue <= 0) {
        [UPHUD showToast:self.view withText:@"转出不能为0"];
        return;
    }
    
    /*if (amount.floatValue > _accountModel.BankFetchAmount) {
        [UPHUD showToast:self.view withText:@"转出超过可取"];
        return;
    }*/
    
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
    
    if (_accountregisterModel) {
        [self startTransfer:amount.floatValue fundPwd:fundPwd bankPwd:bankPwd];
    } else {
        UPFuturesTradeWeakSelf(self)
        [self queryAccountregister:^(BOOL successed, NSError *error) {
            if (successed) {
                [weakself startTransfer:amount.floatValue fundPwd:fundPwd bankPwd:bankPwd];
            } else {
                [UPHUD showToast:weakself.view withText:@"查询银期关系失败，无法转账，请重试"];
            }
        }];
    }
}

- (void)startTransfer:(double)amount fundPwd:(NSString *)fundPwd bankPwd:(NSString *)bankPwd {
    [UPHUD showHUD:self.view];
    UPFuturesTradeWeakSelf(self)
    [self.ctpTradeManager reqBetweenBankAndFuture:_accountregisterModel.BankAccount bankID:_accountregisterModel.BankID bankBranchID:_accountregisterModel.BankBranchID amount:amount fundPwd:fundPwd bankPwd:bankPwd transferDirection:1 callback:^(id result, NSError *error) {
        [weakself finishTransfering:result error:error];
    }];
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
