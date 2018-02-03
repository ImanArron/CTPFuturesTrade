//  代码地址: https://github.com/CoderUPFuturesTradeLee/UPFuturesTradeRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  UIScrollView+UPFuturesTradeRefresh.m
//  UPFuturesTradeRefreshExample
//
//  Created by UPFuturesTrade Lee on 15/3/4.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "UIScrollView+UPFuturesTradeRefresh.h"
#import "UPFuturesTradeRefreshHeader.h"
#import "UPFuturesTradeRefreshFooter.h"
#import <objc/runtime.h>

@implementation NSObject (UPFuturesTradeRefresh)

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}

@end

@implementation UIScrollView (UPFuturesTradeRefresh)

#pragma mark - header
static const char UPFuturesTradeRefreshHeaderKey = '\0';
- (void)setUPFuturesTrade_header:(UPFuturesTradeRefreshHeader *)UPFuturesTrade_header
{
    if (UPFuturesTrade_header != self.UPFuturesTrade_header) {
        // 删除旧的，添加新的
        [self.UPFuturesTrade_header removeFromSuperview];
        [self insertSubview:UPFuturesTrade_header atIndex:0];
        
        // 存储新的
        [self willChangeValueForKey:@"UPFuturesTrade_header"]; // KVO
        objc_setAssociatedObject(self, &UPFuturesTradeRefreshHeaderKey,
                                 UPFuturesTrade_header, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"UPFuturesTrade_header"]; // KVO
    }
}

- (UPFuturesTradeRefreshHeader *)UPFuturesTrade_header
{
    return objc_getAssociatedObject(self, &UPFuturesTradeRefreshHeaderKey);
}

#pragma mark - footer
static const char UPFuturesTradeRefreshFooterKey = '\0';
- (void)setUPFuturesTrade_footer:(UPFuturesTradeRefreshFooter *)UPFuturesTrade_footer
{
    if (UPFuturesTrade_footer != self.UPFuturesTrade_footer) {
        // 删除旧的，添加新的
        [self.UPFuturesTrade_footer removeFromSuperview];
        [self insertSubview:UPFuturesTrade_footer atIndex:0];
        
        // 存储新的
        [self willChangeValueForKey:@"UPFuturesTrade_footer"]; // KVO
        objc_setAssociatedObject(self, &UPFuturesTradeRefreshFooterKey,
                                 UPFuturesTrade_footer, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"UPFuturesTrade_footer"]; // KVO
    }
}

- (UPFuturesTradeRefreshFooter *)UPFuturesTrade_footer
{
    return objc_getAssociatedObject(self, &UPFuturesTradeRefreshFooterKey);
}

#pragma mark - 过期
- (void)setFooter:(UPFuturesTradeRefreshFooter *)footer
{
    self.UPFuturesTrade_footer = footer;
}

- (UPFuturesTradeRefreshFooter *)footer
{
    return self.UPFuturesTrade_footer;
}

- (void)setHeader:(UPFuturesTradeRefreshHeader *)header
{
    self.UPFuturesTrade_header = header;
}

- (UPFuturesTradeRefreshHeader *)header
{
    return self.UPFuturesTrade_header;
}

#pragma mark - other
- (NSInteger)UPFuturesTrade_totalDataCount
{
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        
        for (NSInteger section = 0; section<tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        
        for (NSInteger section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

static const char UPFuturesTradeRefreshReloadDataBlockKey = '\0';
- (void)setUPFuturesTrade_reloadDataBlock:(void (^)(NSInteger))UPFuturesTrade_reloadDataBlock
{
    [self willChangeValueForKey:@"UPFuturesTrade_reloadDataBlock"]; // KVO
    objc_setAssociatedObject(self, &UPFuturesTradeRefreshReloadDataBlockKey, UPFuturesTrade_reloadDataBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"UPFuturesTrade_reloadDataBlock"]; // KVO
}

- (void (^)(NSInteger))UPFuturesTrade_reloadDataBlock
{
    return objc_getAssociatedObject(self, &UPFuturesTradeRefreshReloadDataBlockKey);
}

- (void)executeReloadDataBlock
{
    !self.UPFuturesTrade_reloadDataBlock ? : self.UPFuturesTrade_reloadDataBlock(self.UPFuturesTrade_totalDataCount);
}
@end

@implementation UITableView (UPFuturesTradeRefresh)

+ (void)load
{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(UPFuturesTrade_reloadData)];
}

- (void)UPFuturesTrade_reloadData
{
    [self UPFuturesTrade_reloadData];
    
    [self executeReloadDataBlock];
}
@end

@implementation UICollectionView (UPFuturesTradeRefresh)

+ (void)load
{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(UPFuturesTrade_reloadData)];
}

- (void)UPFuturesTrade_reloadData
{
    [self UPFuturesTrade_reloadData];
    
    [self executeReloadDataBlock];
}
@end
