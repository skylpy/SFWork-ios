//
//  SFIncomeTableViewCell.h
//  SFWork
//
//  Created by fox on 2019/4/17.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFBillListModel.h"
#import "SFFinancialApprovalHttpModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFIncomeTableViewCell : UITableViewCell
@property (copy, nonatomic)SFBillListModel * model;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (nonatomic, strong) SFFinancialModel *fmodel;
@end

NS_ASSUME_NONNULL_END
