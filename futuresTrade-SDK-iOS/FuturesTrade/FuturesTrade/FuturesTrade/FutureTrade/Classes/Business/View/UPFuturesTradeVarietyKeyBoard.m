//
//  UPFuturesTradeVarietyKeyBoard.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/4.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeVarietyKeyBoard.h"
#import "UPFuturesTradeVarietyKeyBoardCell.h"
#import "UPFuturesTradeVarietyCollectionCell.h"
#import <FuturesTradeSDK/UPCTPModelHeader.h>

#define kVarietyKeyBoardScreenWidth    [[UIScreen mainScreen] bounds].size.width
#define kVarietyKeyBoardScreenHeight   [[UIScreen mainScreen] bounds].size.height

@interface UPFuturesTradeVarietyKeyBoard () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *varietyBoardView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *foldImageView;
@property (nonatomic, copy) NSArray *instruments;
@property (nonatomic, strong) NSMutableArray *exchanges;
@property (nonatomic, strong) NSMutableArray *indexs;
@property (nonatomic, strong) NSMutableArray *instrumentsWithIndex;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation UPFuturesTradeVarietyKeyBoard

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (UPFuturesTradeVarietyKeyBoard *)futuresTradeVarietyKeyBoardWithInstruments:(NSArray *)instruments {
    UPFuturesTradeVarietyKeyBoard *varietyBoard = [[[NSBundle mainBundle] loadNibNamed:@"FuturesTradeBundle.bundle/UPFuturesTradeVarietyKeyBoard" owner:nil options:nil] firstObject];
    varietyBoard.frame = CGRectMake(0, kVarietyKeyBoardScreenHeight, kVarietyKeyBoardScreenWidth, kVarietyKeyBoardScreenHeight);
    [[UIApplication sharedApplication].keyWindow addSubview:varietyBoard];
    
    varietyBoard.instruments = [instruments copy];
    [varietyBoard loadExchanges];
    if (varietyBoard.exchanges.count > 0) {
        [varietyBoard loadIndexs:varietyBoard.exchanges[0][ExchangeID]];
        if (varietyBoard.indexs.count > 0) {
            UPRspInstrumentModel *instrumentModel = varietyBoard.indexs[0];
            if ([instrumentModel isKindOfClass:[UPRspInstrumentModel class]]) {
                [varietyBoard loadInstruments:instrumentModel.instrumentChineseIndex instrumentIDPrefix:instrumentModel.instrumentIndex];
            }
        }
    }
    [varietyBoard setupView];
    
    return varietyBoard;
}

#pragma mark - ResetSelectedIndex

- (void)resetSelectedIndex {
    _selectedIndex = 0;
}

#pragma mark - Setup View
- (void)setupView {
    [self setupFoldImageView];
    [self setupScrollView];
    [self setupCollection];
    [self setupTable];
}

- (void)setupFoldImageView {
    _foldImageView.image = [UIImage imageNamed:@"FuturesTradeBundle.bundle/keybord_img"];
}

- (void)setupCollection {
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:UPFuturesTradeVarietyCollectionCellReuseId bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"FuturesTradeBundle" ofType:@"bundle"]]] forCellWithReuseIdentifier:UPFuturesTradeVarietyCollectionCellReuseId];
    [self reloadCollectionView];
}

- (void)setupTable {
    _table.dataSource = self;
    _table.delegate = self;
    [_table registerNib:[UINib nibWithNibName:UPFuturesTradeVarietyKeyBoardCellReuseId bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"FuturesTradeBundle" ofType:@"bundle"]]] forCellReuseIdentifier:UPFuturesTradeVarietyKeyBoardCellReuseId];
    [self reloadTable];
}

