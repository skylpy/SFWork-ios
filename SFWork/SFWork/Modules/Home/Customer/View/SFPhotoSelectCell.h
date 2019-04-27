//
//  SFPhotoSelectCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseTableCell.h"
#import "SFCustomerModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SFPhotoSelectCellDelegate <NSObject>

@optional
//添加回调
- (void)cellClickUpload:(NSArray *)imageArr;
//查看回调
- (void)openClickLook:(NSArray *)imageArr withRow:(NSInteger)row withView:(UIView *)superView;
@end

@interface SFPhotoSelectCell : SFBaseTableCell

//NO可添加，YES不可添加
@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, strong) SFCustomerModel * model;
//判断新增还是编辑啊
@property (nonatomic, strong) SFClientModel * cmodel;
@property (nonatomic, weak) id <SFPhotoSelectCellDelegate> delegate;
- (void)cellImage:(SFCustomerModel *)model withIsEdit:(BOOL)isEdit withCmodel:(SFClientModel *)cmodel withArr:(NSArray *)arr;

@end

NS_ASSUME_NONNULL_END
