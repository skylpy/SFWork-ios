//
//  SFBillInfoModel.h
//  SFWork
//
//  Created by fox on 2019/4/22.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFBillProcessModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFBillInfoModel : LJBaseModel
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
@property (nonatomic, copy) NSString *customer;
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
@property (nonatomic, copy) NSArray<SFBillProcessModel *> *billProcessDTOList;
@end

NS_ASSUME_NONNULL_END
