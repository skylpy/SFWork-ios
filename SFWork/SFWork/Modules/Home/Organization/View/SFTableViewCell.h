//
//  SFTableViewCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/6.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseTableCell.h"
#import "SFOrganizationModel.h"
NS_ASSUME_NONNULL_BEGIN
@class SFEmployeesModel;

@protocol SFTableViewCellDelegate <NSObject>

- (void)edirtPersonModel:(SFEmployeesModel *)model;

@end

@interface SFTableViewCell : SFBaseTableCell

@property (nonatomic, strong) SFEmployeesModel *model;
@property (weak, nonatomic) IBOutlet UILabel *salaryLabel;

@property (nonatomic, weak) id <SFTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
