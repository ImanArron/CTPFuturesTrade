//
//  UPBaseDateUtil.h
//  PurchaseTool
//
//  Created by LiuLian on 17/8/8.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPBaseDateUtil : NSObject

/// 获取当天日期
+ (NSString *)currentDate:(NSString *)dateFormatter;
/// 接口返回的CreateTime(/Date(1501041794000)/)转为标准时间
+ (NSString *)createTime2StandardTime:(NSString *)createTime;
/// 时间戳转为标准时间
+ (NSString *)timeStamp2StandardTime:(NSTimeInterval)timeStamp dateFormat:(NSString *)dateFormat;
/// 获取与date间隔某段时间的日期
+ (NSString *)dateFromDate:(NSDate *)date interval:(int)day dateFormatter:(NSString *)df;
/// 当月的第一天
+ (NSString *)firstDayInTheMonth;
/// 当月的最后一天
+ (NSString *)lastDayInTheMonth;
/// 当周的第一天
+ (NSString *)firstDayInTheWeek;
/// 当周的最后一天
+ (NSString *)lastDayInTheWeek;

@end
