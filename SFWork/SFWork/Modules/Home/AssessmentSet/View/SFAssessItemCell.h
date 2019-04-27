//
//  SFAssessItemCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/19.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFBaseTableCell.h"
#import "SFWorkAssessHttpModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFAssessItemCell : SFBaseTableCell

@property (nonatomic, strong) ItemSubListModel *model;

@end

NS_ASSUME_NONNULL_END
