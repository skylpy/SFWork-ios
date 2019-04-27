//
//  SFTextViewCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseTableCell.h"
#import "SFCustomerModel.h"
#import "SFJournalModel.h"
#import "SFBillSearchModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFTextViewCell : SFBaseTableCell

@property (nonatomic, strong) SFCustomerModel * model;
@property (nonatomic, strong) SFJournalModel *jmodel;
@property (nonatomic, strong) SFBillSearchModel *searchModel;
@property (nonatomic, copy) void (^textChange)(NSString *text);

@end

NS_ASSUME_NONNULL_END
