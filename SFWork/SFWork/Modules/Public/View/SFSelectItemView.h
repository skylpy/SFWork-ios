//
//  SFSelectItemView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/11.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFSelectItemView : UIView

+ (instancetype)shareSFSelectItemView;
- (void)showFromView:(UIView *)superView withTitle:(NSString *)title withData:(NSArray *)dataSource selectClick:(void (^)(NSString * type))selectClick;
@property (nonatomic,copy) void (^selectClick)(NSString * type);

@end

NS_ASSUME_NONNULL_END
