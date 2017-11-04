//
//  INKPayType.h
//  NewCreditPay
//
//  Created by CreditPayHome on 2017/7/23.
//  Copyright © 2017年 lang wenan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INKPayTypeConst.h"
NS_ASSUME_NONNULL_BEGIN

@interface INKPayType : NSObject

@end



@interface UIView (INKPayType)
-(void)showPayTypeViewWithMoney:(CGFloat) money payway:(NSInteger)payway selectedPayTypeHanlder:(void (^)(NSDictionary *  payTypeInfo))selectedPayTypeHandler;
@end


@interface UIViewController (INKPayType)
-(void)showPayTypeViewWithMoney:(CGFloat) money payway:(NSInteger)payway selectedPayTypeHanlder:(void (^)(NSDictionary *  payTypeInfo))selectedPayTypeHandler;
@end


NS_ASSUME_NONNULL_END

/** 使用如下👇
[self showPayTypeViewWithMoney:20.0 payway:0 selectedPayTypeHanlder:^(NSDictionary *payTypeInfo) {
    INKPRINTOBJ(payTypeInfo, payTypeInfo);
    if ([payTypeInfo.allKeys containsObject:INKPayTypeKeyInstallment] ) {
        // 分期
    }else if ([payTypeInfo.allKeys containsObject:INKPayTypeKeyAccount] ) {
        //账户余额
    }else if ([payTypeInfo.allKeys containsObject:INKPayTypeKeyFinancial] ) {
        //理财余额
    }else if ([payTypeInfo.allKeys containsObject:INKPayTypeKeyBankCard] ) {
        // 银行卡
    }else if ([payTypeInfo.allKeys containsObject:INKPayTypeKeyAddBankCard] ) {
        // 添加银行卡
    }
}];;
*/
