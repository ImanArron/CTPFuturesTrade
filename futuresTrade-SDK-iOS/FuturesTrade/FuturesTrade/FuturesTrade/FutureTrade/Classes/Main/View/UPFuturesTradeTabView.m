//
//  UPTabView.m
//  HQProject
//
//  Created by LiuLian on 15/8/17.
//  Copyright (c) 2015年 UP-LiuL. All rights reserved.
//

#import "UPFuturesTradeTabView.h"

#define UPTabViewCutoffLineWidth (0.5)
#define UPTabViewCutoffLineHeight (0.5)

@interface UPFuturesTradeTabView ()
{
    UIColor *horizontalCutoffLineColor;
    UIColor *verticalCutoffLineColor;
}

@property (nonatomic, strong) UIScrollView *tabView;
@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, copy) NSArray *tabArr;
@property (nonatomic, assign) CGFloat buttonWidth;

@property (nonatomic, assign) NSInteger selectedImageWidth;

@property (nonatomic, assign) NSInteger tabHeight;

@end

@implementation UPFuturesTradeTabView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _tabHeight = frame.size.height;
        [self setDefaultFontAndColor];
        [self loadSubviews];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _tabHeight = 44;
        [self setDefaultFontAndColor];
        [self loadSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withFont:(UIFont *)font withSelectedColor:(UIColor *)selectedColor withUnselectedColor:(UIColor *)unselectedColor {
    self = [super initWithFrame:frame];
    if (self) {
        _tabHeight = frame.size.height;
        _titleFont = font;
        _selectedColor = selectedColor;
        _unselectedColor = unselectedColor;
        [self loadSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font selectedColor:(UIColor *)selectedColor unselectedColor:(UIColor *)unselectedColor tabStyle:(UPFuturesTradeTabStyle)tabStyle {
    [self setDefaultFontAndColor];
    _tabStyle = tabStyle;
    return [self initWithFrame:frame withFont:font withSelectedColor:selectedColor withUnselectedColor:unselectedColor];
}

- (instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font selectedColor:(UIColor *)selectedColor unselectedColor:(UIColor *)unselectedColor selectedTabIdentifierColor:(UIColor *)selectedTabIdentifierColor tabStyle:(UPFuturesTradeTabStyle)tabStyle {
    _selectedTabIdentifierColor = selectedTabIdentifierColor;
    return [self initWithFrame:frame font:font selectedColor:selectedColor unselectedColor:unselectedColor tabStyle:tabStyle];
}

- (instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font selectedColor:(UIColor *)selectedColor unselectedColor:(UIColor *)unselectedColor selectedTabIdentifierColor:(UIColor *)selectedTabIdentifierColor tabStyle:(UPFuturesTradeTabStyle)tabStyle needHorizontalLine:(BOOL)needHorizontalLine needVerticalLine:(BOOL)needVerticalLine {
    _needHorizontalLine = needHorizontalLine;
    _needVerticalLine = needVerticalLine;
    return [self initWithFrame:frame font:font selectedColor:selectedColor unselectedColor:unselectedColor selectedTabIdentifierColor:selectedTabIdentifierColor tabStyle:tabStyle];
}

- (instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font selectedColor:(UIColor *)selectedColor unselectedColor:(UIColor *)unselectedColor selectedTabIdentifierColor:(UIColor *)selectedTabIdentifierColor tabStyle:(UPFuturesTradeTabStyle)tabStyle needHorizontalLine:(BOOL)needHorizontalLine needVerticalLine:(BOOL)needVerticalLine selectedImageWidth:(NSInteger)selectedImageWidth {
    _selectedImageWidth = selectedImageWidth;
    return [self initWithFrame:frame font:font selectedColor:selectedColor unselectedColor:unselectedColor selectedTabIdentifierColor:selectedTabIdentifierColor tabStyle:tabStyle needHorizontalLine:needHorizontalLine needVerticalLine:needVerticalLine];
}

- (void)setDefaultFontAndColor {
    if (!_titleFont) {
        _titleFont = [UIFont systemFontOfSize:16];
    }
    if (!_selectedColor) {
        _selectedColor = UPTabViewUIColorWithRGB(0xff4900);
    }
    if (!_unselectedColor) {
        _unselectedColor = UPTabViewUIColorWithRGB(0x333333);
    }
    if (!_selectedTabIdentifierColor) {
        _selectedTabIdentifierColor = _selectedColor;
    }
    if (0 == _tabHeight) {
        _tabHeight = 44;
    }
    if (!horizontalCutoffLineColor) {
        [self setHorizontalCutoffLineColor:UPTabViewUIColorWithRGB(0xebebeb)];
    }
    if (!verticalCutoffLineColor) {
        [self setVerticalCutoffLineColor:UPTabViewUIColorWithRGB(0xebebeb)];
    }
}

- (void)setHorizontalCutoffLineColor:(UIColor *)color {
    horizontalCutoffLineColor = color;
}

- (void)setVerticalCutoffLineColor:(UIColor *)color {
    verticalCutoffLineColor = color;
}

#pragma mark - Load Subviews

- (void)loadSubviews {
    _tabView = [[UIScrollView alloc] init];
    _tabView.backgroundColor = [UIColor clearColor];
    _tabView.frame = CGRectMake(0, 0, self.frame.size.width, _tabHeight);
    _tabView.showsHorizontalScrollIndicator = NO;
    _tabView.showsVerticalScrollIndicator = NO;
    _tabView.bounces = NO;
    [self addSubview:_tabView];
}

- (UIImageView *)selectedImageView {
    if (!_selectedImageView) {
        _selectedImageView = [[UIImageView alloc] init];
         [self.selectedImageView setCenter:CGPointMake(self.buttonWidth/2, _tabHeight - 1.5)];
        _selectedImageView.backgroundColor = _selectedTabIdentifierColor;
        _selectedImageView.hidden = NO;
        
        if (NoSelectedLineStyle == _tabStyle) {
            _selectedImageView.hidden = YES;
        }
    }
    return _selectedImageView;
}

- (void)reloadTabView {
    _tabArr = nil;
    if (_dataSource && [_dataSource tabArr]) {
        _tabArr = [_dataSource tabArr];
    }
    
    if (_tabArr && _tabArr.count > 0) {
        self.selectedImageView.frame = CGRectMake(0, 0, 50, 3);
        if (AverageStyle == _tabStyle) {
            self.selectedImageView.frame = CGRectMake(0, 0, self.buttonWidth, 3);
        } else if (CenterStyle == _tabStyle) {
            self.selectedImageView.frame = CGRectMake(0, 0, self.buttonWidth - 20, 3);
        }
        
//        if (_selectedImageWidth > 0) {
        self.selectedImageView.frame = CGRectMake(0, 0, _selectedImageWidth, 3);
//        }
        
        // 先清除_tabView的所有子视图，避免重复
        for (UIView *subview in _tabView.subviews) {
            if (subview) {
                [subview removeFromSuperview];
            }
        }
        
        CGFloat tabWidth = self.frame.size.width;
        if (tabWidth < _tabArr.count * self.buttonWidth) {
            tabWidth = _tabArr.count * self.buttonWidth;
        }
        [_tabView setContentSize:CGSizeMake(tabWidth, _tabView.frame.size.height)];
        
        if (_needHorizontalLine) {
            // 添加横向分割线
            UIView *horizontalCutoffLine = [[UIView alloc] init];
            horizontalCutoffLine.backgroundColor = horizontalCutoffLineColor;
            horizontalCutoffLine.frame = CGRectMake(0, _tabHeight - UPTabViewCutoffLineHeight, tabWidth, UPTabViewCutoffLineHeight);
            [_tabView addSubview:horizontalCutoffLine];
        }
        
        // 添加按钮
        CGFloat startX = (tabWidth - _tabArr.count * self.buttonWidth)/2;
        if ( startX < 0 ) {
            startX = 0;
        }
        
        for (NSInteger i = 0; i < _tabArr.count; i++) {
            @autoreleasepool {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = i;
                btn.backgroundColor = [UIColor clearColor];
                btn.frame = CGRectMake(self.buttonWidth * i, 0, self.buttonWidth, _tabHeight);
                if (CenterStyle == _tabStyle) {
                    btn.frame = CGRectMake(startX + self.buttonWidth * i, 0, self.buttonWidth, _tabHeight);
                }
                btn.titleLabel.font = _titleFont;
                [btn setTitleColor:_unselectedColor forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(didTabBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                [_tabView addSubview:btn];
                NSString *title = _tabArr[i];
                if (title) {
                    [btn setTitle:title forState:UIControlStateNormal];
                }
                
                if (_needVerticalLine) {
                    // 添加竖向分割线
                    if (i != _tabArr.count - 1) {
                        UIView *verticalCutoffLine = [[UIView alloc] init];
                        verticalCutoffLine.backgroundColor = verticalCutoffLineColor;
                        verticalCutoffLine.frame = CGRectMake(self.buttonWidth - UPTabViewCutoffLineWidth, (_tabHeight - 18)/2, UPTabViewCutoffLineWidth, 18);
                        [btn addSubview:verticalCutoffLine];
                    }
                }
                
                if (_selectedTab == i) {
                    [btn setTitleColor:_selectedColor forState:UIControlStateNormal];
                    [btn addSubview:self.selectedImageView];
                    [self.selectedImageView setCenter:CGPointMake(self.buttonWidth/2, _tabHeight - 1.5)];
                }
            }
        }
    }
}

- (void)didTabBtnPressed:(id)sender {
    NSInteger tag = ((UIButton *)sender).tag;
    _selectedTab = tag;
    [self setTabBtn:_selectedTab hasDelegate:YES];
}

- (void)setTabBtn:(NSInteger)btnTag hasDelegate:(BOOL)hasDelegate {
    if (_tabView && (_tabArr && _tabArr.count > 0)) {
        for (UIView *subview in _tabView.subviews) {
            if ([subview isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)subview;
                // 被选中的按钮
                if (btnTag == btn.tag)
                {
                    _selectedTab = btnTag;
                    [btn setTitleColor:_selectedColor forState:UIControlStateNormal];
                    if (![self isSelectedImageViewExistInBtn:btn]) {
                        [btn addSubview:self.selectedImageView];
                    }
                    [self.selectedImageView setCenter:CGPointMake(self.buttonWidth/2, _tabHeight - 1.5)];
                }
                // 未被选中的按钮
                else
                {
                    [btn setTitleColor:_unselectedColor forState:UIControlStateNormal];
                }
            }
        }
        
        // 滚动到可见位置
        CGFloat frameWidth = self.frame.size.width;
        CGFloat tabWidth = frameWidth;
        if (tabWidth < _tabArr.count * self.buttonWidth) {
            tabWidth = _tabArr.count * self.buttonWidth;
        }
        
        if (tabWidth > frameWidth) {
            CGFloat btnTailX = self.buttonWidth * (btnTag + 2);
            CGFloat scrollX = _tabView.contentOffset.x;
            if ( btnTailX >= frameWidth - self.buttonWidth ) {
                CGFloat scrollWidth = btnTailX - (frameWidth - self.buttonWidth);
                if (scrollWidth > self.buttonWidth) {
                    if (scrollWidth < 2 * self.buttonWidth) {
                        scrollWidth = self.buttonWidth;
                    } else {
                        scrollWidth -= self.buttonWidth;
                    }
                }
                if (btnTag < _tabArr.count - 1) {
                    [_tabView setContentOffset:CGPointMake(scrollWidth, 0) animated:YES];
                }
            } else if (btnTailX <= 3 * self.buttonWidth && scrollX > 0) {
                [_tabView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
        }
        
        if (hasDelegate && _delegate && [_delegate respondsToSelector:@selector(didTabSelected:)]) {
            [_delegate didTabSelected:_selectedTab];
        }
    }
}

- (BOOL)isSelectedImageViewExistInBtn:(UIButton *)btn {
    if (btn) {
        for (UIView *subview in btn.subviews) {
            if ([subview isEqual:self.selectedImageView]) {
                return YES;
            }
        }
    }
    return NO;
}

- (CGFloat)buttonWidth {
    if (0 == _buttonWidth) {
        CGFloat width = self.frame.size.width;
        _buttonWidth = width/4;
        if ((AverageStyle == _tabStyle || NoSelectedLineStyle == _tabStyle) && self.tabArr.count > 0) {
            _buttonWidth = width/self.tabArr.count;
        }
        if (_selectedImageWidth > 0) {
            NSInteger count = self.tabArr.count;
            while (_selectedImageWidth > _buttonWidth && --count > 0) {
                _buttonWidth = width/count;
            }
        }
    }
    return _buttonWidth;
}

#pragma mark - Color

UIColor *UPTabViewUIColorWithRGB(NSInteger rgbValue) {
    return ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]);
}

@end
