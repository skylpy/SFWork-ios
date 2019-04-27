//
//  SFFinanciaDetailViewController.h
//  SFWork
//
//  Created by fox on 2019/4/19.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFFinancialApprovalingViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFFinanciaDetailViewController : UIViewController

@property (nonatomic, assign) FinancialType fType;
@property (nonatomic, copy) NSString * f_id;

@end

NS_ASSUME_NONNULL_END
