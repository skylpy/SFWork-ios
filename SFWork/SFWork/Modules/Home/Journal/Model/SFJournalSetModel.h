//
//  SFJournalSetModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/16.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFJournalSetModel : NSObject
//当前小时,
@property (nonatomic, copy) NSString *hours;
//当前周几,
@property (nonatomic, copy) NSString *weekly;
//几号,
@property (nonatomic, copy) NSString *today;
//是否启动日报,
@property (nonatomic, assign) BOOL dailyStatus;
//日报提交时间（用于周期为：日）,
@property (nonatomic, copy) NSArray *days;
//日报提交开始时间,
@property (nonatomic, copy) NSString *startTime;
//日报提交截止时间,
@property (nonatomic, copy) NSString *endTime;
//是否启动周报,
@property (nonatomic, assign) BOOL weeklyStatus;
//周报提交时间（用于周期为：小时,
@property (nonatomic, copy) NSString *weeklyStartTime;
//周报提交截止时间（用于周期为：小时,
@property (nonatomic, copy) NSString *weeklyEndTime;
//周报提交时间（用于周期为：日）1-7,
@property (nonatomic, copy) NSString *weeklyStartDate;
//周报提交截止时间（用于周期为：日）1-7,
@property (nonatomic, copy) NSString *weeklyEndDate;
//是否启动月报,
@property (nonatomic, assign) BOOL monthlyStatus;
//月报提交时间（用于周期为：小时,
@property (nonatomic, copy) NSString *monthlyStartTime;
//月报提交截止时间（用于周期为：小时,
@property (nonatomic, copy) NSString *monthlyEndTime;
//月报提交截止时间（用于周期为：月）几号,
@property (nonatomic, copy) NSString *monthlyStartDate;
//月报提交截止时间（用于周期为：月）几号,
@property (nonatomic, copy) NSString *monthlyEndDate;
//日报是否提醒,
@property (nonatomic, assign) BOOL isRemindOfDay;
//日报截止前提醒时间 分钟,
@property (nonatomic, copy) NSString *remindTimeOfDay;
//提醒内容,
@property (nonatomic, copy) NSString *contentOfDay;
//周报是否提醒,
@property (nonatomic, assign) BOOL isRemindOfWeekly;
//周报截止前提醒时间 分钟,
@property (nonatomic, copy) NSString *remindTimeOfWeekly;
//提醒内容,
@property (nonatomic, copy) NSString *contentOfWeekly;
//月报是否提醒,
@property (nonatomic, assign) BOOL isRemindOfMonthly;
//月报截止前提醒时间 分钟,
@property (nonatomic, copy) NSString *remindTimeOfMonthly;
//提醒内容,
@property (nonatomic, copy) NSString *contentOfMonthly;

@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *departmentId;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *createTime;

+ (instancetype)shareManager;

@end


NS_ASSUME_NONNULL_END
