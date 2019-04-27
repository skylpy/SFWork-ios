//
//  SFSearchDetailViewController.h
//  SFWork
//
//  Created by fox on 2019/4/17.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface SFSearchDetailViewController : UIViewController
//@property (nonatomic) NSInteger index; //101收入 102支出
@property (strong, nonatomic) NSString * bizTypes;
@property (strong, nonatomic) NSString * showDetailStr;
@property (strong, nonatomic) NSString * urlStr;
@property (nonatomic, copy) NSString *type;
@end

NS_ASSUME_NONNULL_END
