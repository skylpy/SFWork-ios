//
//  SFTaskModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/19.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class TaskListModel;

@interface SFTaskModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *stars;
@property (nonatomic, copy) NSString *destitle;
@property (nonatomic, copy) NSString *descolor;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) BOOL isClick;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *color;


+ (NSArray *)shareAddTaskModel:(BOOL)isSelf;
+ (NSMutableDictionary *)pramAddTaskJson:(NSArray *)data;

+ (NSArray *)shareTaskDateilModel:(BOOL)isSelf ;


+ (NSArray *)shareTaskDateilModel:(BOOL)isSelf withModel:(TaskListModel *)model;
+ (NSArray *)shareTaskSummaryModel:(BOOL)isSelf withModel:(TaskListModel *)model;
+ (NSMutableDictionary *)pramTaskSummaryJson:(NSArray *)data;

+ (NSArray *)shareTaskSearchModel ;
+ (NSMutableDictionary *)pramTaskSearchJson:(NSArray *)data;
@end

NS_ASSUME_NONNULL_END
