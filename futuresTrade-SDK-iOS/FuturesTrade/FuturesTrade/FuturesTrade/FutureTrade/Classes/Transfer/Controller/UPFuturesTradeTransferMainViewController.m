//
//  UPFuturesTradeTransferMainViewController.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/7.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeTransferMainViewController.h"
#import "UPFuturesTradeTabView.h"
#import "UPFuturesTradeTransferInViewController.h"
#import "UPFuturesTradeTransferOutViewController.h"
#import "UPFuturesTradeTransferSerialViewController.h"

@interface UPFuturesTradeTransferMainViewController () <UPFuturesTradeTabViewDataSource, UPFuturesTradeTabViewDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSMutableArray *viewControllers;

// tab
@property (nonatomic, strong) UPFuturesTradeTabView *upTabView;
@property (nonatomic, assign) NSInteger selectedTab;
@property (nonatomic, assign) NSInteger lastIndex;
@property (nonatomic, assign) NSInteger nextIndex;

@property (weak, nonatomic) IBOutlet UIView *headerTabView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation UPFuturesTradeTransferMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavBar];
    [self setupTabView];
    [self setupPageViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavBar {
    self.navigationItem.title = @"银期转账";
}

- (void)setupTabView {
    _upTabView = [[UPFuturesTradeTabView alloc] initWithFrame:CGRectMake(0, 0, kFutursTradeScreenWidth, 44) font:[UIFont systemFontOfSize:15] selectedColor:UPColorFromRGB(0xe03633) unselectedColor:UPColorFromRGB(0x333333) selectedTabIdentifierColor:UPColorFromRGB(0xe03633) tabStyle:AverageStyle needHorizontalLine:YES needVerticalLine:NO selectedImageWidth:35];
    _upTabView.backgroundColor = [UIColor clearColor];
    _upTabView.dataSource = self;
    _upTabView.delegate = self;
    [_headerTabView addSubview:_upTabView];
    [_upTabView reloadTabView];
}

- (void)setupPageViewController {
    CGFloat width = kFutursTradeScreenWidth;
    CGFloat height = kFutursTradeScreenHeight - 118;
    
    UPFuturesTradeTransferInViewController *transferInVC = [[UPFuturesTradeTransferInViewController alloc] initWithNibName:@"FuturesTradeBundle.bundle/UPFuturesTradeTransferInViewController" bundle:nil tradeType:self.tradeType];
    [self.viewControllers addObject:transferInVC];
    
    UPFuturesTradeTransferOutViewController *transferOutVC = [[UPFuturesTradeTransferOutViewController alloc] initWithNibName:@"FuturesTradeBundle.bundle/UPFuturesTradeTransferOutViewController" bundle:nil tradeType:self.tradeType];
    [self.viewControllers addObject:transferOutVC];
    
    UPFuturesTradeTransferSerialViewController *transferSerialVC = [[UPFuturesTradeTransferSerialViewController alloc] initWithNibName:@"FuturesTradeBundle.bundle/UPFuturesTradeTransferSerialViewController" bundle:nil tradeType:self.tradeType];
    [self.viewControllers addObject:transferSerialVC];
        
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey:@(0)}];
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    _pageViewController.view.frame = CGRectMake(0, 0, width, height);
    [self addChildViewController:_pageViewController];
    [_contentView addSubview:_pageViewController.view];
    
    [_pageViewController setViewControllers:[@[self.viewControllers[_selectedTab]] copy] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
        
    }];
    [_upTabView setTabBtn:_selectedTab hasDelegate:NO];
}

#pragma mark - Getter

- (NSMutableArray *)viewControllers {
    if (!_viewControllers) {
        _viewControllers = [NSMutableArray array];
    }
    return _viewControllers;
}

#pragma mark - UPFuturesTradeTabViewDataSource, UPFuturesTradeTabViewDelegate
-(NSArray *)tabArr {
    return @[
             @"转入",
             @"转出",
             @"转账流水"
             ];
}

- (void)didTabSelected:(NSInteger)index {
    if (_selectedTab != index) {
        UIPageViewControllerNavigationDirection direction = index > _selectedTab ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
        _selectedTab = index;
        [_pageViewController setViewControllers:[@[self.viewControllers[_selectedTab]] copy] direction:direction animated:YES completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - IndexForViewController

- (NSInteger)indexForViewController:(UIViewController *)viewController {
    NSInteger index = 0;
    for (UIViewController *vc in self.viewControllers) {
        if ([vc isEqual:viewController]) {
            return index;
        }
        index += 1;
    }
    
    return index;
}

#pragma mark - UIPageViewControllerDataSource, UIPageViewControllerDelegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self indexForViewController:viewController];
    if (index <= 0) {
        return nil;
    } else {
        index--;
        return self.viewControllers[index];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self indexForViewController:viewController];
    if (index >= self.viewControllers.count - 1) {
        return nil;
    } else {
        index++;
        return self.viewControllers[index];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    pageViewController.view.userInteractionEnabled = NO;
    _lastIndex = [self indexForViewController:pendingViewControllers[0]];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (finished) {
        pageViewController.view.userInteractionEnabled = YES;
    }
    
    if (completed) {
        _nextIndex = [self indexForViewController:previousViewControllers[0]];
        if (_lastIndex != _nextIndex) {
            if (_lastIndex > _nextIndex) {          // 从左往右划
                
            } else if (_lastIndex < _nextIndex) {   // 从右往左划
                
            }
            _selectedTab = _lastIndex;
            [_upTabView setTabBtn:_selectedTab hasDelegate:NO];
        }
    }
}

@end
