//
//  SFSelectPersonCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/9.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseTableCell.h"
#import "SFMyAttendanceModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, AapprovalPreeType){
    //以下是枚举成员
    FinancialAppType = 0//财务审批
    
    
};
@interface SFSelectAapprovalPersonCell : SFBaseTableCell

@property (nonatomic, copy) NSArray *array;
@property (nonatomic, copy) void (^addPeopleClick)(void);

@property (nonatomic, assign) SFMyAttendanceModel *model;
@property (nonatomic, assign) AapprovalPreeType type;


@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, assign) BOOL isCopy;
- (void)cellContent:(NSArray *)list withType:(BOOL)isAdd withCopy:(BOOL)isCopy;
- (void)cellApprovalContent:(NSArray *)list with:(AapprovalPreeType)type withType:(BOOL)isAdd withCopy:(BOOL)isCopy;

@end

NS_ASSUME_NONNULL_END
