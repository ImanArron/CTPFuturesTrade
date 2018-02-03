//
//  GoldTradeKeyBoard.m
//  BoGuTongJin
//
//  Created by LiuLian on 16/4/12.
//  Copyright © 2016年 upchina. All rights reserved.
//

#import "GoldTradeKeyBoard.h"

#define kGoldTradeKeyBoardScreenWidth    [[UIScreen mainScreen] bounds].size.width
#define kGoldTradeKeyBoardScreenHeight   [[UIScreen mainScreen] bounds].size.height

NSString * const NEWEST_PRICE = @"最新价";
NSString * const QUEUE_PRICE = @"排队价";
NSString * const COMPITOR_PRICE = @"对手价";
NSString * const MARKET_PRICE = @"市价";
NSString * const OVERMARKET_PRICE = @"超价";

@interface GoldTradeKeyBoard () {
    CGFloat totalHeight;
    CGFloat keyBoardHeight;
}

@property (nonatomic, strong) UIView *keyBoardView;

@end

@implementation GoldTradeKeyBoard

- (void)dealloc {
    [self destroyKeyboard];
}

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _keyBoardType = 1;
    _model = nil;
    totalHeight = 300;
    keyBoardHeight = 300;
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, kGoldTradeKeyBoardScreenHeight, kGoldTradeKeyBoardScreenWidth, totalHeight);
    _keyBoardView = [[UIView alloc] initWithFrame:CGRectMake(0, totalHeight - keyBoardHeight, kGoldTradeKeyBoardScreenWidth, keyBoardHeight)];
    _keyBoardView.backgroundColor = [UIColor clearColor];
    [self addSubview:_keyBoardView];
    UIView *tappedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kGoldTradeKeyBoardScreenWidth, totalHeight - keyBoardHeight)];
    tappedView.backgroundColor = [UIColor clearColor];
    [self addSubview:tappedView];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [tappedView addGestureRecognizer:tapGR];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)loadSubviews {
    
}

#pragma mark - Draw

