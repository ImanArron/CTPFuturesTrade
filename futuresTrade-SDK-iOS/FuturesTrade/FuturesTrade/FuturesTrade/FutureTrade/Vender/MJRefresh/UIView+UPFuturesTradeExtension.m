//  代码地址: https://github.com/CoderUPFuturesTradeLee/UPFuturesTradeRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  UIView+Extension.m
//  UPFuturesTradeRefreshExample
//
//  Created by UPFuturesTrade Lee on 14-5-28.
//  Copyright (c) 2014年 小码哥. All rights reserved.
//

#import "UIView+UPFuturesTradeExtension.h"

@implementation UIView (UPFuturesTradeExtension)
- (void)setUPFuturesTrade_x:(CGFloat)UPFuturesTrade_x
{
    CGRect frame = self.frame;
    frame.origin.x = UPFuturesTrade_x;
    self.frame = frame;
}

- (CGFloat)UPFuturesTrade_x
{
    return self.frame.origin.x;
}

- (void)setUPFuturesTrade_y:(CGFloat)UPFuturesTrade_y
{
    CGRect frame = self.frame;
    frame.origin.y = UPFuturesTrade_y;
    self.frame = frame;
}

- (CGFloat)UPFuturesTrade_y
{
    return self.frame.origin.y;
}

- (void)setUPFuturesTrade_w:(CGFloat)UPFuturesTrade_w
{
    CGRect frame = self.frame;
    frame.size.width = UPFuturesTrade_w;
    self.frame = frame;
}

- (CGFloat)UPFuturesTrade_w
{
    return self.frame.size.width;
}

- (void)setUPFuturesTrade_h:(CGFloat)UPFuturesTrade_h
{
    CGRect frame = self.frame;
    frame.size.height = UPFuturesTrade_h;
    self.frame = frame;
}

- (CGFloat)UPFuturesTrade_h
{
    return self.frame.size.height;
}

- (void)setUPFuturesTrade_size:(CGSize)UPFuturesTrade_size
{
    CGRect frame = self.frame;
    frame.size = UPFuturesTrade_size;
    self.frame = frame;
}

- (CGSize)UPFuturesTrade_size
{
    return self.frame.size;
}

- (void)setUPFuturesTrade_origin:(CGPoint)UPFuturesTrade_origin
{
    CGRect frame = self.frame;
    frame.origin = UPFuturesTrade_origin;
    self.frame = frame;
}

- (CGPoint)UPFuturesTrade_origin
{
    return self.frame.origin;
}
@end
