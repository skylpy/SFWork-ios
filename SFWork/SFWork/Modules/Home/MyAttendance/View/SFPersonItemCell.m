//
//  SFPersonItemCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/9.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFPersonItemCell.h"

@implementation SFPersonItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconImage.layer.cornerRadius = 24;
    self.iconImage.clipsToBounds = YES;
}

- (void)setModel:(ReportUserModel *)model{
    _model = model;
    
    [self.iconImage setImageWithURL:[NSURL URLWithString:model.smallAvatar] placeholder:DefaultImage];
    self.nameLabel.text = model.name;
    self.statueLabel.text = @"";
}

- (void)setAmodel:(ApprovalProcessModel *)amodel{
    _amodel = amodel;
    [self.iconImage setImageWithURL:[NSURL URLWithString:amodel.smallAvatar] placeholder:DefaultImage];
    self.nameLabel.text = amodel.auditUserName;
    self.statueLabel.text = [amodel.applicationStatus isEqualToString:@"PASS"]?
    @"已通过":[amodel.applicationStatus isEqualToString:@"UNPASS"]?
    @"未通过":[amodel.applicationStatus isEqualToString:@"UNAUDITED"]?
    @"待审批":@"已审批";
    self.statueLabel.textColor = [amodel.applicationStatus isEqualToString:@"PASS"]?
    Color(@"#01B38B"):[amodel.applicationStatus isEqualToString:@"UNPASS"]?
    Color(@"#FF715A"):[amodel.applicationStatus isEqualToString:@"UNAUDITED"]?
    Color(@"#F96A0E"):Color(@"#01B38B");
}

- (void)setBmodel:(BillProcessModel *)bmodel{
    _bmodel = bmodel;
    [self.iconImage setImageWithURL:[NSURL URLWithString:bmodel.processorAvatar] placeholder:DefaultImage];
    self.nameLabel.text = bmodel.processorName;
    self.statueLabel.text = [bmodel.processStage isEqualToString:@"AUDITOR"]?@"审核人":
    [bmodel.processStage isEqualToString:@"APPROVER"]?@"审批人":@"出纳人";
    self.statueLabel.textColor = Color(@"#999999");
}

- (void)setCmodel:(CopyToIdModel *)cmodel{
    _cmodel = cmodel;
    [self.iconImage setImageWithURL:[NSURL URLWithString:cmodel.smallAvatar] placeholder:DefaultImage];
    self.nameLabel.text = cmodel.name;
    self.statueLabel.text = @"";
}

@end
