//
//  SFVisitHttpModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/21.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SFVisitListModel,SFStatisticsModel,ContactsModel,EmployeeModel;
@interface SFVisitHttpModel : NSObject

/**
 * des:添加客户拜访
 * author:SkyWork
 */
+(void)addClientVisit:(NSDictionary *)prame
              success:(void (^)(void))success
              failure:(void (^)(NSError *))failure ;

/**
 * des:添加客户拜访
 * author:SkyWork
 */
+(void)clientVisitList:(NSDictionary *)prame
               success:(void (^)(NSArray <SFVisitListModel *>*list))success
               failure:(void (^)(NSError *))failure;

/**
 * des:统计拜访信息
 * author:SkyWork
 */
+(void)clientVisitingCount:(NSDictionary *)prame
                   success:(void (^)(SFStatisticsModel * model))success
                   failure:(void (^)(NSError *))failure ;

/**
 * des:通过客户id查询客户联系人
 * author:SkyWork
 */

+(void)getClientsContacts:(NSString *)cid
                  success:(void (^)(NSArray <ContactsModel *>* list))success
                  failure:(void (^)(NSError * error))failure;

/**
 * des:拜访打卡
 * author:SkyWork
 */
+(void)updateVisitings:(NSDictionary *)pram
               success:(void (^)(void))success
               failure:(void (^)(NSError *))failure;

/**
 * des:删除拜访
 * author:SkyWork
 */
+(void)deleteVisiting:(NSString *)URLString
              success:(void (^)(void))success
              failure:(void (^)(NSError *))failure ;

/**
 * des:完成拜访
 * author:SkyWork
 */
+(void)completeVisits:(NSDictionary *)pram
              success:(void (^)(void))success
              failure:(void (^)(NSError *))failure;

@end

@interface SFVisitListModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *clientGroup;
@property (nonatomic, copy) NSString *clientVisitingType;
@property (nonatomic, copy) NSString *clientId;
@property (nonatomic, copy) NSString *clientName;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *clientLinkmanId;
@property (nonatomic, copy) NSString *deadline;
@property (nonatomic, copy) NSArray *visitors;
@property (nonatomic, copy) NSString *visitor;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSArray *visitingPhotos;
@property (nonatomic, copy) NSString *assignerId;
@property (nonatomic, copy) NSString *clientVisitingStatus;
@property (nonatomic, copy) NSString *visitTime;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSArray *visitedPhotos;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *clientVisitingTimeCycle;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *departmentId;
@property (nonatomic, copy) NSString *employeeId;
@property (nonatomic, copy) NSString *countNum;
@property (nonatomic, copy) NSString *assignerName;
@property (nonatomic, copy) NSString *clientLinkmanName;
@property (nonatomic, copy) NSArray *visitorNames;
@property (nonatomic, copy) NSString *phoneTime;
@property (nonatomic, copy) NSArray <EmployeeModel *> *visitorList;

@end

@interface EmployeeModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *name;

@end

@interface ContactsModel : NSObject

@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *department;
@property (nonatomic, copy) NSString *duty;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *fax;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *major;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *qq;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *weChat;

@end

NS_ASSUME_NONNULL_END
