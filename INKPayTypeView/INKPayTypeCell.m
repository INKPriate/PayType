//
//  INKPayTypeCell.m
//  NewCreditPay
//
//  Created by CreditPayHome on 2017/7/22.
//  Copyright © 2017年 lang wenan. All rights reserved.
//

#import "INKPayTypeCell.h"


@interface INKPayTypeCell ()
@property (strong, nonatomic) UIImageView *imgV;
@property (strong, nonatomic) UILabel *lable1;
@property (strong, nonatomic) UILabel *lable2;
@property (strong, nonatomic) UILabel *lable3;
@end
    


@implementation INKPayTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"MyCell";
    INKPayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[INKPayTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
        
        
        _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 35, 35)];
        _imgV.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_imgV];
        
        _lable1 = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 250, 30)];
        _lable1.backgroundColor = [UIColor whiteColor];
        _lable1.font = [UIFont systemFontOfSize:18.0 weight:0.15];
        _lable1.textAlignment = NSTextAlignmentLeft;
        _lable1.hidden = YES;
        [self.contentView addSubview:_lable1];

        _lable2 = [[UILabel alloc] initWithFrame:CGRectMake(60, 35, 250, 20)];
        _lable2.backgroundColor = [UIColor whiteColor];
        _lable2.font = [UIFont systemFontOfSize:16.0];
        _lable2.textAlignment = NSTextAlignmentLeft;
        _lable2.hidden = YES;
        [self.contentView addSubview:_lable2];
        
        _lable3 = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, 250, 30)];
        _lable3.backgroundColor = [UIColor whiteColor];
        _lable3.font = [UIFont systemFontOfSize:18.0 weight:0.15];
        _lable3.textAlignment = NSTextAlignmentLeft;
        _lable3.hidden = YES;
        [self.contentView addSubview:_lable3];
        
    }
    return self;
}

-(void)changedWithInfo:(NSDictionary *)info{

    if ([info.allKeys containsObject:INKPayTypeKeyInstallment]) {
        
        _imgV.image = [UIImage imageNamed:@"payType_installment"];
        [self changeLableWithStatus:0 canUsed:[info[INKPayTypeCanUsed] boolValue]];
        _lable1.text = @"分期";
        _lable2.text = [NSString stringWithFormat:@"可用余额 %@元", [self subNumber:[info[INKPayTypeKeyInstallment] doubleValue]  dotBehindLength:2]];
        self.accessoryType = UITableViewCellAccessoryNone;
        
    }else if ([info.allKeys containsObject:INKPayTypeKeyAccount]) {
        
        [self changeLableWithStatus:0 canUsed:[info[INKPayTypeCanUsed] boolValue]];
        _imgV.image = [UIImage imageNamed:@"payType_account"];
        _lable1.text = @"账户余额付款";
        _lable2.text = [NSString stringWithFormat:@"可用余额 %@元", [self subNumber:[info[INKPayTypeKeyAccount] doubleValue]  dotBehindLength:2]];
        self.accessoryType = UITableViewCellAccessoryNone;
        
    }else if ([info.allKeys containsObject:INKPayTypeKeyFinancial]) {
        
        [self changeLableWithStatus:0 canUsed:[info[INKPayTypeCanUsed] boolValue]];
        _imgV.image = [UIImage imageNamed:@"payType_financial"];
        _lable1.text = @"理财余额付款";
        _lable2.text = [NSString stringWithFormat:@"可用余额 %@元", [self subNumber:[info[INKPayTypeKeyFinancial] doubleValue]  dotBehindLength:2]];
        self.accessoryType = UITableViewCellAccessoryNone;
        
    }else if ([info.allKeys containsObject:INKPayTypeKeyBankCard]) {
        
        NSString *bankCard = [NSString stringWithFormat:@"%@", info[INKPayTypeKeyBankCard][INKBankCardNumber]];
        NSString *bankName = [NSString stringWithFormat:@"%@", info[INKPayTypeKeyBankCard][INKBankCardName]];
        NSString *bankLimit = [NSString stringWithFormat:@"%@", info[INKPayTypeKeyBankCard][INKBankCardSingleLimit]];
        NSInteger bankCradID = [[NSString stringWithFormat:@"%@", info[INKPayTypeKeyBankCard][INKBankCardID]] integerValue];

        [self changeLableWithStatus:0 canUsed:[info[INKPayTypeCanUsed] boolValue]];
        _imgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"bankCard_%ld", (long)bankCradID]];
        _lable1.text = [NSString stringWithFormat:@"%@(%@)", bankName, [bankCard substringFromIndex:bankCard.length-4]];
        _lable2.text = [NSString stringWithFormat:@"银行单笔限额 %@元", [self subNumber:[bankLimit doubleValue]  dotBehindLength:2]];
        self.accessoryType = UITableViewCellAccessoryNone;
        
    }else if ([info.allKeys containsObject:INKPayTypeKeyAddBankCard]) {
        
        [self changeLableWithStatus:1 canUsed:[info[INKPayTypeCanUsed] boolValue]];
        _imgV.image = [UIImage imageNamed:@"payType_addBankCard"];
        _lable3.text = @"添加银行卡";
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
}

-(void)changeLableWithStatus:(NSInteger)status canUsed:(BOOL)canUsed{
    if (status == 0) {
        _lable1.hidden = NO;
        _lable2.hidden = NO;
        _lable3.hidden = YES;
        if (canUsed) {
            _lable1.textColor = [UIColor blackColor];
            _lable2.textColor = [UIColor blackColor];
        }else{
            _lable1.textColor = [UIColor lightGrayColor];
            _lable2.textColor = [UIColor lightGrayColor];
        }
    }else{
        _lable1.hidden = YES;
        _lable2.hidden = YES;
        _lable3.hidden = NO;
    }
}


-(NSString *)subNumber:(CGFloat)number dotBehindLength:(NSInteger)length {
    NSString *str = [NSString stringWithFormat:@"%f", number];
    NSInteger location = [str localizedStandardRangeOfString:@"."].location;
    if (length < 0) {
        str = @"0.00";
    }else if (length == 0) {
        str = [str substringToIndex:location];
    }else if (str.length >= location+length+1) {
        str = [str substringToIndex:location+length+1];
    }
    return str;
}

@end

