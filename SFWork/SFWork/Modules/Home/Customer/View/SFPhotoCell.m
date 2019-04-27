//
//  SFPhotoCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFPhotoCell.h"

@interface SFPhotoCell ()


@end

@implementation SFPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setURLSTring:(NSString *)URLSTring{
    _URLSTring = URLSTring;
    [self.iconImage setImageWithURL:[NSURL URLWithString:[NSString getAliOSSConstrainURL:URLSTring]] placeholder:DefaultImage];
}

- (void)setUrlString:(NSString *)urlString{
    _urlString = urlString;
    [self.iconImage setImageWithURL:[NSURL URLWithString:urlString] placeholder:DefaultImage];
}

@end
