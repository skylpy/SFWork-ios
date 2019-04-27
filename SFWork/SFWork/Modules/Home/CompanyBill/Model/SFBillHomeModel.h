//
//  SFBillHomeModel.h
//  SFWork
//
//  Created by fox on 2019/4/22.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "LJBaseModel.h"
#import "SFBillListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFBillHomeModel : LJBaseModel
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSString *groupDate;
@property (nonatomic, copy) NSString *groupDateStr;
@property (nonatomic, copy) NSString *groupAmt;
@property (nonatomic, copy) NSArray<SFBillListModel *> *billSumList;
@property (nonatomic, copy) NSArray<SFBillListModel *> *billList;
@end

NS_ASSUME_NONNULL_END