const float TopViewHeight = 100;
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGFloat buttonWidth = kGoldTradeKeyBoardScreenWidth/4;
    
    UIView *topView = [[UIView alloc] init];
    topView.frame = CGRectMake(0, 0, kGoldTradeKeyBoardScreenWidth, TopViewHeight);
    [_keyBoardView addSubview:topView];
    
    // Drawing code
    if (1 == _keyBoardType) {
        topView.backgroundColor = GoldTradeKeyBoardUIColorWithRGB(0xf2f3f5);
        [topView addSubview:GoldTradeKeyBoardCutoffLineImageViewWithColor(CGRectMake(0, TopViewHeight/2 - 0.5, kGoldTradeKeyBoardScreenWidth, 0.5), GoldTradeKeyBoardUIColorWithRGB(0xc9c9c9))];
        
        // @"对手价", @"排队价", @"最新价", @"市价", @"超价"
        CGFloat priceButtonWidth = kGoldTradeKeyBoardScreenWidth/[[self priceIdentifiers] count];
        for (NSInteger i = 0; i < [self priceIdentifiers].count; i++) {
            CGRect textButtonFrame = CGRectMake(i * priceButtonWidth, 50, priceButtonWidth, TopViewHeight/2);
            UIButton *textButton = [self textButton:[self priceIdentifiers][i] tag:i frame:textButtonFrame];
            [topView addSubview:textButton];
        }
        
        NSString *defaultStr = @"--";
        // 最小变动价及涨停、跌停
        NSString *text = [NSString stringWithFormat:@"最小变动价为%@，涨停%@，跌停%@", _model.mixChange?_model.mixChange:defaultStr, _model.riseLimit?_model.riseLimit:defaultStr, _model.downLimit?_model.downLimit:defaultStr];
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.frame = CGRectMake(10, (TopViewHeight/2 - 20)/2, 3 * buttonWidth - 10, 20);
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = GoldTradeKeyBoardUIColorWithRGB(0x555555);
        label.text = text;
        [topView addSubview:label];
        
        // 收起键盘按钮
        CGRect foldButtonFrame = CGRectMake(3 * buttonWidth + (buttonWidth - 20)/2, (TopViewHeight/2 - 18)/2, 20, 18);
        UIButton *foldButton = [self imageButton:[UIImage imageNamed:@"FuturesTradeBundle.bundle/keybord_img"] tag:10 frame:foldButtonFrame];
        [topView addSubview:foldButton];
        
        foldButtonFrame = CGRectMake(3 * buttonWidth, 0, buttonWidth, TopViewHeight/2);
        UIButton *bigFoldButton = [self imageButton:nil tag:10 frame:foldButtonFrame];
        [topView addSubview:bigFoldButton];
        
        [topView addSubview:GoldTradeKeyBoardCutoffLineImageViewWithColor(CGRectMake(0, 0, kGoldTradeKeyBoardScreenWidth, 0.5), GoldTradeKeyBoardUIColorWithRGB(0xc9c9c9))];
        [topView addSubview:GoldTradeKeyBoardCutoffLineImageViewWithColor(CGRectMake(0, TopViewHeight - 0.5, kGoldTradeKeyBoardScreenWidth, 0.5), GoldTradeKeyBoardUIColorWithRGB(0xc9c9c9))];
    } else if (2 == _keyBoardType) {
        topView.backgroundColor = [UIColor clearColor];
        
        UIView *spaceView = [[UIView alloc] init];
        spaceView.backgroundColor = GoldTradeKeyBoardUIColorWithRGB(0xf2f3f5);
        spaceView.frame = CGRectMake(0, TopViewHeight/2, kGoldTradeKeyBoardScreenWidth, TopViewHeight/2);
        [topView addSubview:spaceView];
        
        // 收起键盘按钮
        CGRect foldButtonFrame = CGRectMake(3 * buttonWidth + (buttonWidth - 20)/2, (TopViewHeight/2 - 18)/2, 20, 18);
        UIButton *foldButton = [self imageButton:[UIImage imageNamed:@"FuturesTradeBundle.bundle/keybord_img"] tag:10 frame:foldButtonFrame];
        [spaceView addSubview:foldButton];
        
        foldButtonFrame = CGRectMake(3 * buttonWidth, 0, buttonWidth, TopViewHeight/2);
        UIButton *bigFoldButton = [self imageButton:nil tag:10 frame:foldButtonFrame];
        [spaceView addSubview:bigFoldButton];
        
        [spaceView addSubview:GoldTradeKeyBoardCutoffLineImageViewWithColor(CGRectMake(0, 0, kGoldTradeKeyBoardScreenWidth, 0.5), GoldTradeKeyBoardUIColorWithRGB(0xc9c9c9))];
        [spaceView addSubview:GoldTradeKeyBoardCutoffLineImageViewWithColor(CGRectMake(0, TopViewHeight/2 - 0.5, kGoldTradeKeyBoardScreenWidth, 0.5), GoldTradeKeyBoardUIColorWithRGB(0xc9c9c9))];
    }
    
    // 1~9
    for (NSInteger i = 1; i < 10; i++) {
        CGRect buttonFrame = CGRectMake(((i - 1)%3) * buttonWidth, TopViewHeight + ((i - 1)/3) * 50, buttonWidth, 50);
        UIButton *numberButton = [self numberButton:i frame:buttonFrame];
        [_keyBoardView addSubview:numberButton];
    }
    
    // +、-
    for (NSInteger i = 11; i < 13; i++) {
        CGRect buttonFrame = CGRectMake(3 * buttonWidth, TopViewHeight + (1 - (i - 11)) * 100, buttonWidth, 100);
        UIButton *numberButton = [self numberButton:i frame:buttonFrame];
        [_keyBoardView addSubview:numberButton];
    }
    
    // 删除键盘按钮
    CGRect deleteButtonFrame = CGRectMake(2 * buttonWidth/* + (buttonWidth - 30)/2*/, TopViewHeight + 50 * 3/* + (50 - 30)/2*/, buttonWidth, 50);
    UIButton *deleteButton = [self imageButton:[UIImage imageNamed:@"FuturesTradeBundle.bundle/emotion_del_normal"] tag:11 frame:deleteButtonFrame];
    deleteButton.backgroundColor = [UIColor whiteColor];
    [deleteButton addSubview:GoldTradeKeyBoardCutoffLineImageViewWithColor(CGRectMake(0, 0, 0.5, deleteButtonFrame.size.height), GoldTradeKeyBoardUIColorWithRGB(0xc9c9c9))];
    [deleteButton addSubview:GoldTradeKeyBoardCutoffLineImageViewWithColor(CGRectMake(deleteButtonFrame.size.width, 0, 0.5, deleteButtonFrame.size.height), GoldTradeKeyBoardUIColorWithRGB(0xc9c9c9))];
    [deleteButton addSubview:GoldTradeKeyBoardCutoffLineImageViewWithColor(CGRectMake(0, 0, deleteButtonFrame.size.width, 0.5), GoldTradeKeyBoardUIColorWithRGB(0xc9c9c9))];
    [deleteButton addSubview:GoldTradeKeyBoardCutoffLineImageViewWithColor(CGRectMake(0, deleteButtonFrame.size.height, deleteButtonFrame.size.width, 0.5), GoldTradeKeyBoardUIColorWithRGB(0xc9c9c9))];
    [_keyBoardView addSubview:deleteButton];
    
    // .和0
    if (2 == _keyBoardType) {
        CGRect zeroButtonFrame = CGRectMake(0, TopViewHeight + 3 * 50, buttonWidth * 2, 50);
        UIButton *zeroButton = [self numberButton:0 frame:zeroButtonFrame];
        [_keyBoardView addSubview:zeroButton];
    } else if (1 == _keyBoardType) {
        CGRect zeroButtonFrame = CGRectMake(buttonWidth, TopViewHeight + 3 * 50, buttonWidth, 50);
        UIButton *zeroButton = [self numberButton:0 frame:zeroButtonFrame];
        [_keyBoardView addSubview:zeroButton];
        
        CGRect dotButtonFrame = CGRectMake(0, TopViewHeight + 3 * 50, buttonWidth, 50);
        UIButton *dotButton = [self numberButton:10 frame:dotButtonFrame];
        [_keyBoardView addSubview:dotButton];
    }
}

