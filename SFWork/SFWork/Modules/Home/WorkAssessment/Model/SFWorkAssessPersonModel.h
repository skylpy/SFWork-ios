//
//  SFWorkAssessPersonModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/20.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class TotalSocreModel,SocreDetailModel,ScoreListModel;
@interface SFWorkAssessPersonModel : NSObject

@property (nonatomic, copy) NSArray <SocreDetailModel *> *addScoreDetail;
@property (nonatomic, strong) TotalSocreModel *totalScore;
@property (nonatomic, copy) NSArray <SocreDetailModel *> *subScoreDetail;

@end

@interface TotalSocreModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *employeeId;
@property (nonatomic, copy) NSString *employeeName;
@property (nonatomic, copy) NSString *employeeAvatar;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *iniScore;
@property (nonatomic, copy) NSString *addScore;
@property (nonatomic, copy) NSString *totalScore;
@property (nonatomic, copy) NSString *subScore;
@property (nonatomic, copy) NSString *updateDate;

@end

@interface SocreDetailModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *moduleCode;
@property (nonatomic, copy) NSString *moduleName;
@property (nonatomic, copy) NSArray <ScoreListModel *> *dataList;

@end

@interface ScoreListModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *checkScoreId;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *employeeId;
@property (nonatomic, copy) NSString *employeeName;
@property (nonatomic, copy) NSString *employeeAvatar;
@property (nonatomic, copy) NSString *bizDate;
@property (nonatomic, copy) NSString *checkModule;
@property (nonatomic, copy) NSString *scoreOperator;
@property (nonatomic, copy) NSString *checkScoreType;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *itemNum;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *scoreStatus;
@property (nonatomic, copy) NSString *updateDate;
@property (nonatomic, copy) NSString *processorId;

@end

NS_ASSUME_NONNULL_END
