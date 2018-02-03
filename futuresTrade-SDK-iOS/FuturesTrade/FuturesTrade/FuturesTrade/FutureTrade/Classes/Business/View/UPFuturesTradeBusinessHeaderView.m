//
//  UPFuturesTradeBusinessHeaderView.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/8/30.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeBusinessHeaderView.h"
#import "UPFuturesTradeTabView.h"
#import "UPFuturesTradeMacros.h"

NSString * const UPFuturesTradeBusinessHeaderViewReuseId = @"UPFuturesTradeBusinessHeaderView";

@interface UPFuturesTradeBusinessHeaderView () <UPFuturesTradeTabViewDataSource, UPFuturesTradeTabViewDelegate>

// tab
@property (nonatomic, strong) UPFuturesTradeTabView *upTabView;
// 选中的tab
@property (nonatomic, assign) NSInteger selectedTab;
// tab是否被点击
@property (nonatomic, assign) BOOL isTabBtnPressed;
@property (nonatomic, assign) BOOL isScrolled;

@end

@implementation UPFuturesTradeBusinessHeaderView

- (void)setupTabView {
    if (!_upTabView) {
        _upTabView = [[UPFuturesTradeTabView alloc] initWithFrame:CGRectMake(0, 0, kFutursTradeScreenWidth, 44) font:[UIFont systemFontOfSize:15] selectedColor:UPColorFromRGB(0xe03633) unselectedColor:UPColorFromRGB(0x333333) selectedTabIdentifierColor:UPColorFromRGB(0xe03633) tabStyle:AverageStyle needHorizontalLine:YES needVerticalLine:NO selectedImageWidth:35];
        _upTabView.backgroundColor = [UIColor clearColor];
        _upTabView.dataSource = self;
        _upTabView.delegate = self;
        [self addSubview:_upTabView];
        [_upTabView reloadTabView];
    } else {
        [_upTabView setTabBtn:_selectedTab hasDelegate:NO];
    }
}

#pragma mark - UPFuturesTradeTabViewDataSource, UPFuturesTradeTabViewDelegate
-(NSArray *)tabArr {
    return @[
             @"持仓",
             @"可撤"
//             @"走势",
//             @"自选"
             ];
}

- (void)didTabSelected:(NSInteger)index {
    if (_isScrolled) {
        _isScrolled = NO;
    } else {
        _isTabBtnPressed = YES;
        _selectedTab = index;
        if (_block) {
            _block(_selectedTab);
        }
    }
}

@end
