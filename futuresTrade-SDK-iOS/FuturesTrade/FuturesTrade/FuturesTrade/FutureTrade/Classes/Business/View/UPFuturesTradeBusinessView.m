//
//  UPFuturesTradeBusinessView.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/8/29.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeBusinessView.h"
#import "GoldTradeKeyBoard.h"
#import "UPGoldTradeTextField.h"
#import <FuturesTradeSDK/UPCTPModelHeader.h>
#import "UPFuturesTradeColor2ImageUtil.h"

#define TRADE_BUTTON_SPACE  @"   "
#define BUY_IDENTIFIER      @"买"
#define SELL_IDENTIFIER     @"卖"
#define MINUS_IDENTIFIER     @"- "
#define PLUS_IDENTIFIER     @"+ "

static const int MAX_NUM_LENGTH = 7;
static const double MAX_PRICE = 1000000.f;

@interface UPFuturesTradeBusinessView () <UITextFieldDelegate, GoldTradeKeyBoardDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIButton *priceMinusBtn;
@property (weak, nonatomic) IBOutlet UPGoldTradeTextField *priceTextField;
@property (weak, nonatomic) IBOutlet UIButton *pricePlusBtn;
@property (weak, nonatomic) IBOutlet UIButton *numMinusBtn;
@property (weak, nonatomic) IBOutlet UPGoldTradeTextField *numTextField;
@property (weak, nonatomic) IBOutlet UIButton *numPlusBtn;
@property (weak, nonatomic) IBOutlet UILabel *canBuyLabel;
@property (weak, nonatomic) IBOutlet UILabel *canSellLabel;
@property (weak, nonatomic) IBOutlet UILabel *canBuyIdentifierLabel;
@property (weak, nonatomic) IBOutlet UILabel *canSellIdentifierLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UIButton *sellBtn;

// KeyBoard
@property (nonatomic, strong) GoldTradeKeyBoard *keyBoard;
@property (nonatomic, strong) NSMutableString *mutablePriceString;
@property (nonatomic, strong) NSMutableString *mutableNumberString;

// Position Operation
@property (nonatomic, assign) UPFuturesTradePositionOperation positionOperation;
// Trade Operation
@property (nonatomic, assign) UPFuturesTradeTradeOperation tradeOperation;
@property (nonatomic, strong) UPFuturesTradeOrderModel *orderModel;

@property (nonatomic, assign) double buyPrice;
@property (nonatomic, assign) double sellPrice;
@property (nonatomic, assign) int num;
@property (nonatomic, assign) BOOL hasInputedPrice;
@property (nonatomic, assign) double mixChangePrice;

@end

@implementation UPFuturesTradeBusinessView

- (void)dealloc {
    [_keyBoard destroyKeyboard];
    _keyBoard = nil;
}

+ (UPFuturesTradeBusinessView *)futuresTradeBusinessView {
    UPFuturesTradeBusinessView *businessView = [[[NSBundle mainBundle] loadNibNamed:@"FuturesTradeBundle.bundle/UPFuturesTradeBusinessView" owner:nil options:nil] firstObject];
    [businessView setupWidgets];
    return businessView;
}

- (void)initVars {
    _mutablePriceString = [NSMutableString stringWithString:@""];
    _mutableNumberString = [NSMutableString stringWithString:@""];
    _positionOperation = OpenPosition;
    _tradeOperation = Buy;
    [self resetHasInputedPrice];
    [self resetPrice];
    [self resetNum];
    _mixChangePrice = 1.f;
    _orderModel = nil;
    [_segmentControl setSelectedSegmentIndex:0];
}

- (void)resetHasInputedPrice {
    _hasInputedPrice = NO;
}

- (void)setHasInputedPrice {
    _hasInputedPrice = YES;
}

- (void)resetPrice {
    [self resetBuyPrice];
    _sellPrice = _buyPrice;
    [self refreshPrice:nil];
}

- (void)resetBuyPrice {
    _buyPrice = 0.f;
}

- (void)resetSellPrice {
    _sellPrice = 0.f;
}

- (void)resetNum {
    _num = 0;
    [self refreshNum];
}

- (void)setupWidgets {
    [self setupSegmentControl];
    [self setupTextFields];
    [self setupButtons];
    [self setupKeyboard];
}

