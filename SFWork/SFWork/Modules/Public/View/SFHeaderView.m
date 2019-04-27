//
//  SFHeaderView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/11.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFHeaderView.h"

@implementation SFHeaderView

+ (instancetype)shareSFHeaderView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFHeaderView" owner:self options:nil].firstObject;
}

@end
