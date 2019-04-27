//
//  SFAboutHeaderView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/22.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAboutHeaderView.h"

@interface SFAboutHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation SFAboutHeaderView

+ (instancetype)shareSFAboutHeaderView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFAboutHeaderView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"Version %@",app_Version];
}

@end