- (void)setupSegmentControl {
    [_segmentControl addTarget:self action:@selector(segmentControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    _segmentControl.layer.masksToBounds = YES;
    _segmentControl.layer.cornerRadius = 5.f;
    _segmentControl.layer.borderColor = UPColorFromRGB(0xb2b2b2).CGColor;
    _segmentControl.layer.borderWidth = 1.f;
    [_segmentControl setDividerImage:[UPFuturesTradeColor2ImageUtil createImageWithColor:UPColorFromRGB(0xb2b2b2) frame:CGRectMake(0, 0, 0.5, 28)] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
}

- (void)setupTextFields {
    _priceTextField.delegate = self;
    [_priceTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    _numTextField.delegate = self;
    [_numTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setupButtons {
    _buyBtn.layer.masksToBounds = YES;
    _buyBtn.layer.cornerRadius = 3.f;
    _sellBtn.layer.masksToBounds = YES;
    _sellBtn.layer.cornerRadius = 3.f;
}

- (void)setupKeyboard {
    if (!_keyBoard) {
        _keyBoard = [[GoldTradeKeyBoard alloc] init];
        _keyBoard.keyBoardDelegate = self;
    }
}

#pragma mark - UISegmentControl Value Changed
- (void)segmentControlValueChanged:(UISegmentedControl *)segmentControl {
    [self refreshPositionOperation:segmentControl.selectedSegmentIndex];
    _num = (int)_businessModel.num;
    [self refreshNum];
    [self refreshCanBuyAndSellPriceLabel];
}

- (void)refreshPositionOperation:(NSInteger)index {
    switch (index) {
        case 0:
            _positionOperation = OpenPosition;
            break;
            
        case 1:
            _positionOperation = ClosePosition;
            break;
            
        case 2:
            _positionOperation = CloseTodayPosition;
            break;
            
        default:
            break;
    }
}

#pragma mark - Button Clicked

- (IBAction)numBtnClicked:(UIButton *)sender {
    NSInteger tag = sender.tag;
    if (tag < 2) {
        [self changePrice:2 - tag];
    } else {
        [self changeNumber:4 - tag];
    }
}

- (IBAction)buyOrSellClicked:(UIButton *)sender {
    NSInteger tag = sender.tag;
    _tradeOperation = 0 == tag ? Buy : Sell;
    
    if ((Buy == _tradeOperation && _buyPrice <= 0) || (Sell == _tradeOperation && _sellPrice <= 0)) {
        [self showAlert:@"提示" msg:@"下单价格不能为0" tag:0];
        return;
    }
    
    if (_num <= 0) {
        [self showAlert:@"提示" msg:@"下单数量不能为0" tag:0];
        return;
    }
    
    [self showTradeConfirmAlert];
}

#pragma mark - Trade Confirm Alert
static const NSInteger TRADE_CONFIRM_ALERT_TAG = 9999;
- (void)showTradeConfirmAlert {
    _orderModel = [[UPFuturesTradeOrderModel alloc] init];
    _orderModel.instrumentID = _instrumentModel.InstrumentID;
    _orderModel.instrumentName = _instrumentModel.InstrumentName;
    _orderModel.tradeOperation = _tradeOperation;
    _orderModel.positionOperation = _positionOperation;
    _orderModel.price = Buy == _tradeOperation ? _buyPrice : _sellPrice;
    _orderModel.num = _num;
    
    NSString *msg = [NSString stringWithFormat:@"%@，%@，%@，价格:%@，手数:%i",
                                                _orderModel.instrumentName,
                                                Buy == _orderModel.tradeOperation ? BUY_IDENTIFIER : SELL_IDENTIFIER,
                                                [self positionDesc:_orderModel.positionOperation],
                                                [UPFuturesTradeNumberUtil double2String:_orderModel.price],
                                                _orderModel.num];
    [self showAlert:@"确定要下单吗？" msg:msg tag:TRADE_CONFIRM_ALERT_TAG];
}

- (NSString *)positionDesc:(UPFuturesTradePositionOperation)positionOperation {
    if (OpenPosition == positionOperation) {
        return @"开仓";
    } else if (ClosePosition == positionOperation) {
        return @"平仓";
    } else {
        return @"平今";
    }
}

- (void)showAlert:(NSString *)title msg:(NSString *)msg tag:(NSInteger)tag {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                    delegate:0 == tag ? nil : self
                                                    cancelButtonTitle:0 == tag ? nil : @"取消"
                                                    otherButtonTitles:@"确认", nil];
    alert.tag = tag;
    [alert show];
}

#pragma mark - Setter

- (void)setRspTradingAccount:(UPRspTradingAccountModel *)rspTradingAccount {
    _rspTradingAccount = rspTradingAccount;
}

- (void)setInstrumentModel:(UPRspInstrumentModel *)instrumentModel {
    BOOL isSameWithLastInstrument = [_instrumentModel.InstrumentID isEqual:instrumentModel.InstrumentID];
    if (!isSameWithLastInstrument) {
        [self initVars];
    }
    _instrumentModel = instrumentModel;
    if (instrumentModel) {
        [_priceMinusBtn setTitle:[NSString stringWithFormat:@"%@%i", MINUS_IDENTIFIER, (int)instrumentModel.PriceTick] forState:UIControlStateNormal];
        [_pricePlusBtn setTitle:[NSString stringWithFormat:@"%@%i", PLUS_IDENTIFIER, (int)instrumentModel.PriceTick] forState:UIControlStateNormal];
        _mixChangePrice = instrumentModel.PriceTick;
    } else {
        [_priceMinusBtn setTitle:[NSString stringWithFormat:@"%@1", MINUS_IDENTIFIER] forState:UIControlStateNormal];
        [_pricePlusBtn setTitle:[NSString stringWithFormat:@"%@1", PLUS_IDENTIFIER] forState:UIControlStateNormal];
    }
    if (!isSameWithLastInstrument) {
        [self refreshCanBuyAndSellPriceLabel];
    }
}

- (void)setInstrumentMarginRateModel:(UPRspInstrumentMarginRateModel *)instrumentMarginRateModel {
    _instrumentMarginRateModel = instrumentMarginRateModel;
}

- (void)setDepthMarketDataModel:(UPRspDepthMarketDataModel *)depthMarketDataModel {
    if (![_depthMarketDataModel.InstrumentID isEqual:depthMarketDataModel.InstrumentID]) {
        [self resetHasInputedPrice];
    }
    _depthMarketDataModel = depthMarketDataModel;
    if (depthMarketDataModel) {
        [self pressText:2];
//        [self refreshTradeBtn:[UPFuturesTradeNumberUtil double2String:depthMarketDataModel.BidPrice1] sellTitle:[UPFuturesTradeNumberUtil double2String:depthMarketDataModel.AskPrice1] accordingTo:YES];
    } else {
        [self refreshTradeBtn:BUY_IDENTIFIER sellTitle:SELL_IDENTIFIER accordingTo:YES];
    }
}

- (void)setBusinessModel:(UPFuturesTradeBusinessModel *)businessModel {
    _businessModel = businessModel;
    if (businessModel) {
        [self refreshPositionOperation:businessModel.selectedSegment];
        [_segmentControl setSelectedSegmentIndex:businessModel.selectedSegment];
        _num = (int)businessModel.num;
        [self refreshNum];
    }
}

#pragma mark - Refresh View

- (void)refreshBuyBtn:(NSString *)title {
    if (title.doubleValue > 0.f) {
        _buyPrice = title.doubleValue;
    } else {
        [self resetBuyPrice];
    }
    
    if ([title isEqual:BUY_IDENTIFIER]) {
        [_buyBtn setTitle:BUY_IDENTIFIER  forState:UIControlStateNormal];
    } else {
        [_buyBtn setTitle:[NSString stringWithFormat:@"%@%@%@", title, TRADE_BUTTON_SPACE, BUY_IDENTIFIER]  forState:UIControlStateNormal];
    }
}

- (void)refreshSellBtn:(NSString *)title {
    if (title.doubleValue > 0.f) {
        _sellPrice = title.doubleValue;
    } else {
        [self resetSellPrice];
    }
    
    if ([title isEqual:SELL_IDENTIFIER]) {
        [_sellBtn setTitle:SELL_IDENTIFIER  forState:UIControlStateNormal];
    } else {
        [_sellBtn setTitle:[NSString stringWithFormat:@"%@%@%@", title, TRADE_BUTTON_SPACE, SELL_IDENTIFIER] forState:UIControlStateNormal];
    }
}

- (void)refreshTradeBtn:(NSString *)buyTitle sellTitle:(NSString *)sellTitle accordingTo:(BOOL)hasInputedPrice {
    if (!hasInputedPrice || (hasInputedPrice && !_hasInputedPrice)) {
        [self refreshBuyBtn:buyTitle];
        [self refreshSellBtn:sellTitle];
        [self refreshCanBuyAndSellPriceLabel];
    }
}

- (void)refreshNum {
    [self refreshNumTextField:[NSString stringWithFormat:@"%d", _num]];
}

- (void)refreshNumTextField:(NSString *)num {
    _numTextField.text = num;
}

- (void)refreshPrice:(NSString *)price {
    if (price.length > 0) {
        [self refreshPriceTextField:price];
    } else {
        if (_buyPrice > 0) {
            [self refreshPriceTextField:[UPFuturesTradeNumberUtil double2String:_buyPrice]];
        } else {
            [self refreshPriceTextField:EMPTY];
        }
    }
    [self refreshTradeBtn:[UPFuturesTradeNumberUtil double2String:_buyPrice] sellTitle:[UPFuturesTradeNumberUtil double2String:_sellPrice] accordingTo:NO];
}

- (void)refreshPriceTextField:(NSString *)price {
    _priceTextField.text = price;
    _priceTextField.placeholder = EMPTY;
}

- (void)refreshPriceTextFieldPlaceholder:(NSString *)placeholder {
    [self refreshPriceTextField:EMPTY];
    _priceTextField.placeholder = placeholder;
}

- (void)refreshCanBuyAndSellPriceLabel {
    if (OpenPosition == _positionOperation) {
        _canBuyIdentifierLabel.text = @"可买开：";
        _canSellIdentifierLabel.text = @"可卖开：";
        
        double longMarginRatio = _instrumentMarginRateModel ? _instrumentMarginRateModel.LongMarginRatioByMoney : _instrumentModel.LongMarginRatio;
        double divider = (_buyPrice*longMarginRatio);
        int canBuy = 0;
        if (divider != 0.f) {
            canBuy = (int)(_rspTradingAccount.Available/divider);
        }
        
        double shortMarginRatio = _instrumentMarginRateModel ? _instrumentMarginRateModel.ShortMarginRatioByMoney : _instrumentModel.ShortMarginRatio;
        int canSell = 0;
        divider = (_sellPrice*shortMarginRatio);
        if (divider != 0.f) {
            canSell = (int)(_rspTradingAccount.Available/divider);
        }
        
        _canBuyLabel.text = [NSString stringWithFormat:@"%i", canBuy];
        _canSellLabel.text = [NSString stringWithFormat:@"%i", canSell];
    } else if (ClosePosition == _positionOperation) {
        _canBuyIdentifierLabel.text = @"可买平：";
        _canSellIdentifierLabel.text = @"可卖平：";
        
        _canBuyLabel.text = [NSString stringWithFormat:@"%i", _businessModel.canBuyNum];
        _canSellLabel.text = [NSString stringWithFormat:@"%i", _businessModel.canSellNum];
    } else if (CloseTodayPosition == _positionOperation) {
        _canBuyIdentifierLabel.text = @"可买平今：";
        _canSellIdentifierLabel.text = @"可卖平今：";
        
        _canBuyLabel.text = [NSString stringWithFormat:@"%i", _businessModel.canBuyTodayNum];
        _canSellLabel.text = [NSString stringWithFormat:@"%i", _businessModel.canSellTodayNum];
    }
}

#pragma mark - Set Price
/**
 * 平仓按钮标价：
 * 对手价开仓 ：
 * 开多  取卖一价格（最优卖价）   开空 取买一价格（最优买价）
 * 平仓 ：
 * 平多  取买一价格（最优买价）  平空 取卖一价格（最优卖价）
 *
 * 排队价开仓 ：
 * 开多  取买一价格（最优买价）   开空 取卖一价格（最优卖价）
 * 平仓 ：
 * 平多  取卖一价格（最优卖价）  平空 取买一价格（最优买价）
 */
- (void)setPriceAccordingToType:(NSString *)type {
    if ([type isEqualToString:NEWEST_PRICE]) {                  // 最新价
        _buyPrice = _depthMarketDataModel.LastPrice;
        _sellPrice = _buyPrice;
    } else if ([type isEqualToString:QUEUE_PRICE]) {            // 排队价
        _buyPrice = _depthMarketDataModel.BidPrice1;    // 买，取买一价
        _sellPrice = _depthMarketDataModel.AskPrice1;   // 卖，取卖一价
    } else if ([type isEqualToString:COMPITOR_PRICE]) {         // 对手价
        _buyPrice = _depthMarketDataModel.AskPrice1;    // 买，取卖一价
        _sellPrice = _depthMarketDataModel.BidPrice1;   // 卖，取买一价
    } else if ([type isEqualToString:MARKET_PRICE]) {           // 市价
        _buyPrice = _depthMarketDataModel.UpperLimitPrice;     // 买，取涨停价
        _sellPrice = _depthMarketDataModel.LowerLimitPrice;     // 卖，取跌停价
    } else if ([type isEqualToString:OVERMARKET_PRICE]) {       // 超价
        _buyPrice = _depthMarketDataModel.AskPrice1 + _instrumentModel.PriceTick;   // 买，取卖一价+最小变动单位
        _sellPrice = _depthMarketDataModel.BidPrice1 - _instrumentModel.PriceTick;  // 卖，取买一价-最小变动单位
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _priceTextField) {
        if (UPFuturesTradeIsValidateString(textField.text)) {
            [_mutablePriceString appendString:textField.text];
        }
        GoldTradeKeyBoardModel *keyBoardModel = [[GoldTradeKeyBoardModel alloc] init];
        if (_depthMarketDataModel && _instrumentModel) {
            keyBoardModel.riseLimit = [UPFuturesTradeNumberUtil double2String:_depthMarketDataModel.UpperLimitPrice];
            keyBoardModel.downLimit = [UPFuturesTradeNumberUtil double2String:_depthMarketDataModel.LowerLimitPrice];
        }
        if (_instrumentModel) {
            keyBoardModel.mixChange = [UPFuturesTradeNumberUtil double2String:_instrumentModel.PriceTick];
        }
         _keyBoard.model = keyBoardModel;
        [_keyBoard setKeyBoardType:1];
        [self showKeyboard];
        [_priceTextField showCursor];
        [_numTextField hideCursor];
    } else if (textField == _numTextField) {
        if (UPFuturesTradeIsValidateString(textField.text)) {
            [_mutableNumberString appendString:textField.text];
        }
        [_keyBoard setKeyBoardType:2];
        [self showKeyboard];
        [_numTextField showCursor];
        [_priceTextField hideCursor];
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldValueChanged:(UITextField *)textField {
    
}

#pragma mark - Show Or Hide Keyboard
- (void)showKeyboard {
    [_keyBoard showKeyboard];
}

- (void)hideKeyboard {
    [_keyBoard hideKeyboard];
}

#pragma mark - GoldTradeKeyBoardDelegate

- (void)pressNumber:(NSInteger)num {
    if ((num >= 0 && num < 11)) {
        NSString *numStr = 10 == num ? @"." : [NSString stringWithFormat:@"%ld", (long)num];
        if (1 == _keyBoard.keyBoardType) {
            if (!_mutablePriceString) {
                _mutablePriceString = [NSMutableString string];
            }
            
            if (((10 == num && ![_mutablePriceString hasPrefix:@"."] && [UPFuturesTradeNumberUtil numberOfDotInString:[_mutablePriceString copy]] < 2 && _mutablePriceString.length > 0) || (num < 10 && ![_mutablePriceString hasPrefix:@"0"])) && ([UPFuturesTradeNumberUtil numberAfterDotInString:[_mutablePriceString copy]] < 3)) {
                if (_mutablePriceString.doubleValue < MAX_PRICE) {
                    [_mutablePriceString appendString:numStr];
                }
            }
            
            NSString *price = [_mutablePriceString copy];
            if (UPFuturesTradeIsValidateString(price)) {
                _buyPrice = price.floatValue;
                _sellPrice = _buyPrice;
                [self setHasInputedPrice];
                [self refreshPrice:price];
            } else {
                [self resetHasInputedPrice];
                [self resetPrice];
                [self refreshPriceTextField:EMPTY];
            }
        } else if (2 == _keyBoard.keyBoardType) {
            if (!_mutableNumberString) {
                _mutableNumberString = [NSMutableString string];
            }
            
            if (num < 10 && _mutableNumberString.length < MAX_NUM_LENGTH) {
                [_mutableNumberString appendString:numStr];
            }
            
            NSString *tempNum = [_mutableNumberString copy];
            if (UPFuturesTradeIsValidateString(tempNum)) {
                _num = tempNum.intValue;
                [self refreshNum];
            } else {
                [self resetNum];
                [self refreshNumTextField:EMPTY];
            }
        }
    } else if (num >= 11 && num <= 12) {
        if (1 == _keyBoard.keyBoardType ) {
            [self changePrice:11 == num ? 2 : 1];
        } else if (2 == _keyBoard.keyBoardType) {
            [self changeNumber:11 == num ? 2 : 1];
        }
    }
}

- (void)pressImage:(NSInteger)num {
    if (1 == num) {
        // 删除
        if (1 == _keyBoard.keyBoardType) {
            NSString *price = [_mutablePriceString copy];
            if (UPFuturesTradeIsValidateString(price)) {
                _mutablePriceString = [[_mutablePriceString substringToIndex:price.length - 1] mutableCopy];
                price = [_mutablePriceString copy];
                if (UPFuturesTradeIsValidateString(price)) {
                    _buyPrice = price.floatValue;
                    _sellPrice = _buyPrice;
                    [self refreshPrice:nil];
                } else {
                    [self resetPrice];
                    [self refreshPriceTextField:EMPTY];
                }
            }
        } else if (2 == _keyBoard.keyBoardType) {
            NSString *tempNum = [_mutableNumberString copy];
            if (UPFuturesTradeIsValidateString(tempNum)) {
                _mutableNumberString = [[_mutableNumberString substringToIndex:tempNum.length - 1] mutableCopy];
                tempNum = [_mutableNumberString copy];
                if (UPFuturesTradeIsValidateString(tempNum)) {
                    _num = tempNum.intValue;
                    [self refreshNum];
                } else {
                    [self resetNum];
                    [self refreshNumTextField:EMPTY];
                }
            }
        }
    }
}

- (void)pressText:(NSInteger)num {
    NSString *priceType = nil;
    switch (num) {
        case 1:
            priceType = [QUEUE_PRICE copy];
            break;
            
        case 2:
            priceType = [COMPITOR_PRICE copy];
            break;
            
        case 3:
            priceType = [MARKET_PRICE copy];
            break;
            
        case 4:
            priceType = [OVERMARKET_PRICE copy];
            break;
            
        default:
            priceType = [NEWEST_PRICE copy];
            break;
    }
    [self setPriceAccordingToType:priceType];
    [self refreshPriceTextFieldPlaceholder:priceType];
    [self setHasInputedPrice];
    [self refreshTradeBtn:[UPFuturesTradeNumberUtil double2String:_buyPrice] sellTitle:[UPFuturesTradeNumberUtil double2String:_sellPrice] accordingTo:NO];
}

- (void)longPressDeleteButton {
    
}

bool isKeyboardWillShow = NO;

- (void)resetIsKeyboardWillShow {
    isKeyboardWillShow = NO;
}

- (void)keyboardWillShow:(GoldTradeKeyBoard *)keyboard {
    isKeyboardWillShow = YES;
    if (1 == keyboard.keyBoardType) {
        
    } else if (2 == keyboard.keyBoardType) {
        
    }
}

- (void)keyboardDidShow:(GoldTradeKeyBoard *)keyboard {
    [self performSelector:@selector(resetIsKeyboardWillShow) withObject:nil afterDelay:0.6];
}

- (void)keyboardWillHide:(GoldTradeKeyBoard *)keyboard {
    [self resetIsKeyboardWillShow];
    if (1 == keyboard.keyBoardType) {
    } else if (2 == keyboard.keyBoardType) {
    }
}

- (void)keyboardDidHide:(GoldTradeKeyBoard *)keyboard {
    [self resetIsKeyboardWillShow];;
    if (1 == keyboard.keyBoardType) {
        
    }
}

#pragma mark - Change Price And Num
/**
 * changePrice:
 *
 * 改变价格
 *
 * @Parameters:
 *          direction - 1：增加，2：减小
 */
- (void)changePrice:(NSInteger)direction {
    double unit = _instrumentModel.PriceTick;
    if (1 == direction) {
        _buyPrice += unit;
    } else if (2 == direction) {
        if (_buyPrice - unit >= 0) {
            _buyPrice -= unit;
        }
    }
    _sellPrice = _buyPrice;
    [self setHasInputedPrice];
    [self refreshPrice:nil];
}

/**
 * changeNumber:
 *
 * 改变数量
 *
 * @Parameters:
 *          direction - 1：增加，2：减小
 */
- (void)changeNumber:(NSInteger)direction {
    if (1 == direction) {
        _num += 1;
    } else if (2 == direction) {
        if (_num - 1 >= 0) {
            _num -= 1;
        }
    }
    [self refreshNum];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (TRADE_CONFIRM_ALERT_TAG == alertView.tag && 1 == buttonIndex) {
        if (_orderBlock) {
            _orderBlock(_orderModel);
        }
    }
}

@end

@implementation UPFuturesTradeBusinessModel


@end
