//
//  UPCTPBlockModel.h
//  FuturesTrade
//
//  Created by UP-LiuL on 17/8/22.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UPCTPDefineHeader.h"

@interface UPCTPBlockModel : NSObject

@property (nonatomic, copy) UPCallback callback;
@property (nonatomic) NSTimeInterval timeInterval;
@property (nonatomic) NSInteger requestCode;

@end
