//
//  SFAddTallyTypeView.h
//  SFWork
//
//  Created by fox on 2019/4/21.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFAddTallyTypeView : UIView
@property (copy, nonatomic) void (^sureBlock)(NSString *text);
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

NS_ASSUME_NONNULL_END
