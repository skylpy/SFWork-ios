//
//  BaseModel.m
//  SFWork
//
//  Created by fox on 2019/4/22.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "LJBaseModel.h"

@implementation LJBaseModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}
@end
