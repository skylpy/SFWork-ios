//
//  SFRealTimeCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseTableCell.h"
#import "SFRealTimeListViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFRealTimeCell : SFBaseTableCell

@property (nonatomic, strong) RealTimeListModel * model;
@end

NS_ASSUME_NONNULL_END
