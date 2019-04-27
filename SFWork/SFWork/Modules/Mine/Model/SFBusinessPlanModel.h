//
//  SFBusinessPlanModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/22.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class CompanyLifeModel;
@interface SFBusinessPlanModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *invitationCode;
@property (nonatomic, copy) NSString *companyStatus;
@property (nonatomic, copy) NSString *validDate;
@property (nonatomic, copy) NSString *quota;
@property (nonatomic, copy) NSString *primarySuperAdmin;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *surplusDays;
@property (nonatomic, copy) NSArray <CompanyLifeModel *>*companyLifeList;


/**
 * des:获取企业套餐
 * author:SkyWork
 */
+(void)getCompanyInfoBusinessPlanSuccess:(void (^)(SFBusinessPlanModel * model))success
                                 failure:(void (^)(NSError *))failure ;

@end

@interface CompanyLifeModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *validDate;
@property (nonatomic, copy) NSString *quota;
@property (nonatomic, copy) NSString *surplusDays;


@end

NS_ASSUME_NONNULL_END