#pragma mark - priceIdentifiers

- (NSArray *)priceIdentifiers {
    return @[NEWEST_PRICE, QUEUE_PRICE, COMPITOR_PRICE, MARKET_PRICE, OVERMARKET_PRICE];
}

#pragma mark - Button

- (UIButton *)numberButton:(NSInteger)num frame:(CGRect)frame {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = [UIColor whiteColor];
    button.tag = 10 + num;
    if (11 == num || 12 == num) {
        // 11为"-"，12为"+"
        [button setTitle:11 == num ? @"-" : @"+" forState:UIControlStateNormal];
        button.backgroundColor = GoldTradeKeyBoardUIColorWithRGB(0xf2f3f5);
    } else if (10 == num) {
        // 10为"."
        [button setTitle:@"." forState:UIControlStateNormal];
        button.backgroundColor = GoldTradeKeyBoardUIColorWithRGB(0xf2f3f5);
    } else {
        [button setTitle:[NSString stringWithFormat:@"%ld", (long)num] forState:UIControlStateNormal];
    }
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    if (11 == num || 12 == num) {
        button.titleLabel.font = [UIFont systemFontOfSize:30];
    }
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didNumberButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if ((num > 3 && num < 12) || 0 == num) {
        [button addSubview:GoldTradeKeyBoardCutoffLineImageViewWithColor(CGRectMake(0, 0, frame.size.width, 0.5), GoldTradeKeyBoardUIColorWithRGB(0xc9c9c9))];
    }
    [button addSubview:GoldTradeKeyBoardCutoffLineImageViewWithColor(CGRectMake(0, 0, 0.5, frame.size.height), GoldTradeKeyBoardUIColorWithRGB(0xc9c9c9))];
    [button addSubview:GoldTradeKeyBoardCutoffLineImageViewWithColor(CGRectMake(frame.size.width, 0, 0.5, frame.size.height), GoldTradeKeyBoardUIColorWithRGB(0xc9c9c9))];
    [button addSubview:GoldTradeKeyBoardCutoffLineImageViewWithColor(CGRectMake(0, frame.size.height, frame.size.width, 0.5), GoldTradeKeyBoardUIColorWithRGB(0xc9c9c9))];
    
    return button;
}

- (void)didNumberButtonPressed:(UIButton *)button {
    NSInteger tag = button.tag - 10;
    if (_keyBoardDelegate && [_keyBoardDelegate respondsToSelector:@selector(pressNumber:)]) {
        [_keyBoardDelegate pressNumber:tag];
    }
}

