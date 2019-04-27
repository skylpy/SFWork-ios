//
//  SFPublicSelectCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/4.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFPublicSelectCell.h"

@interface SFPublicSelectCell ()



@end

@implementation SFPublicSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTitle:(NSString *)title{
    
    _title = title;
    
    self.titleLabel.text = title;
}

@end
