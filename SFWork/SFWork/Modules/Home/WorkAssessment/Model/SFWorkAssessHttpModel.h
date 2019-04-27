//
//  SFWorkAssessHttpModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/19.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFWorkAssessPersonModel.h"

NS_ASSUME_NONNULL_BEGIN
@class SFWorkAssessItemModel,SFWorkCheckItemModel,ItemSubListModel,RulePersonModel,RuleModulesItemModel;
@interface SFWorkAssessHttpModel : NSObject

/**
 * des:获取考核模块列表
 * author:SkyWork
 */
+(void)workAssessCheckList:(NSDictionary *)prame
                   success:(void (^)(NSArray <SFWorkAssessItemModel *>*list))success
                   failure:(void (^)(NSError *))failure ;

/**
 * des: 获取考核项列表
 * author:SkyWork
 */
+(void)workAssessCheckModule:(NSString *)module
                     success:(void (^)(NSArray <SFWorkCheckItemModel *>*list))success
                     failure:(void (^)(NSError *))failure;

/**
 * des:考核规则搜索
 * author:SkyWork
 */
+(void)workAssessCheckSearch:(NSDictionary *)prame
                     success:(void (^)(NSArray <SFWorkCheckItemModel *>*list))success
                     failure:(void (^)(NSError *))failure;

/**
 * des:新增考核规则
 * author:SkyWork
 */
+(void)addWorkAssessCheck:(NSDictionary *)prame
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *))failure;

/**
 * des: 删除考核规则
 * author:SkyWork
 */
+(void)workAssessDeleteCheckModule:(NSString *)k_id
                           success:(void (^)(void))success
                           failure:(void (^)(NSError *))failure;

/**
* des: 获取某人某月的考核分数
* author:SkyWork
*/
+(void)getWorkAssessCheckPrame:(NSDictionary *)prame
                       success:(void (^)(SFWorkAssessPersonModel * model))success
                       failure:(void (^)(NSError *))failure ;

/**
 * des: 考核分数处理
 * author:SkyWork
 */
+(void)postWorkAssessCheckAssessId:(NSString *)assessId
                       withProcess:(NSDictionary *)prame
                           success:(void (^)(void))success
                           failure:(void (^)(NSError *))failure ;

@end

@interface SFWorkAssessItemModel : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;

@end

@interface SFWorkCheckItemModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *checkModule;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *itemNum;
@property (nonatomic, assign) BOOL isAllowRepeat;
@property (nonatomic, copy) NSArray <ItemSubListModel *>*itemSubList;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, copy) NSString *checkRuleStatus;
@property (nonatomic, copy) NSString *personNum;
@property (nonatomic, copy) NSArray <RulePersonModel *> *rulePersonDTOList;
@property (nonatomic, copy) NSArray <RuleModulesItemModel *>*ruleItemDTOList;

@end

@interface RuleModulesItemModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *checkModule;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *itemNum;
@property (nonatomic, assign) BOOL isAllowRepeat;
@property (nonatomic, copy) NSArray <ItemSubListModel *> *itemSubList;

@end

@interface ItemSubListModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *itemSubId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *scoreType;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *period;


@end

@interface RulePersonModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *checkRuleId;
@property (nonatomic, copy) NSString *employeeId;
@property (nonatomic, copy) NSString *employeeName;
@property (nonatomic, copy) NSString *employeeAvatar;

@end


NS_ASSUME_NONNULL_END
