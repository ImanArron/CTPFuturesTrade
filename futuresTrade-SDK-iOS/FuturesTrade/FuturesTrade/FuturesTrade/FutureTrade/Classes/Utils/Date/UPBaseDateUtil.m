//
//  UPBaseDateUtil.m
//  PurchaseTool
//
//  Created by LiuLian on 17/8/8.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPBaseDateUtil.h"

@implementation UPBaseDateUtil

+ (NSString *)currentDate:(NSString *)dateFormatter {
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:dateFormatter ? dateFormatter : @"yyyy-MM-dd"];
    return [df stringFromDate:date];
}

+ (NSString *)createTime2StandardTime:(NSString *)createTime {
    NSString *time = [createTime copy];
    if (NSNotFound != [time rangeOfString:@"/"].location) {
        time = [time stringByReplacingOccurrencesOfString:@"/" withString:@""];
    }
    if (NSNotFound != [time rangeOfString:@"Date"].location) {
        time = [time stringByReplacingOccurrencesOfString:@"Date" withString:@""];
    }
    if (NSNotFound != [time rangeOfString:@"("].location) {
        time = [time stringByReplacingOccurrencesOfString:@"(" withString:@""];
    }
    if (NSNotFound != [time rangeOfString:@")"].location) {
        time = [time stringByReplacingOccurrencesOfString:@")" withString:@""];
    }
    
    return [self timeStamp2StandardTime:time.integerValue dateFormat:nil];
}

+ (NSString *)timeStamp2StandardTime:(NSTimeInterval)timeStamp dateFormat:(NSString *)dateFormat {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp > powl(10, 10) ? timeStamp/1000 : timeStamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (dateFormat) {
        [dateFormatter setDateFormat:dateFormat];
    } else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSString *standardTime = [dateFormatter stringFromDate:date];
    return standardTime;
}

+ (NSString *)dateFromDate:(NSDate *)date interval:(int)day dateFormatter:(NSString *)df {
    NSDate *tempDate = [NSDate dateWithTimeInterval:24 * 60 * 60 * day sinceDate:date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    if (nil == df) {
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
    } else {
        [dateformatter setDateFormat:df];
    }
    return [dateformatter stringFromDate:tempDate];
}

+ (NSString *)beginAndEnd:(NSCalendarUnit)calendarUnit {
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 设定周一为周首日
    [calendar setFirstWeekday:2];
    BOOL ok = [calendar rangeOfUnit:calendarUnit startDate:&beginDate interval:&interval forDate:[NSDate date]];
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    } else {
        return @"";
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    return [NSString stringWithFormat:@"%@~%@", beginString, endString];
}

+ (NSArray *)beginAndEndString2Array:(NSString *)beginAndEnd {
    if (NSNotFound != [beginAndEnd rangeOfString:@"~"].location) {
        return [beginAndEnd componentsSeparatedByString:@"~"];
    }
    
    return nil;
}

+ (NSString *)firstDayInTheMonth {
    NSString *beginAndEndOfMonth = [self beginAndEnd:NSCalendarUnitMonth];
    NSArray *array = [self beginAndEndString2Array:beginAndEndOfMonth];
    if (2 == array.count) {
        return array[0];
    }
    return @"";
}

+ (NSString *)lastDayInTheMonth {
    NSString *beginAndEndOfMonth = [self beginAndEnd:NSCalendarUnitMonth];
    NSArray *array = [self beginAndEndString2Array:beginAndEndOfMonth];
    if (2 == array.count) {
        return array[1];
    }
    return @"";
}

+ (NSString *)firstDayInTheWeek {
    NSString *beginAndEndOfMonth = [self beginAndEnd:NSCalendarUnitWeekOfMonth];
    NSArray *array = [self beginAndEndString2Array:beginAndEndOfMonth];
    if (2 == array.count) {
        return array[0];
    }
    return @"";
}

+ (NSString *)lastDayInTheWeek {
    NSString *beginAndEndOfMonth = [self beginAndEnd:NSCalendarUnitWeekOfMonth];
    NSArray *array = [self beginAndEndString2Array:beginAndEndOfMonth];
    if (2 == array.count) {
        return array[1];
    }
    return @"";
}

@end
