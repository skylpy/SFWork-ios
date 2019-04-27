//
//  SFDownloadedCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/12.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFDownloadedCell.h"

@implementation SFDownloadedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setSessionModel:(ZFSessionModel *)sessionModel {
    
    _sessionModel = sessionModel;
    self.fileNameLabel.text = sessionModel.fileName;
    self.sizeLabel.text = sessionModel.totalSize;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
