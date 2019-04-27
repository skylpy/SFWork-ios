//
//  SFIncomeTableViewCell.m
//  SFWork
//
//  Created by fox on 2019/4/17.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "SFIncomeTableViewCell.h"
@interface SFIncomeTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *bizNOLB;
@property (weak, nonatomic) IBOutlet UILabel *bizDateLB;
@property (weak, nonatomic) IBOutlet UILabel *amountLB;
@property (weak, nonatomic) IBOutlet UILabel *noteLB;
@property (weak, nonatomic) IBOutlet UILabel *statueLabel;

@end

@implementation SFIncomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(SFBillListModel *)model{
    _bizNOLB.text = [SFCommon getNULLString:model.bizNo];
    _bizDateLB.text = [NSString stringWithFormat:@"业务时间：%@",[SFCommon getNULLString:model.bizDate]];
    _amountLB.text = [SFCommon getNULLString:model.amount];
    _noteLB.text = [NSString stringWithFormat:@"摘要：%@",model.note.length>0?model.note:[SFCommon getNULLString:model.remark]];
    
}

- (void)setFmodel:(SFFinancialModel *)fmodel{
    _fmodel = fmodel;
    _bizNOLB.text = [SFCommon getNULLString:fmodel.bizNo];
    _bizDateLB.text = [NSString stringWithFormat:@"业务时间：%@",[SFCommon getNULLString:fmodel.bizDate]];
    _amountLB.text = [SFCommon getNULLString:fmodel.amount];
    _noteLB.text = [NSString stringWithFormat:@"摘要：%@",[SFCommon getNULLString:fmodel.remark]];
    self.statueLabel.hidden = NO;
    self.statueLabel.text = [fmodel.processResult isEqualToString:@"APPROVING"]?@"待审批":
    [fmodel.processResult isEqualToString:@"APPROVED"]?@"已审批":
    [fmodel.processResult isEqualToString:@"REJECTED"]?@"已驳回":
    [fmodel.processResult isEqualToString:@"CANCELED"]?@"已撤回":@"已通过";
    
    self.statueLabel.textColor = [fmodel.processResult isEqualToString:@"APPROVING"]?Color(@"#01B38B"):
    [fmodel.processResult isEqualToString:@"APPROVED"]?Color(@"#999999"):
    [fmodel.processResult isEqualToString:@"REJECTED"]?Color(@"#FF715A"):
    [fmodel.processResult isEqualToString:@"CANCELED"]?Color(@"#FF715A"):Color(@"#01B38B");
}

@end
