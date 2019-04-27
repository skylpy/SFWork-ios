//
//  SFPowerModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFPowerHttpModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFPowerModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *controller;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *type;


@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) BOOL hasPermission;

+ (NSArray *)sharePowerModel;
+ (NSArray *)shareAddPowerModel:(SFPowerListModel *)model withType:(NSString *)type;


+ (NSArray *)sharePowerListModel;

@end

NS_ASSUME_NONNULL_END
