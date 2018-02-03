//
//  UPFuturesTradeLoginViewController.m
//  FuturesTradeDemo
//
//  Created by LiuLian on 17/8/28.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeLoginViewController.h"
#import "UPFuturesTradeInputCell.h"
#import "UPFuturesTradeLoginFooterView.h"
#import "UPFuturesTradeAccountViewController.h"
#import "UPFuturesTradeMainViewController.h"

@interface UPFuturesTradeLoginViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, strong) UPFuturesTradeLoginFooterView *footerView;
@property (nonatomic, strong) NSMutableArray *options;

@end

@implementation UPFuturesTradeLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavBar];
    [self setupOptions];
    [self setupTableView];
    [self refreshLoginBtnStatus];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([self.ctpTradeManager isLogedin]) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavBar {
    self.navigationItem.title = @"交易登录";
    if (_needHideBackBtn) {
        [self hideBackBtn];
    }
}

- (void)setupTableView {
    [_table registerNib:[UINib nibWithNibName:UPFuturesTradeInputCellReuseId bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"FuturesTradeBundle" ofType:@"bundle"]]] forCellReuseIdentifier:UPFuturesTradeInputCellReuseId];
    _table.estimatedRowHeight = 44;
    _table.rowHeight = UITableViewAutomaticDimension;
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    view.frame = CGRectMake(0, 0, kFutursTradeScreenWidth, 100);
    _footerView = [UPFuturesTradeLoginFooterView loginFooterView];
    _footerView.frame = view.bounds;
    UPFuturesTradeWeakSelf(self)
    _footerView.block = ^(void) {
        [weakself login];
    };
    [view addSubview:_footerView];
    _table.tableFooterView = view;
}

- (void)login {
    [self.view endEditing:YES];
    NSString *account = nil;
    NSString *password = nil;
    for (NSInteger i = 0; i < self.options.count; i++) {
        UPFuturesTradeInputCellViewModel *model = self.options[i];
        if (1 == i) {
            account = model.value;
        } else if (2 == i) {
            password = model.value;
        }
    }
    
    [UPHUD showHUD:self.view];
    UPFuturesTradeWeakSelf(self)
    // brokerID为开户时对应的期货公司编号时，为正式环境，本开户期货公司编号为0091
    [self.ctpTradeManager reqUserLogin:account password:password brokerID:BROKER_ID callback:^(id result, NSError *error) {
        [weakself finishLogining:result error:error];
    }];
}

- (void)finishLogining:(id)result error:(NSError *)error {
    [UPHUD hideHUD:self.view];
    if (!error) {
        if (_infoIndex && _infoIndex.integerValue >= 0 && _infoIndex.integerValue <= 3) {
            UPFuturesTradeMainViewController *tradeMainVC = [[UPFuturesTradeMainViewController alloc] initWithNibName:@"FuturesTradeBundle.bundle/UPFuturesTradeMainViewController" bundle:nil tradeType:self.tradeType];
            tradeMainVC.selectedTab = _infoIndex.integerValue;
            [self.navigationController pushViewController:tradeMainVC animated:YES];
        } else {
            UPRspUserLoginModel *rspUserLoginModel = result;
            UPFuturesTradeAccountViewController *accountVC = [[UPFuturesTradeAccountViewController alloc] initWithNibName:@"FuturesTradeBundle.bundle/UPFuturesTradeAccountViewController" bundle:nil tradeType:self.tradeType];
            accountVC.rspUserLoginModel = rspUserLoginModel;
            accountVC.needHideBackBtn = self.needHideBackBtn;
            [self.navigationController pushViewController:accountVC animated:YES];
        }
    } else {
        [UPHUD showToast:self.view withText:error.domain ? error.domain : @"登录失败"];
    }
}

#pragma mark - Setup Options
/**
 * 金仕达模拟账号:
 * 0000601050 123456
 * 0000106005 8
 * 0000106004 8
 * 0000106003 8
 * 0000106002 8
 * 0000106001 8
 *
 * 金仕达正式账号:
 * 666010 084517
 *
 * CTP模拟账号
 * 099982 8714148aall
 * 100132 19881108lX
 */
- (void)setupOptions {
    [self.options removeAllObjects];
    NSArray *names = @[
                       @{@"name":@"交易服务器", @"placeholder":@"金仕达"/*@"placeholder":@"CTP主席"*/},
                       @{@"name":@"资金账号", @"placeholder":@"请输入资金账户"},
                       @{@"name":@"交易密码", @"placeholder":@"请输入交易密码"}
                       ];
    for (NSInteger i = 0; i < names.count; i++) {
        UPFuturesTradeInputCellViewModel *model = [[UPFuturesTradeInputCellViewModel alloc] init];
        model.name = names[i][@"name"];
        model.placeholder = names[i][@"placeholder"];
        model.value = @"";
        
        if (0 == i) {
            model.showArrow = YES;
        } else {
            model.showArrow = NO;
        }
        
        if (1 == i) {
            model.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            NSString *userID = [self.ctpTradeManager userID];
            if (userID.length > 0) {
                model.value = userID;
            }
        } else {
            model.keyboardType = UIKeyboardTypeDefault;
        }
        
        if (2 == i) {
            model.secureTextEntry = YES;
        } else {
            model.secureTextEntry = NO;
        }
        
        [self.options addObject:model];
    }
}

#pragma mark - Getter

- (NSMutableArray *)options {
    if (!_options) {
        _options = [NSMutableArray array];
    }
    return _options;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UPFuturesTradeInputCell *cell = [tableView dequeueReusableCellWithIdentifier:UPFuturesTradeInputCellReuseId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.viewModel = self.options[indexPath.row];
    UPFuturesTradeWeakSelf(self)
    cell.block = ^(UPFuturesTradeInputCellViewModel *model) {
        [weakself refreshOptions:model indexPath:indexPath];
    };
    cell.clickBlock = ^(void) {
        
    };
    return cell;
}

- (void)reloadTable {
    [_table reloadData];
}

- (void)refreshOptions:(UPFuturesTradeInputCellViewModel *)model indexPath:(NSIndexPath *)indexPath {
    if (model && self.options.count > indexPath.row) {
        [self.options replaceObjectAtIndex:indexPath.row withObject:model];
    }
    
    [self refreshLoginBtnStatus];
}

- (void)refreshLoginBtnStatus {
    NSString *account = nil;
    NSString *password = nil;
    for (NSInteger i = 0; i < self.options.count; i++) {
        UPFuturesTradeInputCellViewModel *model = self.options[i];
        if (1 == i) {
            account = model.value;
        } else if (2 == i) {
            password = model.value;
        }
    }
    
    if (UPFuturesTradeIsValidateString(account) && UPFuturesTradeIsValidateString(password)) {
        [_footerView enableLogin];
    } else {
        [_footerView disableLogin];
    }
}

@end
