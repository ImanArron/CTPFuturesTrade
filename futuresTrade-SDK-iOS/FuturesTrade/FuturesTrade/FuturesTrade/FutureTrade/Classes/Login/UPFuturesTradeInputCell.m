//
//  UPFuturesTradeInputCell.m
//  FuturesTradeDemo
//
//  Created by LiuLian on 17/8/28.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeInputCell.h"
#import "UPFuturesTradeMacros.h"

NSString * const UPFuturesTradeInputCellReuseId = @"UPFuturesTradeInputCell";

@interface UPFuturesTradeInputCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property (weak, nonatomic) IBOutlet UIImageView *downArrwoIV;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation UPFuturesTradeInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_inputTF addTarget:self action:@selector(inputValueChanged:) forControlEvents:UIControlEventEditingChanged];
    _inputTF.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewModel:(UPFuturesTradeInputCellViewModel *)viewModel {
    _viewModel = viewModel;
    _nameLabel.text = UPFuturesTradeIsValidateString(viewModel.name) ? viewModel.name : @"";
    _inputTF.text = UPFuturesTradeIsValidateString(viewModel.value) ? viewModel.value : @"";
    _inputTF.placeholder = UPFuturesTradeIsValidateString(viewModel.placeholder) ? viewModel.placeholder : @"";
    _inputTF.keyboardType = viewModel.keyboardType;
    _inputTF.secureTextEntry = viewModel.secureTextEntry;
    [self hideDownImageIV];
//    if (viewModel.showArrow) {
//        [self showDownImageIV];
//    } else {
//        [self hideDownImageIV];
//    }
}

- (void)showDownImageIV {
    _downArrwoIV.hidden = NO;
    _button.hidden = NO;
}

- (void)hideDownImageIV {
    _downArrwoIV.hidden = YES;
    _button.hidden = YES;
}

- (IBAction)btnClicked:(id)sender {
    if (_clickBlock) {
        _clickBlock();
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_viewModel.showArrow) {
        [self btnClicked:nil];
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)inputValueChanged:(UITextField *)textField {
    if (!_viewModel) {
        _viewModel = [[UPFuturesTradeInputCellViewModel alloc] init];
    }
    _viewModel.value = textField.text;
    
    if (_block) {
        _block(_viewModel);
    }
}

@end

@implementation UPFuturesTradeInputCellViewModel


@end
