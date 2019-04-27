//
//  SFHomeModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/1.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFHomeModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *controller;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *code;
+ (NSArray *)shareHomeModel;

@end

NS_ASSUME_NONNULL_END
