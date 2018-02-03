//
//  UPFuturesTradeInputCell.h
//  FuturesTradeDemo
//
//  Created by LiuLian on 17/8/28.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UPFuturesTradeInputCellViewModel;

extern NSString * const UPFuturesTradeInputCellReuseId;

typedef void(^UPFuturesTradeInputBlock)(UPFuturesTradeInputCellViewModel *model);
typedef void(^UPFuturesTradeInputButtonClickedBlock)(void);

@interface UPFuturesTradeInputCell : UITableViewCell

@property (nonatomic, copy) UPFuturesTradeInputBlock block;
@property (nonatomic, copy) UPFuturesTradeInputButtonClickedBlock clickBlock;
@property (nonatomic, strong) UPFuturesTradeInputCellViewModel *viewModel;

@end

@interface UPFuturesTradeInputCellViewModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) BOOL showArrow;
@property (nonatomic, assign) NSInteger keyboardType;
@property (nonatomic, assign) BOOL secureTextEntry;

@end
