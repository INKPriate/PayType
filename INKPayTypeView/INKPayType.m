//
//  INKPayType.m
//  NewCreditPay
//
//  Created by CreditPayHome on 2017/7/23.
//  Copyright © 2017年 lang wenan. All rights reserved.
//

#import "INKPayType.h"
#import "INKPayTypeView.h"

@implementation INKPayType
/**
2017-07-22 16:33:44.853280+0800 NewCreditPay[1538:211914] 200    -----   {
    balanceAvalible = 0;        // 账户余额是否可用：1=可用；0=不可用
    bankCardList =     (
                        {
                            bankAvalible = 0;
                            bankCard = 6212260505006574139;      // 银行卡号
                            bankCode = "<null>";
                            bankDayLimit = "<null>";      // 银行卡单日限额
                            bankId = 42;            // 银行卡编号
                            bankLimit = "<null>";      // 银行卡单笔限额
                            bankName = "<null>";      // 银行名称
                            bankPhone = "<null>";
                            idcard = 142727199605032016;      // 身份证号
                            username = "\U8003\U8651\U5efa\U7acb\U79d1\U6280";
                        }
                        );
    creditScore = 2;
    finacialAvalible = 0;     // 理财余额是否可用:1可用;0=不可用
    finacialMoney = 0;      // 理财余额
    installment = "999999.9999000001";       //  分期可用金额
    installmentAvalible = 0;     // 理财余额是否可用:1可用;0=不可用
    money = 20;
    validBalance = "100209.1";    // 账户余额
}
 */
@end



