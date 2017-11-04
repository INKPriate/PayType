//
//  INKPayTypesViewCell.m
//  NewCreditPay
//
//  Created by CreditPayHome on 2017/7/10.
//  Copyright © 2017年 lang wenan. All rights reserved.
//

#import "INKPayTypesViewCell.h"

@interface INKPayTypesViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageV;
@property (weak, nonatomic) IBOutlet UILabel *lable1;
@property (weak, nonatomic) IBOutlet UILabel *lable2;
@property (weak, nonatomic) IBOutlet UILabel *lable3;
@property (weak, nonatomic) IBOutlet UIView *nomoneyLable;
@end

@implementation INKPayTypesViewCell

- (void)awakeFromNib {
    NSLog(@"%s", __func__);

    [super awakeFromNib];
    self.lable1.hidden = YES;
    self.lable2.hidden = YES;
    self.lable3.hidden = YES;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"MyCell";
    INKPayTypesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[INKPayTypesViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = RGB(255.0, 255.0, 255.0, 0.0);
    
    

    
    return cell;
}

//-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    NSLog(@"%s", __func__);
//    
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        
//        UIView *V = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//        V.backgroundColor = [UIColor redColor];
//        [self.contentView addSubview:V];
//        
//    }
//    return self;
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)layoutSubviews{
    NSLog(@"%s", __func__);
    [super layoutSubviews];

}

-(void)setFrame:(CGRect)frame{
    NSLog(@"%s", __func__);
    [super setFrame:frame];
}

- (void)dispalyWithTitles:(NSArray <NSString *> *)titles indexPath:(NSIndexPath *)indexPath  options:(NSDictionary <NSString*, NSNumber *>*)options {
  
    
    if (titles.count > 0) {
        for (int i = 0; i < titles.count; i++) {
            if ([titles[indexPath.row] isEqualToString:@"余额"]) {
                self.lable1.hidden = NO;
                self.lable2.hidden = NO;
                self.lable1.text = titles[indexPath.row];
                self.lable2.text = [NSString stringWithFormat:@"可用余额%@元", [self subNumber:[options[INKAvailableBalanceKey] doubleValue] dotBehindLength:2]];
                self.headerImageV.image = [UIImage imageNamed:@"inkPayViewType1"];
                if ([options[INKAvailableBalanceCanUsedKey] boolValue]) {
                    self.lable1.textColor = [UIColor colorWithRed:61.0/225.0 green:62.0/225.0 blue:63.0/225.0 alpha:1.0];
                    self.nomoneyLable.hidden = YES;
                }else{
                    self.lable1.textColor = [UIColor colorWithRed:127.0/225.0 green:127.0/225.0 blue:127.0/225.0 alpha:1.0];
                    self.nomoneyLable.hidden = NO;
                }
            }else if ([titles[indexPath.row] isEqualToString:@"理财余额"]) {
                self.lable1.hidden = NO;
                self.lable2.hidden = NO;
                self.lable1.text = titles[indexPath.row];
                self.lable2.text = [NSString stringWithFormat:@"可用余额%@元", [self subNumber:[options[INKFinancialBalanceKey] doubleValue] dotBehindLength:2]];
                self.headerImageV.image = [UIImage imageNamed:@"inkPayViewType1"];
                if ([options[INKFinancialBalanceCanUsedKey] boolValue]) {
                    self.lable1.textColor = [UIColor colorWithRed:61.0/225.0 green:62.0/225.0 blue:63.0/225.0 alpha:1.0];
                    self.nomoneyLable.hidden = YES;
                }else{
                    self.lable1.textColor = [UIColor colorWithRed:127.0/225.0 green:127.0/225.0 blue:127.0/225.0 alpha:1.0];
                    self.nomoneyLable.hidden = NO;
                }
            }else if ([titles[indexPath.row] isEqualToString:@"分期"]) {
                self.nomoneyLable.hidden = YES;
                self.lable3.hidden = NO;
                self.lable3.text = titles[indexPath.row];
                self.headerImageV.image = [UIImage imageNamed:@"inkPayViewType2"];
                self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else if ([titles[indexPath.row] isEqualToString:@"银行卡"]) {
                self.nomoneyLable.hidden = YES;
                self.lable3.hidden = NO;
                self.lable3.text = titles[indexPath.row];
                self.headerImageV.image = [UIImage imageNamed:@"inkPayViewType3"];
                self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
    }
}






// 截取小数点后几位 (如果 leng == 0，则截取掉小数点)   ⚠️可以传   .2
-(NSString *)subNumber:(CGFloat )number dotBehindLength:(NSInteger) length{
    NSString *str = [NSString stringWithFormat:@"%f", number];
    NSUInteger location = [str localizedStandardRangeOfString:@"."].location;
    
    if (location != NSNotFound) {
        if (length == 0) {
            str = [str substringToIndex:location];
        }else if (str.length >= location+length+1) {
            str = [str substringToIndex:location+length+1];
        }
    }
    return str;
}
@end