- (void)setupScrollView {
    if (self.exchanges.count > 0) {
        CGFloat width = kVarietyKeyBoardScreenWidth/self.exchanges.count;
        for (NSInteger i = 0; i < self.exchanges.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor clearColor];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:VarietyKeyBoardUIColorWithRGB(0x666666) forState:UIControlStateNormal];
            [button setTitle:self.exchanges[i][ExchangeName] forState:UIControlStateNormal];
            button.frame = CGRectMake(width*i, 0, width, 40);
            [button addTarget:self action:@selector(exchangeClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            [button addSubview:VarietyKeyBoardCutoffLineImageViewWithColor(CGRectMake(width - 0.5, 0, 0.5, 40), VarietyKeyBoardUIColorWithRGB(0xe5e5e5))];
            [_scrollView addSubview:button];
        }
        
        [self setupScrollViewButtonStatus:0];
        
        _scrollView.contentSize = CGSizeMake(width*self.exchanges.count, 40);
    }
}

#pragma mark - Load Data
static NSString * const ExchangeID = @"ExchangeID";
static NSString * const ExchangeName = @"ExchangeName";
static NSString * const ExchangeSequence = @"ExchangeSequence";

- (void)loadExchanges {
    for (UPRspInstrumentModel *model in _instruments) {
        if (![self containsExchangeId:model.ExchangeID]) {
            NSDictionary *dict = [self exchangeName:model.ExchangeID];
            NSString *name = dict[ExchangeName];
            if (name.length > 0) {
                NSMutableDictionary *exchangeDict = [dict mutableCopy];
                exchangeDict[ExchangeID] = model.ExchangeID;
                [self.exchanges addObject:[exchangeDict copy]];
            }
        }
    }
    [self sortExchanges];
}

- (void)sortExchanges {
    if (self.exchanges.count > 0) {
        [self.exchanges sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSNumber *exchangeSequence1 = obj1[ExchangeSequence];
            NSNumber *exchangeSequence2 = obj2[ExchangeSequence];
            return [exchangeSequence1 compare:exchangeSequence2];
        }];
    }
}

- (BOOL)containsExchangeId:(NSString *)exchangeId {
    for (NSDictionary *dict in self.exchanges) {
        // 上国需要过滤掉
        if ([exchangeId isEqual:@"INE"] || [dict[ExchangeID] isEqualToString:exchangeId]) {
            return YES;
        }
    }
    
    return NO;
}

- (NSDictionary *)exchangeName:(NSString *)exchangeId {
    if ([exchangeId isEqualToString:@"CZCE"]) {
        return @{ExchangeName:@"郑商", ExchangeSequence:@3};
    } else if ([exchangeId isEqualToString:@"SHFE"]) {
        return @{ExchangeName:@"上期", ExchangeSequence:@1};
    } else if ([exchangeId isEqualToString:@"DCE"]) {
        return @{ExchangeName:@"大商", ExchangeSequence:@2};
    } else if ([exchangeId isEqualToString:@"CFFEX"]) {
        return @{ExchangeName:@"中金", ExchangeSequence:@4};
    } else if ([exchangeId isEqualToString:@"INE"]) {
        return @{ExchangeName:@"上国", ExchangeSequence:@5};
    }
    return @{ExchangeName:@"", ExchangeSequence:@INT_MAX};
}

- (void)loadIndexs:(NSString *)exchangeId {
    [self.indexs removeAllObjects];
    for (UPRspInstrumentModel *model in _instruments) {
        if ([model.ExchangeID isEqualToString:exchangeId]) {
            UPRspInstrumentModel *modelWithIndex = model;
            NSString *instrumentIndex = [self indexWithInstrumentID:model.InstrumentID];
            NSString *instrumentChineseIndex = [self chineseIndexWithInstrumentName:[model.InstrumentName copy] instrumentIndex:[instrumentIndex copy]];
            if (![self containsChineseIndex:instrumentChineseIndex]) {
                modelWithIndex.instrumentIndex = instrumentIndex;
                modelWithIndex.instrumentChineseIndex = instrumentChineseIndex;
                [self.indexs addObject:modelWithIndex];
            }
        }
    }
    [self sortIndexs];
}