- (UIButton *)imageButton:(UIImage *)image tag:(NSInteger)tag frame:(CGRect)frame {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = [UIColor clearColor];
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    button.tag = tag;
    [button addTarget:self action:@selector(didImageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    if (11 == tag) {
        // 删除按钮，添加长按事件
//        [button addTarget:self action:@selector(didDeleteButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    }
    return button;
}

- (void)didImageButtonPressed:(UIButton *)button {
    NSInteger tag = button.tag - 10;
    if (_keyBoardDelegate && [_keyBoardDelegate respondsToSelector:@selector(pressImage:)]) {
        [_keyBoardDelegate pressImage:tag];
        if ( 0 == tag ) {
            [self hideKeyboard];
        }
    }
}

- (UIButton *)textButton:(NSString *)title tag:(NSInteger)tag frame:(CGRect)frame {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = [UIColor clearColor];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    button.tag = tag + 10;
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didTextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)didTextButtonPressed:(UIButton *)button {
    NSInteger tag = button.tag - 10;
    if (_keyBoardDelegate && [_keyBoardDelegate respondsToSelector:@selector(pressText:)]) {
        [_keyBoardDelegate pressText:tag];
        [self hideKeyboard];
    }
}

- (void)didDeleteButtonTouchDown:(UIButton *)button {
     [self performSelector:@selector(didDeleteButtonLongPressed) withObject:nil afterDelay:0.5];
}

- (void)didDeleteButtonLongPressed {
    if (_keyBoardDelegate && [_keyBoardDelegate respondsToSelector:@selector(longPressDeleteButton)]) {
        [_keyBoardDelegate longPressDeleteButton];
    }
}

#pragma mark - showKeyboard

// 显示键盘
- (void)showKeyboard {
    [self removeAllSubviews];
    [self setNeedsDisplay];
    
    if (kGoldTradeKeyBoardScreenHeight - totalHeight == self.frame.origin.y) {
        return;
    }
    
    if ([_keyBoardDelegate respondsToSelector:@selector(keyboardWillShow:)]) {
        [_keyBoardDelegate keyboardWillShow:self];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, kGoldTradeKeyBoardScreenHeight - totalHeight, kGoldTradeKeyBoardScreenWidth, totalHeight);
//        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([_keyBoardDelegate respondsToSelector:@selector(keyboardDidShow:)]) {
                [_keyBoardDelegate keyboardDidShow:self];
            }
        });
    } completion:^(BOOL finished) {
        
    }];
}

// 收起键盘
- (void)hideKeyboard {
    if (kGoldTradeKeyBoardScreenHeight == self.frame.origin.y) {
        return;
    }
    
    if ([_keyBoardDelegate respondsToSelector:@selector(keyboardWillHide:)]) {
        [_keyBoardDelegate keyboardWillHide:self];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, kGoldTradeKeyBoardScreenHeight, kGoldTradeKeyBoardScreenWidth, totalHeight);
//        self.backgroundColor = [UIColor clearColor];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([_keyBoardDelegate respondsToSelector:@selector(keyboardDidHide:)]) {
                [_keyBoardDelegate keyboardDidHide:self];
            }
        });
    } completion:^(BOOL finished) {
        [self removeAllSubviews];
    }];
}

- (void)destroyKeyboard {
    [self removeFromSuperview];
}

- (void)removeAllSubviews {
    for (UIView *view in _keyBoardView.subviews) {
        [view removeFromSuperview];
    }
}

- (BOOL)isShowing {
    return kGoldTradeKeyBoardScreenHeight - totalHeight == self.frame.origin.y;
}

#pragma mark - Color

UIColor *GoldTradeKeyBoardUIColorWithRGB(NSInteger rgbValue) {
    return ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]);
}

#pragma mark - Cutoff Line
UIImageView *GoldTradeKeyBoardCutoffLineImageViewWithColor(CGRect frame, UIColor *color) {
    UIImageView *cutoffLine = [[UIImageView alloc] init];
    cutoffLine.backgroundColor = color;
    cutoffLine.frame = frame;
    return cutoffLine;
}

@end

@implementation GoldTradeKeyBoardModel


@end
