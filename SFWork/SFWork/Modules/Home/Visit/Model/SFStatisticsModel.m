//
//  SFStatisticsModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/22.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFStatisticsModel.h"

@implementation SFStatisticsModel


+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"statisticsDTOList" : [StatisticsList class],
             @"statisticsDatas" : [StatisticsList class]
             };
}

@end

@implementation StatisticsList



@end
