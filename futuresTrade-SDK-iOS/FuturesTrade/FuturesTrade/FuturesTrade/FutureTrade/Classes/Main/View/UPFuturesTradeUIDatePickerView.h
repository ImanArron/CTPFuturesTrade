//
//  MyUIDatePickerView.h
//  KCool
//
//  Created by Brian on 13-12-3.
//  Copyright (c) 2013年 Brian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UPFuturesTradeUIDatePickerViewDelegate;

@interface UPFuturesTradeUIDatePickerView : UIView

@property (nonatomic, strong) UIDatePicker *theDatePicker;
@property (nonatomic, assign) id<UPFuturesTradeUIDatePickerViewDelegate>delegate;
@property (nonatomic, copy) NSString *dateFormat;
@property (nonatomic) UIDatePickerMode pickType;

- (void)show;
- (void)showWith;
- (void)hidden;
- (void)loadTheDateView:(NSString *)title withMaxDate:(NSDate *)maxDate withMinDate:(NSDate *)minDate;

@end

@protocol UPFuturesTradeUIDatePickerViewDelegate <NSObject>

- (void)datePickerView:(UPFuturesTradeUIDatePickerView *)pickerView didSelectedDate:(NSString *)theDateString;

@end
