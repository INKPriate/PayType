//
//  INKPayTypesViewCell.h
//  NewCreditPay
//
//  Created by CreditPayHome on 2017/7/10.
//  Copyright © 2017年 lang wenan. All rights reserved.
//

#import <UIKit/UIKit.h>


//typedef enum INKPayOptionsKey : NSUInteger {
//    INKAvailableBalanceKey = 1 << 0,
//    INKFinancialBalanceKey = 1 << 1,
//    INKAvailableBalanceCanUsedKey = 1 << 2,
//    INKFinancialBalanceCanUsedKey = 1 << 3,
//} INKPayOptionsKey;


#define INKAvailableBalanceKey @"A"
#define INKFinancialBalanceKey @"B"
#define INKAvailableBalanceCanUsedKey @"C"
#define INKFinancialBalanceCanUsedKey @"D"

NS_ASSUME_NONNULL_BEGIN
@interface INKPayTypesViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)dispalyWithTitles:(NSArray <NSString *> *)titles indexPath:(NSIndexPath *)indexPath  options:(NSDictionary <NSString*, NSNumber *>*)options;
@end
NS_ASSUME_NONNULL_END
