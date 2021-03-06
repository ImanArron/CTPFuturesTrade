//  代码地址: https://github.com/CoderUPFuturesTradeLee/UPFuturesTradeRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  UPFuturesTradeRefreshHeader.m
//  UPFuturesTradeRefreshExample
//
//  Created by UPFuturesTrade Lee on 15/3/4.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "UPFuturesTradeRefreshHeader.h"

@interface UPFuturesTradeRefreshHeader()
@property (assign, nonatomic) CGFloat insetTDelta;
@end

@implementation UPFuturesTradeRefreshHeader
#pragma mark - 构造方法
+ (instancetype)headerWithRefreshingBlock:(UPFuturesTradeRefreshComponentRefreshingBlock)refreshingBlock
{
    UPFuturesTradeRefreshHeader *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    UPFuturesTradeRefreshHeader *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
}

#pragma mark - 覆盖父类的方法
- (void)prepare
{
    [super prepare];
    
    // 设置key
    self.lastUpdatedTimeKey = UPFuturesTradeRefreshHeaderLastUpdatedTimeKey;
    
    // 设置高度
    self.UPFuturesTrade_h = UPFuturesTradeRefreshHeaderHeight;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    // 设置y值(当自己的高度发生改变了，肯定要重新调整Y值，所以放到placeSubviews方法中设置y值)
    self.UPFuturesTrade_y = - self.UPFuturesTrade_h - self.ignoredScrollViewContentInsetTop;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    // 在刷新的refreshing状态
    if (self.state == UPFuturesTradeRefreshStateRefreshing) {
        if (self.window == nil) return;
        
        // sectionheader停留解决
        CGFloat insetT = - self.scrollView.UPFuturesTrade_offsetY > _scrollViewOriginalInset.top ? - self.scrollView.UPFuturesTrade_offsetY : _scrollViewOriginalInset.top;
        insetT = insetT > self.UPFuturesTrade_h + _scrollViewOriginalInset.top ? self.UPFuturesTrade_h + _scrollViewOriginalInset.top : insetT;
        self.scrollView.UPFuturesTrade_insetT = insetT;
        
        self.insetTDelta = _scrollViewOriginalInset.top - insetT;
        return;
    }
    
    // 跳转到下一个控制器时，contentInset可能会变
     _scrollViewOriginalInset = self.scrollView.contentInset;
    
    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.UPFuturesTrade_offsetY;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    
    // 如果是向上滚动到看不见头部控件，直接返回
    // >= -> >
    if (offsetY > happenOffsetY) return;
    
    // 普通 和 即将刷新 的临界点
    CGFloat normal2pullingOffsetY = happenOffsetY - self.UPFuturesTrade_h;
    CGFloat pullingPercent = (happenOffsetY - offsetY) / self.UPFuturesTrade_h;
    
    if (self.scrollView.isDragging) { // 如果正在拖拽
        self.pullingPercent = pullingPercent;
        if (self.state == UPFuturesTradeRefreshStateIdle && offsetY < normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.state = UPFuturesTradeRefreshStatePulling;
        } else if (self.state == UPFuturesTradeRefreshStatePulling && offsetY >= normal2pullingOffsetY) {
            // 转为普通状态
            self.state = UPFuturesTradeRefreshStateIdle;
        }
    } else if (self.state == UPFuturesTradeRefreshStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
        [self beginRefreshing];
    } else if (pullingPercent < 1) {
        self.pullingPercent = pullingPercent;
    }
}

- (void)setState:(UPFuturesTradeRefreshState)state
{
    UPFuturesTradeRefreshCheckState
    
    // 根据状态做事情
    if (state == UPFuturesTradeRefreshStateIdle) {
        if (oldState != UPFuturesTradeRefreshStateRefreshing) return;
        
        // 保存刷新时间
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.lastUpdatedTimeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 恢复inset和offset
        [UIView animateWithDuration:UPFuturesTradeRefreshSlowAnimationDuration animations:^{
            self.scrollView.UPFuturesTrade_insetT += self.insetTDelta;
            
            // 自动调整透明度
            if (self.isAutomaticallyChangeAlpha) self.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.pullingPercent = 0.0;
            
            if (self.endRefreshingCompletionBlock) {
                self.endRefreshingCompletionBlock();
            }
        }];
    } else if (state == UPFuturesTradeRefreshStateRefreshing) {
         dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:UPFuturesTradeRefreshFastAnimationDuration animations:^{
                CGFloat top = self.scrollViewOriginalInset.top + self.UPFuturesTrade_h;
                // 增加滚动区域top
                self.scrollView.UPFuturesTrade_insetT = top;
                // 设置滚动位置
                [self.scrollView setContentOffset:CGPointMake(0, -top) animated:NO];
            } completion:^(BOOL finished) {
                [self executeRefreshingCallback];
            }];
         });
    }
}

#pragma mark - 公共方法
- (void)endRefreshing
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.state = UPFuturesTradeRefreshStateIdle;
    });
}

- (NSDate *)lastUpdatedTime
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:self.lastUpdatedTimeKey];
}
@end