- (void)sortIndexs {
    if (self.indexs.count > 0) {
        [self.indexs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            UPRspInstrumentModel *model1 = obj1;
            UPRspInstrumentModel *model2 = obj2;
            return [model1.instrumentIndex compare:model2.instrumentIndex];
        }];
    }
}

- (BOOL)containsIndex:(NSString *)index {
    for (UPRspInstrumentModel *modelWithIndex in self.indexs) {
        if ([modelWithIndex.instrumentIndex isEqualToString:index]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)containsChineseIndex:(NSString *)chineseIndex {
    for (UPRspInstrumentModel *modelWithIndex in self.indexs) {
        if ([modelWithIndex.instrumentChineseIndex isEqualToString:chineseIndex]) {
            return YES;
        }
    }
    
    return NO;
}

- (NSString *)indexWithInstrumentID:(NSString *)instrumentID {
    if (instrumentID.length > 0) {
        int barIndex = -1;
        for (int i = 0; i < [instrumentID length]; i++) {
            int character = [instrumentID characterAtIndex:i];
            if (character == '-') {
                barIndex = i;
                break;
            }
        }
        
        if (barIndex >= 0) {
            return [instrumentID substringToIndex:barIndex];
        }
        
        NSMutableString *string = [NSMutableString string];
        for (int i = 0; i < [instrumentID length]; i++) {
            int character = [instrumentID characterAtIndex:i];
            if (character > '9' || character == ' ') {
                [string appendFormat:@"%@", [instrumentID substringWithRange:NSMakeRange(i, 1)]];
            } else {
                break;
            }
        }
        return [string copy];
    }
    
    return @"";
}

- (NSString *)chineseIndexWithInstrumentName:(NSString *)instrumentName instrumentIndex:(NSString *)instrumentIndex {
    if (instrumentName.length > 0) {
        // 先找到最后一个中文所在的位置
        int lastChineseIndex = -1;
        for (int i = 0; i < [instrumentName length]; i++) {
            // 汉字Unicode编码的区间为：0x4E00→0x9FA5
            int character = [instrumentName characterAtIndex:i];
            if (character > 0x4e00 && character < 0x9fa5) {
                lastChineseIndex = i;
            }
        }
        
        if (lastChineseIndex >= 0) {
            return [instrumentName substringToIndex:lastChineseIndex+1];
        }
    }
    
    if (instrumentIndex.length > 0) {
        return instrumentIndex;
    }
    
    return @"";
}

- (void)loadInstruments:(NSString *)instrumentNamePrefix instrumentIDPrefix:(NSString *)instrumentIDPrefix {
    [self.instrumentsWithIndex removeAllObjects];
    
    // 先根据中文索引查找
    for (UPRspInstrumentModel *model in _instruments) {
        if ([model.InstrumentName hasPrefix:instrumentNamePrefix]) {
            [self.instrumentsWithIndex addObject:model];
        }
    }
    
    // 若根据中文索引未查找到合约，则根据英文索引查找
    if (!self.instrumentsWithIndex.count) {
        for (UPRspInstrumentModel *model in _instruments) {
            if ([model.InstrumentID hasPrefix:instrumentIDPrefix]) {
                [self.instrumentsWithIndex addObject:model];
            }
        }
    }
}

#pragma mark - Button Pressed

- (IBAction)keyboardHideClicked:(id)sender {
    [self hideKeyboard];
}

- (void)exchangeClicked:(UIButton *)button {
    NSInteger tag = button.tag;
    [self setupScrollViewButtonStatus:tag];
    if (self.exchanges.count > tag) {
        [self resetSelectedIndex];
        [self loadIndexs:self.exchanges[tag][ExchangeID]];
        [self reloadCollectionView];
        [_collectionView setContentOffset:CGPointZero animated:YES];
        if (self.indexs.count > 0) {
            UPRspInstrumentModel *instrumentModel = self.indexs[0];
            if ([instrumentModel isKindOfClass:[UPRspInstrumentModel class]]) {
                [self loadInstruments:instrumentModel.instrumentChineseIndex instrumentIDPrefix:instrumentModel.instrumentIndex];
            }
            [self reloadTable];
        }
    }
}

- (void)setupScrollViewButtonStatus:(NSInteger)tag {
    for (UIButton *button in _scrollView.subviews) {
        if (button.tag == tag) {
            [button setBackgroundColor:VarietyKeyBoardUIColorWithRGB(0x1cb3fb)];
        } else {
            [button setBackgroundColor:[UIColor clearColor]];
        }
    }
}

#pragma mark - Tap Gesture
- (IBAction)tapped:(id)sender {
    [self hideKeyboard];
}

#pragma mark - Getter

- (NSMutableArray *)exchanges {
    if (!_exchanges) {
        _exchanges = [NSMutableArray array];
    }
    return _exchanges;
}

- (NSMutableArray *)indexs {
    if (!_indexs) {
        _indexs = [NSMutableArray array];
    }
    return _indexs;
}

- (NSMutableArray *)instrumentsWithIndex {
    if (!_instrumentsWithIndex) {
        _instrumentsWithIndex = [NSMutableArray array];
    }
    return _instrumentsWithIndex;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.instrumentsWithIndex.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UPFuturesTradeVarietyKeyBoardCell *cell = [tableView dequeueReusableCellWithIdentifier:UPFuturesTradeVarietyKeyBoardCellReuseId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.instrumentsWithIndex.count > indexPath.row) {
        UPRspInstrumentModel *model = self.instrumentsWithIndex[indexPath.row];
        [cell setupInstrument:model.InstrumentID];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.instrumentsWithIndex.count > indexPath.row && _block) {
        _block(self.instrumentsWithIndex[indexPath.row]);
        [self hideKeyboard];
    }
}

- (void)reloadTable {
    [_table reloadData];
    [_table setContentOffset:CGPointZero animated:YES];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.indexs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UPFuturesTradeVarietyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:UPFuturesTradeVarietyCollectionCellReuseId forIndexPath:indexPath];
    if (self.indexs.count > indexPath.row) {
        UPRspInstrumentModel *modelWithIndex = self.indexs[indexPath.row];
        [cell setupIndex:modelWithIndex.instrumentChineseIndex];
        if (indexPath.row == _selectedIndex) {
            cell.contentView.backgroundColor = VarietyKeyBoardUIColorWithRGB(0x1cb3fb);
        } else {
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kVarietyKeyBoardScreenWidth-100)/3, 50);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.indexs.count > indexPath.row) {
        _selectedIndex = indexPath.row;
        [self reloadCollectionView];
        UPRspInstrumentModel *instrumentModel = self.indexs[indexPath.row];
        if ([instrumentModel isKindOfClass:[UPRspInstrumentModel class]]) {
            [self loadInstruments:instrumentModel.instrumentChineseIndex instrumentIDPrefix:instrumentModel.instrumentIndex];
        }
        [self reloadTable];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)reloadCollectionView {
    [_collectionView reloadData];
}

#pragma mark - showKeyboard

// 显示键盘
- (void)showKeyboard {
    if (0 == self.frame.origin.y) {
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, kVarietyKeyBoardScreenWidth, kVarietyKeyBoardScreenHeight);
    } completion:^(BOOL finished) {
        
    }];
}

// 收起键盘
- (void)hideKeyboard {
    if (kVarietyKeyBoardScreenHeight == self.frame.origin.y) {
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, kVarietyKeyBoardScreenHeight, kVarietyKeyBoardScreenWidth, kVarietyKeyBoardScreenHeight);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)destroyKeyboard {
    [self removeFromSuperview];
}

#pragma mark - Color

UIColor *VarietyKeyBoardUIColorWithRGB(NSInteger rgbValue) {
    return ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]);
}

#pragma mark - Cutoff Line
UIImageView *VarietyKeyBoardCutoffLineImageViewWithColor(CGRect frame, UIColor *color) {
    UIImageView *cutoffLine = [[UIImageView alloc] init];
    cutoffLine.backgroundColor = color;
    cutoffLine.frame = frame;
    return cutoffLine;
}

@end
