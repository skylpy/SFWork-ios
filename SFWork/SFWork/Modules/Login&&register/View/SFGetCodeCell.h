//
//  SFGetCodeCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/30.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseTableCell.h"
#import "SFRegisterModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFGetCodeCell : SFBaseTableCell

@property (nonatomic,strong) SFRegisterModel * model;
@property (nonatomic, copy) void (^getCodeClick)(UIButton * sender);

@end

NS_ASSUME_NONNULL_END
