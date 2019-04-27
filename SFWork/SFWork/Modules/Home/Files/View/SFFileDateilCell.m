//
//  SFFileDateilCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/11.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFFileDateilCell.h"

@interface SFFileDateilCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *hideLabel;

@end
@implementation SFFileDateilCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)conforfilesModel:(NSDictionary *)dict withIndex:(NSInteger)row{
    
    self.hideLabel.text = @"";
    switch (row) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            self.nameLabel.text = @"大小";
            self.desLabel.text = dict[@"size"];
        }
            break;
        case 2:
            self.nameLabel.text = @"格式";
            self.desLabel.text = dict[@"fileType"];
            break;
        case 3:
            self.nameLabel.text = @"位置";
            self.desLabel.text = dict[@"path"];
            break;
        case 4:
            self.nameLabel.text = @"来源";
            self.desLabel.text = dict[@"createTime"];
            self.hideLabel.text = dict[@"creatorName"];
            break;
            
        default:
            break;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
