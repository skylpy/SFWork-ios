//
//  SFJournalModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/16.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFJournalHttpModel.h"
#import "SFDataReportHttpModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFJournalModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *stars;
@property (nonatomic, copy) NSString *destitle;
@property (nonatomic, copy) NSString *descolor;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) BOOL isClick;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *color;

+ (NSArray *)shareJournalModel;
+ (NSMutableDictionary *)pramJournalJson:(NSArray *)data;


+ (NSArray *)shareJournalDateilModel:(SFJournalListModel *)model;

//日报设置
+ (NSArray *)shareJournalSetModel:(BOOL)isOn with:(BOOL)isO withM:(SFJournalSetModel *)model;
//日报设置详情
+ (NSMutableDictionary *)pramJournalSetDayJson:(NSArray *)data;
//周
+ (NSArray *)shareJournalSetWeekModel:(BOOL)isOn with:(BOOL)isO withM:(SFJournalSetModel *)model;
//月
+ (NSArray *)shareJournalSetMonthModel:(BOOL)isOn with:(BOOL)isO withM:(SFJournalSetModel *)model;

+ (NSArray *)selectList;

//汇报 日
+ (NSArray *)shareReportSetModel:(BOOL)isOn with:(BOOL)isO withM:(TemplateModel *)model;
//汇报 周
+ (NSArray *)shareReportSetWeekModel:(BOOL)isOn with:(BOOL)isO withM:(TemplateModel *)model;
//汇报 月
+ (NSArray *)shareReportSetMonthModel:(BOOL)isOn with:(BOOL)isO withM:(TemplateModel *)model;
@end

NS_ASSUME_NONNULL_END
