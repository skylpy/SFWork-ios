//
//  SFTipDesView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/30.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFTipDesView.h"

@implementation SFTipDesView

+ (instancetype)shareSFTipDesView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFTipDesView" owner:self options:nil].firstObject;
}

@end
