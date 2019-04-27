//
//  SFJournalBottomView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/18.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFJournalBottomView : UIView

+ (instancetype)shareBottomView;

@property (nonatomic, copy) void (^selectTag)(NSInteger tag);
@property (weak, nonatomic) IBOutlet UIButton *brancdButton;
@property (weak, nonatomic) IBOutlet UIButton *myButton;

@end

NS_ASSUME_NONNULL_END
