//
//  SFExpenseHttpModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/1.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class ExpenseListModel,ExpenseItemModel,ExpenseProcessModel,ExpenseToWhoModel;

@interface SFExpenseHttpModel : NSObject

/**
 * des:新增费用报销
 * author:SkyWork
 */
+(void)postAddExpense:(NSDictionary *)prame
              success:(void (^)(void))success
              failure:(void (^)(NSError *))failure;

/**
 * des: 审批
 * author:SkyWork
 */
+(void)postDoApprove:(NSDictionary *)prame
             success:(void (^)(void))success
             failure:(void (^)(NSError *))failure;

/**
 * des: 获取待我审批/我审批的
 * author:SkyWork
 */
+(void)postgetApprove:(NSDictionary *)prame
              success:(void (^)(NSArray <ExpenseListModel *>*list))success
              failure:(void (^)(NSError *))failure;

/**
 * des: 获取我的报销
 * author:SkyWork
 */
+(void)getMineExpense:(NSDictionary *)prame
              success:(void (^)(NSArray <ExpenseListModel *>*list))success
              failure:(void (^)(NSError *))failure;

/**
 * des: 撤回报销
 * author:SkyWork
 */
+(void)deleteExpense:(NSString *)ex_id
             success:(void (^)(void))success
             failure:(void (^)(NSError *))failure ;

/**
 * des: 获取报销详情
 * author:SkyWork
 */
+(void)getMineExpenseDateil:(NSString *)ex_id
                    success:(void (^)(ExpenseListModel * model,NSArray <ExpenseToWhoModel *>* list))success
                    failure:(void (^)(NSError *))failure ;


@end

@interface ExpenseListModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, strong) ExpenseItemModel * reimbursementItemDTO;
@property (nonatomic, strong) NSArray <ExpenseItemModel *>*reimbursementItemDTOList;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSArray *photoList;
@property (nonatomic, copy) NSString *reimbursePersonId;
@property (nonatomic, copy) NSString *reimbursePersonName;
@property (nonatomic, copy) NSString *reimbursePersonAvatar;
@property (nonatomic, copy) NSString *checkerId;
@property (nonatomic, copy) NSString *checkerName;

@property (nonatomic, copy) NSString *approverId;
@property (nonatomic, copy) NSString *approverName;

@property (nonatomic, copy) NSString *cashierId;
@property (nonatomic, copy) NSString *cashierName;

@property (nonatomic, strong) NSArray <ExpenseProcessModel *>*reimbursementProcessDTOList;
@property (nonatomic, copy) NSString *reimbursementProcessDTO;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *reimburseStatus;
@property (nonatomic, copy) NSString *approveStatus;
@property (nonatomic, copy) NSString *note;

@property (nonatomic, copy) NSString *coIds;
@property (nonatomic, copy) NSString *coId;
@property (nonatomic, strong) NSArray <ExpenseToWhoModel *> * coToWhos;

@end

@interface ExpenseItemModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *detail;

@end

@interface ExpenseProcessModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *reimbursementId;
@property (nonatomic, copy) NSString *approverId;
@property (nonatomic, copy) NSString *approverName;
@property (nonatomic, copy) NSString *approverAvatar;
@property (nonatomic, copy) NSString *approveTime;
@property (nonatomic, copy) NSString *approveStatus;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *approveType;
@property (nonatomic, copy) NSString *nextReimbursementProcessId;

@end

@interface ExpenseToWhoModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *reimbursementId;
@property (nonatomic, copy) NSString *employeeId;
@property (nonatomic, copy) NSString *employeeName;
@property (nonatomic, copy) NSString *employeeAvatar;

@end


NS_ASSUME_NONNULL_END
