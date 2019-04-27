//
//  SFHomeTableCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/1.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SFHomeModel;
@protocol SFHomeTableCellDelegate <NSObject>

- (void)collectionView:(SFHomeModel *)model didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end
@interface SFHomeTableCell : UITableViewCell

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, weak) id <SFHomeTableCellDelegate> delegate; //声明协议变量

@end

NS_ASSUME_NONNULL_END
