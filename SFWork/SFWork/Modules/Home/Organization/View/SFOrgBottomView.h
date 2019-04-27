//
//  SFOrgBottomView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/4.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SFOrgBottomViewDelegate <NSObject>

- (void)orgBottomVuewClick:(UIButton *)sender;

@end

@interface SFOrgBottomView : UIView

+ (instancetype)shareSFOrgBottomView;
+ (instancetype)shareOrgBottomView;

@property (nonatomic, weak) id <SFOrgBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
