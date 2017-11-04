//
//  INKPayTypeConst.h
//  NewCreditPay
//
//  Created by CreditPayHome on 2017/7/23.
//  Copyright © 2017年 lang wenan. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const INKPayTypeCanUsed  NS_AVAILABLE_IOS(9_0);


typedef NSString * INKPayTypeKey NS_STRING_ENUM;
typedef NSString * INKBankCardInfoKey NS_STRING_ENUM;

FOUNDATION_EXPORT INKPayTypeKey const INKPayTypeKeyInstallment   NS_AVAILABLE_IOS(9_0);
FOUNDATION_EXPORT INKPayTypeKey const INKPayTypeKeyFinancial  NS_AVAILABLE_IOS(9_0);
FOUNDATION_EXPORT INKPayTypeKey const INKPayTypeKeyAccount  NS_AVAILABLE_IOS(9_0);
FOUNDATION_EXPORT INKPayTypeKey const INKPayTypeKeyBankCard  NS_AVAILABLE_IOS(9_0);
FOUNDATION_EXPORT INKPayTypeKey const INKPayTypeKeyAddBankCard  NS_AVAILABLE_IOS(9_0);


FOUNDATION_EXPORT INKBankCardInfoKey const INKBankCardName  NS_AVAILABLE_IOS(9_0);
FOUNDATION_EXPORT INKBankCardInfoKey const INKBankCardNumber  NS_AVAILABLE_IOS(9_0);
FOUNDATION_EXPORT INKBankCardInfoKey const INKBankCardID  NS_AVAILABLE_IOS(9_0);
FOUNDATION_EXPORT INKBankCardInfoKey const INKBankCardSingleLimit NS_AVAILABLE_IOS(9_0);
