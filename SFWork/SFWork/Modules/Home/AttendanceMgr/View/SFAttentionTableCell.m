//
//  SFAttentionTableCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/2.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAttentionTableCell.h"

@interface SFAttentionTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation SFAttentionTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BusinessTripLeaveOvertimeModel *)model{
    _model = model;
    
    self.titleLabel.attributedText = [NSMutableAttributedString setupAttributeString:[NSString stringWithFormat:@"%@  %@ 提交",model.createName,model.createTime] rangeText:[NSString stringWithFormat:@"%@ 提交",model.createTime] textFont:[UIFont fontWithName:kRegFont size:12] textColor:Color(@"#999999")];
   
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
