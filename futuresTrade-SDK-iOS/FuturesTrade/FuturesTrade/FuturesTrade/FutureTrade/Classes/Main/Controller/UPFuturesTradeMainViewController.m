//
//  UPFuturesTradeMainViewController.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/8/28.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeMainViewController.h"
#import "UPFuturesTradeTabView.h"
#import "UPFuturesTradeBusinessMainViewController.h"
#import "UPFuturesTradeOrderViewController.h"
#import "UPFuturesTradeTradeViewController.h"
#import "UPFuturesTradePositionViewController.h"

@interface UPFuturesTradeMainViewController () <UPFuturesTradeTabViewDataSource, UPFuturesTradeTabViewDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerTabView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) UIScrollView *baseScrollView;

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSMutableArray *viewControllers;

// tab
@property (nonatomic, strong) UPFuturesTradeTabView *upTabView;
@property (nonatomic, assign) NSInteger lastIndex;
@property (nonatomic, assign) NSInteger nextIndex;

// Back Button
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end

@implementation UPFuturesTradeMainViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.edgesForExtendedLayout = UIRectEdgeTop;
    [self setNavBar];
    [self setupBackBtn];
    [self setupTabView];
    [self setupPageViewController];
    [self addNotifications];
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveSwipeToOrderTabNotification:) name:SWIPE_TO_ORDER_TAB_NOTIFICATION object:nil];
}

/*- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self setNavBarTranslucent:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self setNavBarTranslucent:NO];
}*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavBar {
    self.navigationItem.title = @"交易";
}

- (void)setupBackBtn {
    [_backBtn setImage:[UIImage imageNamed:@"FuturesTradeBundle.bundle/futures_trade_back"] forState:UIControlStateNormal];
}

- (void)setupPageViewController {
    CGFloat width = kFutursTradeScreenWidth;
    CGFloat height = kFutursTradeScreenHeight - 108;
    
    UPFuturesTradeBusinessMainViewController *businessVC = [[UPFuturesTradeBusinessMainViewController alloc] initWithNibName:@"FuturesTradeBundle.bundle/UPFuturesTradeBusinessMainViewController" bundle:nil tradeType:self.tradeType];
    businessVC.instrumentID = self.instrumentID;
    [self.viewControllers addObject:businessVC];
    
    UPFuturesTradeOrderViewController *orderVC = [[UPFuturesTradeOrderViewController alloc] initWithNibName:@"FuturesTradeBundle.bundle/UPFuturesTradeOrderViewController" bundle:nil tradeType:self.tradeType];
    [self.viewControllers addObject:orderVC];
    
    UPFuturesTradeTradeViewController *tradeVC = [[UPFuturesTradeTradeViewController alloc] initWithNibName:@"FuturesTradeBundle.bundle/UPFuturesTradeTradeViewController" bundle:nil tradeType:self.tradeType];
    [self.viewControllers addObject:tradeVC];
    
    UPFuturesTradePositionViewController *positionVC = [[UPFuturesTradePositionViewController alloc] initWithNibName:@"FuturesTradeBundle.bundle/UPFuturesTradePositionViewController" bundle:nil tradeType:self.tradeType];
    [self.viewControllers addObject:positionVC];
    
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey:@(0)}];
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    _pageViewController.view.frame = CGRectMake(0, 0, width, height);
    [self addChildViewController:_pageViewController];
    _contentView.frame = CGRectMake(0, _contentView.frame.origin.y, width, height);
    [_contentView addSubview:_pageViewController.view];
    
    [_pageViewController setViewControllers:[@[self.viewControllers[_selectedTab]] copy] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
        
    }];
    [_upTabView setTabBtn:_selectedTab hasDelegate:NO];
}

- (void)setupTabView {
    _upTabView = [[UPFuturesTradeTabView alloc] initWithFrame:CGRectMake(0, 0, kFutursTradeScreenWidth, _headerTabView.bounds.size.height) font:[UIFont systemFontOfSize:16] selectedColor:[UIColor whiteColor] unselectedColor:[UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.7] selectedTabIdentifierColor:[UIColor whiteColor] tabStyle:AverageStyle needHorizontalLine:NO needVerticalLine:NO selectedImageWidth:35];
    _upTabView.backgroundColor = [UIColor clearColor];
    _upTabView.dataSource = self;
    _upTabView.delegate = self;
    [_headerTabView addSubview:_upTabView];
    [_upTabView reloadTabView];
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
             @"下单",
             @"委托",
             @"成交",
             @"持仓"
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

#pragma mark - Button Pressed

- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

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

#pragma mark - Notification
- (void)didReceiveSwipeToOrderTabNotification:(NSNotification *)noti {
    [self didTabSelected:0];
    [_upTabView setTabBtn:_selectedTab hasDelegate:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:PLUS_POSITION_NOTIFICATION object:noti.object];
}

@end
