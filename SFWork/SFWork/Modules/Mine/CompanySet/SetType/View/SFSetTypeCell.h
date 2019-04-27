//
//  SFSetTypeCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/7.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseTableCell.h"
#import "SFSetTypeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFSetTypeCell : SFBaseTableCell

@property (nonatomic, strong) SFSetTypeModel *model;

@property (nonatomic, copy) void (^deleteClick)(SFSetTypeModel *model);
@property (nonatomic, copy) void (^updateClick)(SFSetTypeModel *model);

@end

NS_ASSUME_NONNULL_END
