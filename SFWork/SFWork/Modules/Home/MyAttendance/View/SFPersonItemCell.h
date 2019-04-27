//
//  SFPersonItemCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/9.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFOrganizationModel.h"
#import "SFAttendanceSetHttpModel.h"
#import "SFAttendanceMgrHttpModel.h"
#import "SFFinancialApprovalHttpModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFPersonItemCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;

@property (nonatomic, strong) ReportUserModel *model;

@property (nonatomic, strong) ApprovalProcessModel *amodel;
@property (nonatomic, strong) CopyToIdModel *cmodel;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) BillProcessModel *bmodel;

@end

NS_ASSUME_NONNULL_END
