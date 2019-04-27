//
//  SFAttendanceMgrViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/2.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ApprovalType){
    //以下是枚举成员
    LEAVE = 0,//请假
    BUSINESS_TRAVEL = 1,//出差
    OVERTIME = 2//加班
};

typedef NS_ENUM(NSInteger, ApprovalListType){
    //以下是枚举成员
    MySend = 0,//发起
    Manager = 1,//审批
    CopyList = 2//抄送
};

@interface SFAttendanceMgrViewController : SFBaseViewController

@end

NS_ASSUME_NONNULL_END
