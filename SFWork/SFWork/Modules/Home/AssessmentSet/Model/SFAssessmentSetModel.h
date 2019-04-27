//
//  SFAssessmentSetModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFWorkAssessHttpModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFAssessmentSetModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *stars;
@property (nonatomic, copy) NSString *destitle;
@property (nonatomic, copy) NSString *descolor;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) BOOL isClick;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *color;

@property (nonatomic, copy) NSArray *persons;
@property (nonatomic, strong) SFWorkCheckItemModel * mod;
+ (NSArray *)shareAssessmentSetDateil:(SFWorkCheckItemModel *)model;
+ (NSArray *)shareAssessmentSetModel;
+ (NSArray *)isOn;
+ (NSArray *)addModel:(NSString *)title WithDestitle:(NSString *)destitle withValue:(NSString *)value withArr:(SFWorkCheckItemModel *)model;

+ (NSMutableDictionary *)pramAssessmentSetJson:(NSArray *)data;

@end


NS_ASSUME_NONNULL_END
