//
//  SFFinancialApprovalingViewController.h
//  SFWork
//
//  Created by fox on 2019/4/25.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "SFRootViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FinancialType){
    //以下是枚举成员
    FinancialApprovalType = 0//财务审批
   
    
};

@interface SFFinancialApprovalingViewController : UIViewController
@property (strong, nonatomic) NSString * type;//1

@property (nonatomic, assign) FinancialType fType;
@property (nonatomic, copy) NSString * f_id;
@end

NS_ASSUME_NONNULL_END
