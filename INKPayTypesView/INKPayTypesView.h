//
//  INKPayTypesView.h
//  NewCreditPay
//
//  Created by CreditPayHome on 2017/7/10.
//  Copyright © 2017年 lang wenan. All rights reserved.
//

#import <UIKit/UIKit.h>
//typedef enum INKPayType : NSUInteger {
//    INKPayTypeNone = 0,
//    INKPayTypeAvailableBalance = 1 << 0,   // 可用余额 1
//    INKPayTypeFinancialBalance = 1 << 1,   // 理财余额 2
//    INKPayTypeInstalments = 1 << 2,   // 分期 4
//    INKPayTypeBankCard = 1 << 3,   // 银行卡 8
//    INKPayTypeAll = INKPayTypeAvailableBalance | INKPayTypeFinancialBalance | INKPayTypeInstalments | INKPayTypeBankCard   // 15
//} INKPayType;

@interface INKPayTypesView : UIView
@property (assign, nonatomic) CGFloat availableBalance;   // 可用余额
@property (assign, nonatomic) CGFloat financialBalance; //  理财余额
@property (assign, nonatomic) CGFloat payMoney;   // 支付的额度
@property (strong, nonatomic) void (^selectedBlock)(NSInteger);
@property (strong, nonatomic) void (^cancleBlock)(void);

@property (strong, nonatomic) NSString * periodnums;
@property (strong, nonatomic) NSString * orderName;

- (instancetype)createWithTitles:(NSArray *)titlesArr;
- (void)show;
@end

/**使用如下👇
NSArray *titlesArr = @[@"分期", @"余额", @"银行卡"];
INKPayTypesView *payTypesV = [[INKPayTypesView alloc] createWithTitles:titlesArr];
payTypesV.availableBalance = 20.0;
payTypesV.payMoney = 10.0;
payTypesV.selectedBlock = ^(NSInteger index){
    if (index == 0) {
        
    }else if (index == 1){
        
    }else if (index == 2){
        
    }
};
[payTypesV show];
*/







