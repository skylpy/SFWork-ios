//
//  SFAttendanceMgrModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/2.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFAttendanceMgrHttpModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFAttendanceMgrModel : NSObject

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

+ (NSArray *)shareAttendanceMgrDateilModel:(ApprovalDetailsModel *)model;
+ (NSArray *)shareMyAttendanceOvertimeModelModel:(ApprovalDetailsModel *)model;
+ (NSArray *)shareMyAttendanceTripModelModel:(ApprovalDetailsModel *)model ;

@end

NS_ASSUME_NONNULL_END
