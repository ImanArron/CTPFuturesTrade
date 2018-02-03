//
//  UPTabView.h
//  HQProject
//
//  Created by LiuLian on 15/8/17.
//  Copyright (c) 2015年 UP-LiuL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UPFuturesTradeTabViewDataSource;
@protocol UPFuturesTradeTabViewDelegate;

typedef NS_OPTIONS(NSInteger, UPFuturesTradeTabStyle) {
    NormalStyle = 0,
    CenterStyle = 1,
    AverageStyle = 2,
    NoSelectedLineStyle = 3
};

@interface UPFuturesTradeTabView : UIView

// 0（默认样式）：根据count均分；1：往中部靠拢
@property (nonatomic, assign) UPFuturesTradeTabStyle tabStyle;
@property (nonatomic, assign) NSInteger selectedTab;
@property (nonatomic, weak) id<UPFuturesTradeTabViewDataSource> dataSource;
@property (nonatomic, weak) id<UPFuturesTradeTabViewDelegate> delegate;

@property (nonatomic, assign) BOOL needHorizontalLine;
@property (nonatomic, assign) BOOL needVerticalLine;

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *unselectedColor;
@property (nonatomic, strong) UIColor *selectedTabIdentifierColor;

- (void)reloadTabView;
- (void)setTabBtn:(NSInteger)btnTag hasDelegate:(BOOL)hasDelegate;
- (instancetype)initWithFrame:(CGRect)frame withFont:(UIFont *)font withSelectedColor:(UIColor *)selectedColor withUnselectedColor:(UIColor *)unselectedColor;
- (instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font selectedColor:(UIColor *)selectedColor unselectedColor:(UIColor *)unselectedColor tabStyle:(UPFuturesTradeTabStyle)tabStyle;
- (instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font selectedColor:(UIColor *)selectedColor unselectedColor:(UIColor *)unselectedColor selectedTabIdentifierColor:(UIColor *)selectedTabIdentifierColor tabStyle:(UPFuturesTradeTabStyle)tabStyle;
- (instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font selectedColor:(UIColor *)selectedColor unselectedColor:(UIColor *)unselectedColor selectedTabIdentifierColor:(UIColor *)selectedTabIdentifierColor tabStyle:(UPFuturesTradeTabStyle)tabStyle needHorizontalLine:(BOOL)needHorizontalLine needVerticalLine:(BOOL)needVerticalLine;
- (instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font selectedColor:(UIColor *)selectedColor unselectedColor:(UIColor *)unselectedColor selectedTabIdentifierColor:(UIColor *)selectedTabIdentifierColor tabStyle:(UPFuturesTradeTabStyle)tabStyle needHorizontalLine:(BOOL)needHorizontalLine needVerticalLine:(BOOL)needVerticalLine selectedImageWidth:(NSInteger)selectedImageWidth;

- (void)setHorizontalCutoffLineColor:(UIColor *)color;
- (void)setVerticalCutoffLineColor:(UIColor *)color;

@end

@protocol UPFuturesTradeTabViewDataSource <NSObject>

- (NSArray *)tabArr;

@end

@protocol UPFuturesTradeTabViewDelegate <NSObject>

- (void)didTabSelected:(NSInteger)index;

@end
