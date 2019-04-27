//
//  SFVisitModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/21.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFVisitHttpModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFVisitModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *stars;
@property (nonatomic, copy) NSString *destitle;
@property (nonatomic, copy) NSString *descolor;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) BOOL isClick;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *color;

+ (NSArray *)shareAddVisitModel:(BOOL)isBusiness;
+ (NSMutableDictionary *)pramAddVisitJson:(NSArray *)data;

+ (NSArray *)shareVisitDateilModel:(SFVisitListModel *)model;
+ (NSArray *)shareVisitResultModel:(SFVisitListModel *)model withType:(NSString *)type;
+ (NSMutableDictionary *)pramCompleteVisitJson:(NSArray *)data;

+ (NSArray *)shareSeachVisitModel ;
+ (NSMutableDictionary *)pramSeachVisitJson:(NSArray *)data ;

@end

NS_ASSUME_NONNULL_END
