//
//  INKPayTypeCell.h
//  NewCreditPay
//
//  Created by CreditPayHome on 2017/7/22.
//  Copyright © 2017年 lang wenan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INKPayTypeConst.h"


@interface INKPayTypeCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
-(void)changedWithInfo:(NSDictionary *)info;
@end
