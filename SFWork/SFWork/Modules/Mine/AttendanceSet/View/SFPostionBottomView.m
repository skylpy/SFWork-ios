//
//  SFPostionBottomView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/17.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFPostionBottomView.h"

@implementation SFPostionBottomView

+ (instancetype)shareSFPostionBottomView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFPostionBottomView" owner:self options:nil].firstObject;
}


@end
