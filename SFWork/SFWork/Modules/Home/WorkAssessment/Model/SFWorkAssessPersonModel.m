//
//  SFWorkAssessPersonModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/20.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFWorkAssessPersonModel.h"

@implementation SFWorkAssessPersonModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"addScoreDetail" : [SocreDetailModel class],
             @"totalScore" : [TotalSocreModel class],
             @"subScoreDetail" : [SocreDetailModel class],
             };
}

@end

@implementation TotalSocreModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id",@"iniScore":@"initScore"};
}

@end

@implementation SocreDetailModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"dataList" : [ScoreListModel class]
             };
}

@end

@implementation ScoreListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end


