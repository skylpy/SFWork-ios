//
//  ExpenseBottomView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/26.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExpenseBottomView : UIView

+ (instancetype)shareExpenseBottomView ;
@property (nonatomic, copy) void (^selectTag)(NSInteger tag);

@end

NS_ASSUME_NONNULL_END
