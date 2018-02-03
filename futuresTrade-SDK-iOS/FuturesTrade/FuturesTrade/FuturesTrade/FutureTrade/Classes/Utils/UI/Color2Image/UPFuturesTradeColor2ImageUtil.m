//
//  UPFuturesTradeColor2ImageUtil.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/12.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeColor2ImageUtil.h"

@implementation UPFuturesTradeColor2ImageUtil

+ (UIImage*)createImageWithColor:(UIColor *)color frame:(CGRect)frame {
//    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, frame);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
