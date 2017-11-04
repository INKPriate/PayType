//
//  INKPayTypeView.h
//  NewCreditPay
//
//  Created by CreditPayHome on 2017/7/21.
//  Copyright © 2017年 lang wenan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INKPayTypeConst.h"


NS_ASSUME_NONNULL_BEGIN

@interface INKPayTypeView< __covariant ObjectType> : UIView
@property (strong, nonatomic) void (^selectedPayTypeHandler) (NSDictionary *payTypeInfo);
-(instancetype)createPayTypeWithFrame:(CGRect)frame  money:(CGFloat)money info:(NSDictionary  <INKPayTypeKey, ObjectType>*)info;
@end

NS_ASSUME_NONNULL_END




/*
 
 
 
 
 
NSDictionary *info = @{
                       INKPayTypeKeyInstallment: installment,       // installment 代表 分期时可用额度（根据信用批审的金钱），类型 NSNumber
                       INKPayTypeKeyFinancial: finacialMoney,      // finacialMoney 代表 理财余额（理财时用户拥有的金钱），类型 NSNumber
                       INKPayTypeKeyAccount: validBalance,        // validBalance 代表 账户余额（用户通过充值所拥有金钱），类型 NSNumber
                      INKPayTypeKeyBankCard: bankCards,         // bankCards 代表 银行卡列表，类型 NSArray
                       INKPayTypeKeyAddBankCard: [NSNull null]       // 代表 添加银行卡
                       };

INKPayTypeView *V = [[INKPayTypeView alloc] createPayTypeWithFrame:self.view.bounds money:money info:info];
V.selectedPayTypeHandler = ^(NSDictionary * _Nonnull payTypeInfo) {
    INKPRINTOBJ(payTypeInfo, payTypeInfo);
    
};
[[UIApplication sharedApplication].keyWindow addSubview:V];
*/
