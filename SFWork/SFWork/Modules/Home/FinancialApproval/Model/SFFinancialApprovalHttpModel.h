//
//  SFFinancialApprovalHttpModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/26.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SFFinancialModel,BillProcessModel;
@interface SFFinancialApprovalHttpModel : NSObject

/**
 * des://获取我的审批列表(分组数据)，组内列表数据最多5条
 * author:SkyWork
 */
+(void)myApproveBillGroups:(NSDictionary *)prame
                   success:(void (^)(NSArray * list))success
                   failure:(void (^)(NSError *))failure;

/**
 * des://获取我的发起列表(分组数据)，组内列表数据最多5条
 * author:SkyWork
 */
+(void)myLaunchBillfinaceGroups:(NSDictionary *)prame
                        success:(void (^)(NSArray * list))success
                        failure:(void (^)(NSError *))failure;

/**
 * des: 单据详情
 * author:SkyWork
 */
+(void)getFinancialApprovalDateil:(NSString *)financial_id
                          success:(void (^)(SFFinancialModel * model))success
                          failure:(void (^)(NSError *))failure ;

/**
 * des:财务单据审批处理
 * author:SkyWork
 */
+(void)finacebillProcess:(NSDictionary *)prame
                 success:(void (^)(void))success
                 failure:(void (^)(NSError *))failure ;

/**
 * des:财务单据列表
 * author:SkyWork
 */
+(void)finaceBillListProcess:(NSDictionary *)prame
                     success:(void (^)(NSArray * list))success
                     failure:(void (^)(NSError *))failure ;

/**
 * des:
 * author:SkyWork
 */
+(void)myApproveBillfinaceProcess:(NSDictionary *)prame
                        isApprove:(BOOL)isApprove
                          success:(void (^)(NSArray * list))success
                          failure:(void (^)(NSError *))failure ;

/**
* des:新增财务单据
* author:SkyWork
*/
+(void)addfinacebillProcess:(NSDictionary *)prame
                    success:(void (^)(void))success
                    failure:(void (^)(NSError *))failure;

@end

@interface SFFinancialModel : NSObject

@property (nonatomic, copy) NSString *bizType;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *bizNo;
@property (nonatomic, copy) NSString *dcFlag;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *payType;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *voucherWord;
@property (nonatomic, copy) NSString *voucherNo;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *bizDate;
@property (nonatomic, copy) NSString *dealing;
@property (nonatomic, copy) NSString *chargeTypeId;
@property (nonatomic, copy) NSString *chargeType;
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, copy) NSArray *photos;
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, copy) NSString *customerName;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *operatorId;
@property (nonatomic, copy) NSString *operatorName;
@property (nonatomic, copy) NSString *operatorAvatar;
@property (nonatomic, copy) NSString *listerId;
@property (nonatomic, copy) NSString *listerName;
@property (nonatomic, copy) NSString *listerAvatar;
@property (nonatomic, copy) NSString *auditorId;
@property (nonatomic, copy) NSString *auditorName;
@property (nonatomic, copy) NSString *auditorAvatar;
@property (nonatomic, copy) NSString *approverId;
@property (nonatomic, copy) NSString *approverName;
@property (nonatomic, copy) NSString *approverAvatar;
@property (nonatomic, copy) NSString *cashierId;
@property (nonatomic, copy) NSString *cashierName;
@property (nonatomic, copy) NSString *cashierAvatar;
@property (nonatomic, copy) NSString *billProcessId;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSArray <BillProcessModel *> *billProcessDTOList;
@property (nonatomic, copy) NSString *orginReimbursementId;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *processResult;

@end

@interface BillProcessModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *billId;
@property (nonatomic, copy) NSString *processorId;
@property (nonatomic, copy) NSString *processorName;
@property (nonatomic, copy) NSString *processorAvatar;
@property (nonatomic, copy) NSString *processTime;
@property (nonatomic, copy) NSString *processStage;
@property (nonatomic, copy) NSString *processResult;
@property (nonatomic, copy) NSString *processStatus;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *nextBillProcessId;

@end

NS_ASSUME_NONNULL_END
