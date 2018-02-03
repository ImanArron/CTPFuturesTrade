//  代码地址: https://github.com/CoderUPFuturesTradeLee/UPFuturesTradeRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
#import <UIKit/UIKit.h>
#import <objc/message.h>

// 弱引用
//#define UPFuturesTradeWeakSelf __weak typeof(self) weakSelf = self;

// 日志输出
#ifdef DEBUG
#define UPFuturesTradeRefreshLog(...) NSLog(__VA_ARGS__)
#else
#define UPFuturesTradeRefreshLog(...)
#endif

// 过期提醒
#define UPFuturesTradeRefreshDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

// 运行时objc_msgSend
#define UPFuturesTradeRefreshMsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define UPFuturesTradeRefreshMsgTarget(target) (__bridge void *)(target)

// RGB颜色
#define UPFuturesTradeRefreshColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 文字颜色
#define UPFuturesTradeRefreshLabelTextColor UPFuturesTradeRefreshColor(90, 90, 90)

// 字体大小
#define UPFuturesTradeRefreshLabelFont [UIFont boldSystemFontOfSize:14]

// 常量
UIKIT_EXTERN const CGFloat UPFuturesTradeRefreshLabelLeftInset;
UIKIT_EXTERN const CGFloat UPFuturesTradeRefreshHeaderHeight;
UIKIT_EXTERN const CGFloat UPFuturesTradeRefreshFooterHeight;
UIKIT_EXTERN const CGFloat UPFuturesTradeRefreshFastAnimationDuration;
UIKIT_EXTERN const CGFloat UPFuturesTradeRefreshSlowAnimationDuration;

UIKIT_EXTERN NSString *const UPFuturesTradeRefreshKeyPathContentOffset;
UIKIT_EXTERN NSString *const UPFuturesTradeRefreshKeyPathContentSize;
UIKIT_EXTERN NSString *const UPFuturesTradeRefreshKeyPathContentInset;
UIKIT_EXTERN NSString *const UPFuturesTradeRefreshKeyPathPanState;

UIKIT_EXTERN NSString *const UPFuturesTradeRefreshHeaderLastUpdatedTimeKey;

UIKIT_EXTERN NSString *const UPFuturesTradeRefreshHeaderIdleText;
UIKIT_EXTERN NSString *const UPFuturesTradeRefreshHeaderPullingText;
UIKIT_EXTERN NSString *const UPFuturesTradeRefreshHeaderRefreshingText;

UIKIT_EXTERN NSString *const UPFuturesTradeRefreshAutoFooterIdleText;
UIKIT_EXTERN NSString *const UPFuturesTradeRefreshAutoFooterRefreshingText;
UIKIT_EXTERN NSString *const UPFuturesTradeRefreshAutoFooterNoMoreDataText;

UIKIT_EXTERN NSString *const UPFuturesTradeRefreshBackFooterIdleText;
UIKIT_EXTERN NSString *const UPFuturesTradeRefreshBackFooterPullingText;
UIKIT_EXTERN NSString *const UPFuturesTradeRefreshBackFooterRefreshingText;
UIKIT_EXTERN NSString *const UPFuturesTradeRefreshBackFooterNoMoreDataText;

UIKIT_EXTERN NSString *const UPFuturesTradeRefreshHeaderLastTimeText;
UIKIT_EXTERN NSString *const UPFuturesTradeRefreshHeaderDateTodayText;
UIKIT_EXTERN NSString *const UPFuturesTradeRefreshHeaderNoneLastDateText;

// 状态检查
#define UPFuturesTradeRefreshCheckState \
UPFuturesTradeRefreshState oldState = self.state; \
if (state == oldState) return; \
[super setState:state];
