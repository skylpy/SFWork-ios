//
//  SFSelectPersonCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/26.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseTableCell.h"
#import "SFExpenseModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol SFSelectPersonCellDelegate <NSObject>

@optional
//添加回调
- (void)cellPersonClickUpload:(NSArray *)imageArr;
//查看回调
- (void)openClickLook:(NSArray *)imageArr withRow:(NSInteger)row;
@end
@interface SFSelectPersonCell : SFBaseTableCell

@property (nonatomic, assign) BOOL isE;
@property (nonatomic, weak) id <SFSelectPersonCellDelegate> delegate;
- (void)cellImageArr:(NSArray *)arr withIsE:(BOOL)isE;
@end

NS_ASSUME_NONNULL_END
