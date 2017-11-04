//
//  INKPayTypesView.m
//  NewCreditPay
//
//  Created by CreditPayHome on 2017/7/10.
//  Copyright © 2017年 lang wenan. All rights reserved.
//

#import "INKPayTypesView.h"
#import "INKButtonExtensions.h"
#import "INKPayTypesViewCell.h"



@interface INKPayTypesView () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UIVisualEffectView *visualEffectView;
@property (strong, nonatomic) NSArray *titlesArr;
@property (strong, nonatomic) UITableView *tableV;
@property (assign, nonatomic) BOOL availableBalanceCanUsed;
@property (assign, nonatomic) BOOL financialBalanceCanUsed;
@property (strong, nonatomic) NSString *lable4Str;
@end


@implementation INKPayTypesView

-(void)dealloc{
    NSLog(@"%s", __func__);
}


-(instancetype)createWithTitles:(NSArray *)titlesArr {
    return [self initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) titlesArr:titlesArr];
}
- (instancetype)initWithFrame:(CGRect)frame titlesArr:(NSArray *)titlesArr
{
    self = [super initWithFrame:frame];
    if (self) {
        if (titlesArr == nil) {
            _titlesArr = [NSArray array];
        }else{
            _titlesArr = titlesArr;
        }
        
        [self createUI];
    }
    return self;
}

-(void)createUI {
    _availableBalanceCanUsed = NO;
    _financialBalanceCanUsed = NO;
    self.backgroundColor = RGB(255.0, 255.0, 255.0, 0.0);
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    _visualEffectView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 300);
    _visualEffectView.backgroundColor = RGB(250, 250, 250, 0.8);;
    [self addSubview:_visualEffectView];
    
    
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 15, 15)];
    [cancleBtn setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
    [cancleBtn setBackgroundImage:[UIImage imageNamed:@"inkCancle"] forState:UIControlStateNormal];
    [cancleBtn setBackgroundImage:[UIImage imageNamed:@"inkCancle_H"] forState:UIControlStateHighlighted];
    [cancleBtn addTarget:self action:@selector(cancleBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake((SCREENWIDTH-200)/2, 5, 200, 35)];
    titleLable.text = @"选择付款方式";
    titleLable.textColor = RGB(61.0, 62.0, 63.0, 1.0);
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont systemFontOfSize:18];
    
    CALayer *lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, 45, SCREENHEIGHT, 1);
    lineLayer.backgroundColor = RGB(61.0, 62.0, 63.0, 1.0).CGColor;
    
    
    _tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 46, SCREENWIDTH, 300-46)];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.backgroundColor = RGB(255.0, 255.0, 255.0, 0.0);
    _tableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableV registerNib:[UINib nibWithNibName:@"INKPayTypesViewCell" bundle:nil] forCellReuseIdentifier:@"MyCell"];
//    [_tableV registerClass:[INKPayTypesViewCell class] forCellReuseIdentifier:@"MyCell"];

    [_visualEffectView.contentView addSubview:cancleBtn];
    [_visualEffectView.contentView addSubview:titleLable];
    [_visualEffectView.layer addSublayer:lineLayer];
    [_visualEffectView.contentView addSubview:_tableV];
    
    [self openAnimationA];
}


#pragma mark - UITableViewDataSource/UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_titlesArr.count > 0) {
        return _titlesArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    INKPayTypesViewCell *cell = [INKPayTypesViewCell cellWithTableView:tableView];

    NSDictionary *options = @{
                                   INKAvailableBalanceKey : [NSNumber numberWithDouble:_availableBalance],
                                   INKFinancialBalanceKey : [NSNumber numberWithDouble:_financialBalance],
                                   INKAvailableBalanceCanUsedKey : [NSNumber numberWithBool:_availableBalanceCanUsed],
                                   INKFinancialBalanceCanUsedKey : [NSNumber numberWithBool:_financialBalanceCanUsed]
                                   };
    [cell dispalyWithTitles:_titlesArr indexPath:indexPath options:options];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (_selectedBlock != nil) {
        _selectedBlock(indexPath.row);
        [self openAnimationB];
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_titlesArr[indexPath.row] isEqualToString:@"余额"]) {
        return _availableBalanceCanUsed;
    } if ([_titlesArr[indexPath.row] isEqualToString:@"理财余额"]) {
        return _financialBalanceCanUsed;
    }
    return YES;
}

#pragma mark - 展示
- (void)show{

    if (_availableBalance < _payMoney) {
        _availableBalanceCanUsed = NO;
    }else{
        _availableBalanceCanUsed = YES;
        
    }
    if (_financialBalance < _payMoney) {
        _financialBalanceCanUsed = NO;
    }else{
        _financialBalanceCanUsed = YES;
        
    }
    [_tableV reloadData];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}


#pragma mark - 取消按钮点击事件
-(void)cancleBtnTap: (UIButton *)sender{
    if (_cancleBlock != nil) {
        _cancleBlock();
    }
    [self openAnimationB];
}

#pragma mark - 动画
-(void)openAnimationA{
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backgroundColor = RGB(0.0, 0.0, 0.0, 0.6);
        _visualEffectView.center = CGPointMake(_visualEffectView.center.x, _visualEffectView.center.y-300);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)openAnimationB{
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backgroundColor = RGB(255.0, 255.0, 255.0, 0.0);
        _visualEffectView.center = CGPointMake(_visualEffectView.center.x, _visualEffectView.center.y+300);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}





@end

