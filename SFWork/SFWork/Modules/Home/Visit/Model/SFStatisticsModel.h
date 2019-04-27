//
//  SFStatisticsModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/22.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class StatisticsList;
@interface SFStatisticsModel : NSObject

@property (nonatomic, copy) NSString *clientVisitingTimeCycle;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *departmentId;
@property (nonatomic, copy) NSString *employeeId;
@property (nonatomic, copy) NSString *clientVisitingType;
@property (nonatomic, copy) NSString *clientGroup;
@property (nonatomic, copy) NSString *item;
@property (nonatomic, copy) NSArray <StatisticsList *>*statisticsDTOList;

//数据汇报
@property (nonatomic, copy) NSString *timeCycle;
@property (nonatomic, copy) NSArray <StatisticsList *> *statisticsDatas;

@end

@interface StatisticsList : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *sum;
@property (nonatomic, copy) NSArray *days;
@property (nonatomic, copy) NSArray *datas;
@property (nonatomic, copy) NSString *color;

@end



NS_ASSUME_NONNULL_END
