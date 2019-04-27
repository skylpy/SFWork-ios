//
//  SFApprovalPreeCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/1.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFExpenseHttpModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFApprovalPreeCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (nonatomic, strong) ExpenseProcessModel *model;

@end

NS_ASSUME_NONNULL_END
