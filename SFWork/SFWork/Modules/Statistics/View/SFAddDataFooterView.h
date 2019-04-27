//
//  SFAddDataFooterView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/29.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFAddDataFooterView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
+ (instancetype)shareSFAddDataFooterView;

@property (nonatomic, copy) void (^sureClick)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