@implementation UIView (INKPayType)
-(void)showPayTypeViewWithMoney:(CGFloat)money payway:(NSInteger)payway selectedPayTypeHanlder:(void (^)(NSDictionary * payTypeInfo))selectedPayTypeHandler {
    [self showINKHUD];
    
    NSDictionary *dic = @{
                          @"userid": [[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"],
                          @"payway": [NSString stringWithFormat:@"%ld", (long)payway],
                          @"money": [NSString stringWithFormat:@"%f", money],
                          @"token": [[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN"],
                          };
    
    [[NetWorkManager shareManager] requestWithType:POST withUrlString:@"public1/payWay.do" withParaments:dic withSuccessBlock:^(NSInteger code, NSDictionary *responseObject) {
        INK(code, responseObject);
        
        [self hideINKHUD];
        if (code == 200) {
            NSNumber *installment = [NSNumber numberWithDouble: [responseObject[@"installment"] doubleValue]];
            NSNumber *validBalance = [NSNumber numberWithDouble: [responseObject[@"validBalance"] doubleValue]];
            NSNumber *finacialMoney = [NSNumber numberWithDouble: [responseObject[@"finacialMoney"] doubleValue]];
            NSLog(@" ----- %@    %@     %@", installment, validBalance, finacialMoney);
            
            
            NSArray *bankCardList = responseObject[@"bankCardList"];
            NSMutableArray *bankCards = [NSMutableArray array];
            for (int i = 0; i < bankCardList.count; i++) {
                NSMutableDictionary *bankCard = [NSMutableDictionary dictionary];
                bankCard[INKBankCardName] = [NSString stringWithFormat:@"%@", bankCardList[i][@"bankName"]];
                bankCard[INKBankCardID] = [NSString stringWithFormat:@"%@", bankCardList[i][@"bankId"]];
                bankCard[INKBankCardNumber] = [NSString stringWithFormat:@"%@", bankCardList[i][@"bankCard"]];
                bankCard[INKBankCardSingleLimit] = [NSString stringWithFormat:@"%@", bankCardList[i][@"bankLimit"]];
                [bankCards addObject:bankCard];
            }
            NSLog(@" bankCards ----- %@ ", bankCards);
            
            
            // 0 == 还款／转账 ---- 账户余额、银行卡列表、添加银行卡（跳转到连连通道进行绑卡）
            // 1 == 充值／账户余额提现/信用提现 ---- 银行卡列表、添加银行卡（跳转到连连通道进行绑卡）
            // 2 == 消费 ---- 分期、账户余额、银行卡列表、添加银行卡（跳转到连连通道进行绑卡）
            // 4 == 购买理财 ---- 理财余额、银行卡列表、添加银行卡（调银生宝通道，支付绑卡合二为一）
            // 5 == 理财余额提现 ---- 银行卡列表、添加银行卡（跳转到银生宝绑卡）
            // 6 == 充值 ---- 银行卡列表、添加银行卡（调银生宝通道，支付绑卡合二为一）
            
            // 7 == 我的界面 ---- 银行卡列表（显示状态是0和2 的银行卡）、添加银行卡（走连连通道）⚠️
            NSDictionary *info = nil;
            if (payway == 0) {
                info = @{
                         INKPayTypeKeyAccount: validBalance,
                         INKPayTypeKeyBankCard: bankCards,
                         INKPayTypeKeyAddBankCard: [NSNull null]
                         };
            }else if (payway == 1) {
                info = @{
                         INKPayTypeKeyBankCard: bankCards,
                         INKPayTypeKeyAddBankCard: [NSNull null]
                         };
            }else if (payway == 2) {
                info = @{
                         INKPayTypeKeyInstallment: installment,
                         INKPayTypeKeyAccount: validBalance,
                         INKPayTypeKeyBankCard: bankCards,
                         INKPayTypeKeyAddBankCard: [NSNull null]
                         };
            }else if (payway == 4) {
                info = @{
                         INKPayTypeKeyFinancial: finacialMoney,
                         INKPayTypeKeyBankCard: bankCards,
                         INKPayTypeKeyAddBankCard: [NSNull null]
                         };
            }else if (payway == 5) {
                info = @{
                         INKPayTypeKeyBankCard: bankCards,
                         INKPayTypeKeyAddBankCard: [NSNull null]
                         };
            }else if (payway == 6) {
                info = @{
                         INKPayTypeKeyBankCard: bankCards,
                         INKPayTypeKeyAddBankCard: [NSNull null]
                         };
            }
            INKPayTypeView *V = [[INKPayTypeView alloc] createPayTypeWithFrame:self.bounds money:money info:info];
            V.selectedPayTypeHandler = ^(NSDictionary * _Nonnull payTypeInfo) {
                if (selectedPayTypeHandler != nil) {
                    selectedPayTypeHandler(payTypeInfo);
                }
            };
            [[UIApplication sharedApplication].keyWindow addSubview:V];
            
        }else if (code == 301){
            [self showINKAlertWithContent:@"网络繁忙，请稍后重试"];
        }else if (code == 400){
            [self showINKAlertWithContent:@"网络繁忙，请稍后重试"];
        }else if (code == 503){
            [self showINKAlertWithContent:@"网络繁忙，请稍后重试"];
        }
    } withFailureBlock:^(NSInteger code, NSError *error) {
        INK(code, error);
        [self hideINKHUD];
        [self showINKAlertWithContent:@"网络繁忙，请稍后重试"];
    }];
}
@end


@implementation UIViewController (INKPayType)
-(void)showPayTypeViewWithMoney:(CGFloat) money payway:(NSInteger)payway selectedPayTypeHanlder:(void (^)(NSDictionary * payTypeInfo))selectedPayTypeHandler {
    [self showINKHUD];
    NSDictionary *dic = @{
                          @"userid": [[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"],
                          @"payway": [NSString stringWithFormat:@"%ld", (long)payway],
                          @"money": [NSString stringWithFormat:@"%f", money],
                          @"token": [[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN"],
                          };
    
    [[NetWorkManager shareManager] requestWithType:POST withUrlString:@"public1/payWay.do" withParaments:dic withSuccessBlock:^(NSInteger code, NSDictionary *responseObject) {
        INK(code, responseObject);
        
        [self hideINKHUD];
        if (code == 200) {
            NSNumber *installment = [NSNumber numberWithDouble: [responseObject[@"installment"] doubleValue]];
            NSNumber *validBalance = [NSNumber numberWithDouble: [responseObject[@"validBalance"] doubleValue]];
            NSNumber *finacialMoney = [NSNumber numberWithDouble: [responseObject[@"finacialMoney"] doubleValue]];
            NSLog(@" ----- %@    %@     %@", installment, validBalance, finacialMoney);
            
            
            NSArray *bankCardList = responseObject[@"bankCardList"];
            NSMutableArray *bankCards = [NSMutableArray array];
            for (int i = 0; i < bankCardList.count; i++) {
                NSMutableDictionary *bankCard = [NSMutableDictionary dictionary];
                bankCard[INKBankCardName] = [NSString stringWithFormat:@"%@", bankCardList[i][@"bankName"]];
                bankCard[INKBankCardID] = [NSString stringWithFormat:@"%@", bankCardList[i][@"bankId"]];
                bankCard[INKBankCardNumber] = [NSString stringWithFormat:@"%@", bankCardList[i][@"bankCard"]];
                bankCard[INKBankCardSingleLimit] = [NSString stringWithFormat:@"%@", bankCardList[i][@"bankLimit"]];
                [bankCards addObject:bankCard];
            }
            NSLog(@" bankCards ----- %@ ", bankCards);
            
            
            // 0 == 还款／转账 ---- 账户余额、银行卡列表、添加银行卡（跳转到连连通道进行绑卡）
            // 1 == 充值／账户余额提现/信用提现 ---- 银行卡列表、添加银行卡（跳转到连连通道进行绑卡）
            // 2 == 消费 ---- 分期、账户余额、银行卡列表、添加银行卡（跳转到连连通道进行绑卡）
            // 4 == 购买理财 ---- 理财余额、银行卡列表、添加银行卡（调银生宝通道，支付绑卡合二为一）
            // 5 == 理财余额提现 ---- 银行卡列表、添加银行卡（跳转到银生宝绑卡）
            // 6 == 充值 ---- 银行卡列表、添加银行卡（调银生宝通道，支付绑卡合二为一）
            
            // 7 == 我的界面 ---- 银行卡列表（显示状态是0和2 的银行卡）、添加银行卡（走连连通道）⚠️
            NSDictionary *info = nil;
            if (payway == 0) {
                info = @{
                         INKPayTypeKeyAccount: validBalance,
                         INKPayTypeKeyBankCard: bankCards,
                         INKPayTypeKeyAddBankCard: [NSNull null]
                         };
            }else if (payway == 1) {
                info = @{
                         INKPayTypeKeyBankCard: bankCards,
                         INKPayTypeKeyAddBankCard: [NSNull null]
                         };
            }else if (payway == 2) {
                info = @{
                         INKPayTypeKeyInstallment: installment,
                         INKPayTypeKeyAccount: validBalance,
                         INKPayTypeKeyBankCard: bankCards,
                         INKPayTypeKeyAddBankCard: [NSNull null]
                         };
            }else if (payway == 4) {
                info = @{
                         INKPayTypeKeyFinancial: finacialMoney,
                         INKPayTypeKeyBankCard: bankCards,
                         INKPayTypeKeyAddBankCard: [NSNull null]
                         };
            }else if (payway == 5) {
                info = @{
                         INKPayTypeKeyBankCard: bankCards,
                         INKPayTypeKeyAddBankCard: [NSNull null]
                         };
            }else if (payway == 6) {
                info = @{
                         INKPayTypeKeyBankCard: bankCards,
                         INKPayTypeKeyAddBankCard: [NSNull null]
                         };
            }
            INKPayTypeView *V = [[INKPayTypeView alloc] createPayTypeWithFrame:self.view.bounds money:money info:info];
            V.selectedPayTypeHandler = ^(NSDictionary * _Nonnull payTypeInfo) {
                if (selectedPayTypeHandler != nil) {
                    selectedPayTypeHandler(payTypeInfo);
                }
            };
            [[UIApplication sharedApplication].keyWindow addSubview:V];
            
        }else if (code == 301){
            [self showINKAlertWithContent:@"网络繁忙，请稍后重试"];
        }else if (code == 400){
            [self showINKAlertWithContent:@"网络繁忙，请稍后重试"];
        }else if (code == 503){
            [self showINKAlertWithContent:@"网络繁忙，请稍后重试"];
        }
    } withFailureBlock:^(NSInteger code, NSError *error) {
        INK(code, error);
        [self hideINKHUD];
        [self showINKAlertWithContent:@"网络繁忙，请稍后重试"];
    }];
}
@end
