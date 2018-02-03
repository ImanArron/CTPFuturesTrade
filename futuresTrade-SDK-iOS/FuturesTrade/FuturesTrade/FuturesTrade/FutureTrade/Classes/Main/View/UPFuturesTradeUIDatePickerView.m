//
//  MyUIDatePickerView.m
//  KCool
//
//  Created by Brian on 13-12-3.
//  Copyright (c) 2013年 Brian. All rights reserved.
//

#import "UPFuturesTradeUIDatePickerView.h"

#define kDatePickerScreenWidth    [[UIScreen mainScreen] bounds].size.width
#define kDatePickerScreenHeight   [[UIScreen mainScreen] bounds].size.height

@implementation UPFuturesTradeUIDatePickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0.0, kDatePickerScreenHeight, kDatePickerScreenWidth, 206);
        _dateFormat = @"";
        _pickType = UIDatePickerModeDate;
    }
    return self;
}


- (void)loadTheDateView:(NSString *)title withMaxDate:(NSDate *)maxDate withMinDate:(NSDate *)minDate {
    _theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 40.0, kDatePickerScreenWidth, 162.0)];
    self.theDatePicker.minuteInterval = 5;
    if (_pickType == UIDatePickerModeDateAndTime)
        self.theDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    else if (_pickType == UIDatePickerModeTime)
        self.theDatePicker.datePickerMode = UIDatePickerModeTime;
    else
        self.theDatePicker.datePickerMode = UIDatePickerModeDate;
    if (maxDate) {
        self.theDatePicker.maximumDate = maxDate;
    }
    if (minDate) {
        self.theDatePicker.minimumDate = minDate;
    }
    self.theDatePicker.locale = [NSLocale currentLocale];
    
    self.backgroundColor = [UIColor whiteColor];
    UINavigationItem* nav = [[UINavigationItem alloc] initWithTitle:title];
    UIBarButtonItem* cancelBar = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleThePick)];
    UIBarButtonItem* confirmBar = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(choseThePick)];
    UINavigationBar* navp = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, kDatePickerScreenWidth, 44.0)];
    nav.leftBarButtonItem = cancelBar;
    nav.rightBarButtonItem = confirmBar;
    navp.items = [NSArray arrayWithObject:nav];
    [self addSubview:navp];
    [self addSubview:self.theDatePicker];
}

- (void)choseThePick
{
    [UIView beginAnimations:nil context:NULL];
    self.frame = CGRectMake(0.0, kDatePickerScreenHeight - 20, kDatePickerScreenWidth, 206);
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    if (_pickType == UIDatePickerModeDateAndTime) {
        if (_dateFormat.length == 0)
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        else
            [dateFormatter setDateFormat:_dateFormat];
    } else if (_pickType == UIDatePickerModeTime) {
        if (_dateFormat.length == 0)
            [dateFormatter setDateFormat:@"HH:mm"];
        else
            [dateFormatter setDateFormat:_dateFormat];
    } else {
        if (_dateFormat.length == 0)
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        else
            [dateFormatter setDateFormat:_dateFormat];
    }
    NSString *destDateString = [dateFormatter stringFromDate:self.theDatePicker.date];
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(datePickerView:didSelectedDate:)]) {
            [self.delegate datePickerView:self didSelectedDate:destDateString];
        }
    }
    [UIView setAnimationCurve:1];
    [UIView setAnimationDuration:1.0f];
    [UIView commitAnimations];
}

- (void)cancleThePick
{
    [UIView beginAnimations:nil context:NULL];
    self.frame = CGRectMake(0.0, kDatePickerScreenHeight, kDatePickerScreenWidth, 206);
    [UIView setAnimationCurve:1];
    [UIView setAnimationDuration:1.0f];
    [UIView commitAnimations];
}


- (void)show
{
    [self.superview bringSubviewToFront:self];
    [UIView beginAnimations:nil context:NULL];
    self.frame = CGRectMake(0.0, kDatePickerScreenHeight - 206.0, kDatePickerScreenWidth, 206);
    [UIView setAnimationCurve:1];
    [UIView setAnimationDuration:1.0f];
    [UIView commitAnimations];
}

- (void)showWith
{
    [self.superview bringSubviewToFront:self];
    [UIView beginAnimations:nil context:NULL];
    self.frame = CGRectMake(0.0, kDatePickerScreenHeight - 64.0 - 206.0, kDatePickerScreenWidth, 206);
    [UIView setAnimationCurve:1];
    [UIView setAnimationDuration:1.0f];
    [UIView commitAnimations];
}

- (void)hidden
{
    [UIView beginAnimations:nil context:NULL];
    self.frame = CGRectMake(0.0, kDatePickerScreenHeight, kDatePickerScreenWidth, 206);
    [UIView setAnimationCurve:1];
    [UIView setAnimationDuration:1.0f];
    [UIView commitAnimations];
}

@end
