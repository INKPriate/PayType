//
//  INKPayTypeView.m
//  NewCreditPay
//
//  Created by CreditPayHome on 2017/7/21.
//  Copyright © 2017年 lang wenan. All rights reserved.
//

#import "INKPayTypeView.h"
#import "INKPayTypeCell.h"
#import "UIButton+INKEdge.h"


@interface INKPayTypeView < __covariant ObjectType> () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableV;
@property (strong, nonatomic) UIView *bgV;

@property (assign, nonatomic) CGFloat money;
@property (strong, nonatomic) NSDictionary *info;
@property (strong, nonatomic) NSMutableArray *marr;
@end



@implementation INKPayTypeView 

-(void)dealloc{
    NSLog(@"%s", __func__);
}

-(instancetype)createPayTypeWithFrame:(CGRect)frame money:(CGFloat)money info:(NSDictionary *)info{
    return  [self initWithFrame:frame money:money info:info];
}


- (instancetype)initWithFrame:(CGRect)frame money:(CGFloat)money info:(NSDictionary *)info
{
    self = [super initWithFrame:frame];
    if (self) {
        self.money = money;
        self.info = info;
        [self createUIWithFrame:frame];
    }
    return self;
}



-(void)createUIWithFrame:(CGRect)frame {
    self.backgroundColor = [UIColor clearColor];

    _marr = [NSMutableArray array];
    if (_info != nil) {
        if (_info[INKPayTypeKeyInstallment] != nil) {
            [self addPayTypeWithPayTypeKey:INKPayTypeKeyInstallment value:_info];
        }
        if (_info[INKPayTypeKeyAccount] != nil) {
            [self addPayTypeWithPayTypeKey:INKPayTypeKeyAccount value:_info];
        }
        if (_info[INKPayTypeKeyFinancial] != nil) {
            [self addPayTypeWithPayTypeKey:INKPayTypeKeyFinancial value:_info];
        }
        if (_info[INKPayTypeKeyBankCard] != nil) {
            if ([_info[INKPayTypeKeyBankCard] isKindOfClass:[NSArray class]]) {
                NSArray *arr = _info[INKPayTypeKeyBankCard];
                for (int i = 0; i < arr.count; i++) {
                    [self addPayTypeWithPayTypeKey:INKPayTypeKeyBankCard value:arr[i]];
                }
            }
        }
        if (_info[INKPayTypeKeyAddBankCard] != nil) {
            [self addPayTypeWithPayTypeKey:INKPayTypeKeyAddBankCard value:_info];
        }
    }
    
    
    _bgV = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height*0.4, frame.size.width, frame.size.height*0.6)];
    _bgV.layer.cornerRadius = 10.0;
    _bgV.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgV];
    
    

    
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-150)/2, 10, 150, 30)];
    titleLable.backgroundColor = [UIColor whiteColor];
    titleLable.text = @"请选择支付方式";
    titleLable.textColor = [UIColor colorWithRed:34.0/255.0 green:148.0/255.0 blue:231.0/255.0 alpha:1.0];
    titleLable.font = [UIFont systemFontOfSize:20.0];
    titleLable.textAlignment = NSTextAlignmentCenter;
    [_bgV addSubview:titleLable];
    
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 15, 17, 17)];
    cancleBtn.backgroundColor = [UIColor whiteColor];
    [cancleBtn setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
    [cancleBtn setImage:[UIImage imageNamed:@"inkCancle_blue"] forState:UIControlStateNormal];
    [cancleBtn setImage:[UIImage imageNamed:@"inkCancle_white"] forState:UIControlStateHighlighted];
    [cancleBtn addTarget:self action:@selector(cancleBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    [_bgV addSubview:cancleBtn];
    
    _tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, frame.size.width, frame.size.height*0.6-50) style:UITableViewStylePlain];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.backgroundColor = [UIColor whiteColor];
    _tableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableV.separatorColor = [UIColor lightGrayColor];
    _tableV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableV registerClass:[INKPayTypeCell class] forCellReuseIdentifier:@"MyPayTypeCell"];
    [_bgV addSubview:_tableV];
    
    [self openMyAnimation];
}

-(void)addPayTypeWithPayTypeKey:(INKPayTypeKey)payTypeKey value:(NSDictionary *)value {
    BOOL b = YES;
    if (payTypeKey == INKPayTypeKeyBankCard) {
        NSString *bankLimit = [NSString stringWithFormat:@"%@", value[INKBankCardSingleLimit]];
        if ([bankLimit doubleValue] < _money) {
            b = NO;
        }
        [_marr addObject:@{payTypeKey : value, INKPayTypeCanUsed :  [NSNumber numberWithBool:b]}];
    }else if ( payTypeKey == INKPayTypeKeyAddBankCard){
        [_marr addObject:@{payTypeKey : value[payTypeKey], INKPayTypeCanUsed :  [NSNumber numberWithBool:b]}];
    }else{
        if ([value[payTypeKey] doubleValue] < _money) {
            b = NO;
        }
        [_marr addObject:@{payTypeKey : value[payTypeKey], INKPayTypeCanUsed :  [NSNumber numberWithBool:b]}];
    }
}

#pragma mark - UITableViewDataSource／UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _marr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    INKPayTypeCell *cell = [INKPayTypeCell cellWithTableView:tableView];
    [cell changedWithInfo:_marr[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self closeMyAnimation];
    if (self.selectedPayTypeHandler != nil) {
        self.selectedPayTypeHandler(_marr[indexPath.row]);
    }
 
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_marr[indexPath.row][INKPayTypeCanUsed] boolValue];
}


#pragma mark  - 按钮事件
-(void)cancleBtnTap:(UIButton *)sender{
    [self closeMyAnimation];
}

#pragma mark  - 动画
-(void)openMyAnimation {
    _bgV.transform = CGAffineTransformMakeTranslation(0, _bgV.frame.size.height);
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
        _bgV.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        
    }];
}
-(void)closeMyAnimation {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backgroundColor = [UIColor clearColor];
        _bgV.transform = CGAffineTransformMakeTranslation(0, _bgV.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}




@end


