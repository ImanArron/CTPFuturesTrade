//
//  ColorMacros.h
//  PurchaseTool
//
//  Created by hubupc on 2017/8/1.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#ifndef UPFuturesTradeColor_h
#define UPFuturesTradeColor_h

// NavBar
#define kNavBarTitleColor       UPColorFromRGB(0xffffff)
#define kNavBarBkgColor         UPColorFromRGB(0x3374ff)
#define kNavBarItemColor        UPColorFromRGB(0xffffff)

// TabBar
#define kTabBarTitleColorNor    UPColorFromRGB(0x818181)
#define kTabBarTitleColorSel    UPColorFromRGB(0x2595ff)

// 颜色
#define UPColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UPRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define UPRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]


#endif /* UPFuturesTradeColor_h */
