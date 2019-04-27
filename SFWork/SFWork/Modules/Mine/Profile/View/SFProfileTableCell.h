//
//  SFProfileTableCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseTableCell.h"
#import "SFProfileModel.h"
#import "SFCustomerModel.h"
#import "SFJournalModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFProfileTableCell : SFBaseTableCell

@property (nonatomic, strong) SFProfileModel * model;
@property (nonatomic, strong) SFCustomerModel * cmodel;

@end

@interface SFProfileImageCell : SFBaseTableCell

@property (nonatomic, strong) SFProfileModel * model;

@end

NS_ASSUME_NONNULL_END
