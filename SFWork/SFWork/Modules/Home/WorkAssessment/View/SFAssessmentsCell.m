//
//  SFAssessmentsCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/12.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAssessmentsCell.h"

@interface SFAssessmentsCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation SFAssessmentsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(ScoreListModel *)model{
    _model = model;
    if ([model.scoreStatus isEqualToString:@"NORMAL"]) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",model.updateDate,model.note];
    }else if([model.scoreStatus isEqualToString:@"CANCELED"]){
        self.titleLabel.text = [NSString stringWithFormat:@"%@ 已撤销",model.updateDate];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
