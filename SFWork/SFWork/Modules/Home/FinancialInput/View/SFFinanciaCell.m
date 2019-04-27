//
//  SFFinanciaCell.m
//  SFWork
//
//  Created by fox on 2019/4/19.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "SFFinanciaCell.h"

@interface SFFinanciaCell ()

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *listLabel;
@property (weak, nonatomic) IBOutlet UILabel *oportLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@end

@implementation SFFinanciaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFmodel:(SFFinancialModel *)fmodel{
    _fmodel = fmodel;
    self.numberLabel.text = [NSString stringWithFormat:@"编号：%@",[SFCommon getNULLString:fmodel.bizNo]];
    self.timeLabel.text = [NSString stringWithFormat:@"业务时间：%@",[SFCommon getNULLString:fmodel.bizDate]];
    NSString * type = [fmodel.dcFlag isEqualToString:@"DEBIT"]?@"收入": [fmodel.dcFlag isEqualToString:@"CREDIT"]?@"支出":@"自定义";
    self.moneyLabel.text = [NSString stringWithFormat:@"%@：%@",type,[SFCommon getNULLString:fmodel.amount]];
    self.remarkLabel.text = [NSString stringWithFormat:@"摘要：%@",[SFCommon getNULLString:fmodel.remark]];
    self.listLabel.text = [NSString stringWithFormat:@"制表人：%@",fmodel.listerName];
    self.oportLabel.text = [NSString stringWithFormat:@"经手人：%@",fmodel.operatorName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
