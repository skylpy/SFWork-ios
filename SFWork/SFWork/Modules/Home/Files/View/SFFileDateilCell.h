//
//  SFFileDateilCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/11.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseTableCell.h"
#import "SFFilesMgrModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFFileDateilCell : SFBaseTableCell

- (void)conforfilesModel:(NSDictionary *)dict withIndex:(NSInteger)row;

@property (nonatomic, strong) NSDictionary *dict;

@end

NS_ASSUME_NONNULL_END
