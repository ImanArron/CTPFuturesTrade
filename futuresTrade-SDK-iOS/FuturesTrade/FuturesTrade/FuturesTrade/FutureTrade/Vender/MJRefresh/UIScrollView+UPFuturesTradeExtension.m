//  代码地址: https://github.com/CoderUPFuturesTradeLee/UPFuturesTradeRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  UIScrollView+Extension.m
//  UPFuturesTradeRefreshExample
//
//  Created by UPFuturesTrade Lee on 14-5-28.
//  Copyright (c) 2014年 小码哥. All rights reserved.
//

#import "UIScrollView+UPFuturesTradeExtension.h"
#import <objc/runtime.h>

@implementation UIScrollView (UPFuturesTradeExtension)

- (void)setUPFuturesTrade_insetT:(CGFloat)UPFuturesTrade_insetT
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = UPFuturesTrade_insetT;
    self.contentInset = inset;
}

- (CGFloat)UPFuturesTrade_insetT
{
    return self.contentInset.top;
}

- (void)setUPFuturesTrade_insetB:(CGFloat)UPFuturesTrade_insetB
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = UPFuturesTrade_insetB;
    self.contentInset = inset;
}

- (CGFloat)UPFuturesTrade_insetB
{
    return self.contentInset.bottom;
}

- (void)setUPFuturesTrade_insetL:(CGFloat)UPFuturesTrade_insetL
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = UPFuturesTrade_insetL;
    self.contentInset = inset;
}

- (CGFloat)UPFuturesTrade_insetL
{
    return self.contentInset.left;
}

- (void)setUPFuturesTrade_insetR:(CGFloat)UPFuturesTrade_insetR
{
    UIEdgeInsets inset = self.contentInset;
    inset.right = UPFuturesTrade_insetR;
    self.contentInset = inset;
}

- (CGFloat)UPFuturesTrade_insetR
{
    return self.contentInset.right;
}

- (void)setUPFuturesTrade_offsetX:(CGFloat)UPFuturesTrade_offsetX
{
    CGPoint offset = self.contentOffset;
    offset.x = UPFuturesTrade_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)UPFuturesTrade_offsetX
{
    return self.contentOffset.x;
}

- (void)setUPFuturesTrade_offsetY:(CGFloat)UPFuturesTrade_offsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = UPFuturesTrade_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)UPFuturesTrade_offsetY
{
    return self.contentOffset.y;
}

- (void)setUPFuturesTrade_contentW:(CGFloat)UPFuturesTrade_contentW
{
    CGSize size = self.contentSize;
    size.width = UPFuturesTrade_contentW;
    self.contentSize = size;
}

- (CGFloat)UPFuturesTrade_contentW
{
    return self.contentSize.width;
}

- (void)setUPFuturesTrade_contentH:(CGFloat)UPFuturesTrade_contentH
{
    CGSize size = self.contentSize;
    size.height = UPFuturesTrade_contentH;
    self.contentSize = size;
}

- (CGFloat)UPFuturesTrade_contentH
{
    return self.contentSize.height;
}
@end
