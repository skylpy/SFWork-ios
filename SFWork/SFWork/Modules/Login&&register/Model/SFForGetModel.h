//
//  SFForGetModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/17.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFForGetModel : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) BOOL isClick;

+ (NSArray *)shareForGetModel;
+ (SFForGetModel *)addForGetModel;
+ (NSMutableDictionary *)pramJson:(NSArray *)data;

@end

@interface ForGetModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *surplusDays;
@end

NS_ASSUME_NONNULL_END
