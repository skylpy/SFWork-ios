//
//  SFChartTitleView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFChartTitleView.h"

@implementation SFChartTitleView

+ (instancetype)shareSFChartTitleView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFChartTitleView" owner:self options:nil].firstObject;
}

@end
