//
//  SFRealTimeView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFRealTimeView.h"

@implementation SFRealTimeView

+ (instancetype)shareSFRealTimeView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFRealTimeView" owner:self options:nil].firstObject;
}

@end
