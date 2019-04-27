//
//  SFMineTableCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/1.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseTableCell.h"
#import "SFMineModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFMineTableCell : SFBaseTableCell

@property (nonatomic, strong) SFMineModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
