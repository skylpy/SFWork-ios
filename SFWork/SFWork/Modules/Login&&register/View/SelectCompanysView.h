//
//  SFSelectCompanyView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/18.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectCompanysView : UIView

+ (instancetype)shareSFSelectCompanyView;
- (void)showInView:(UIView *)superView
        dataSource:(NSArray *)dataSource
       actionBlock:(void (^)(BaseErrorModel * model))actionBlock  ;

@end

NS_ASSUME_NONNULL_END
