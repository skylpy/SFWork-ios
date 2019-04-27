//
//  SFPublicSearchView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/4.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFPublicSearchView : UIView

+ (instancetype)shareSFPublicSearchView;
@property (weak, nonatomic) IBOutlet UITextField *seachTextField;
@property (nonatomic, copy) void (^searchKeywordAction)(NSString * keyword);
@property (nonatomic, copy) void (^textSignalClick)(NSString * keyword);
@end

NS_ASSUME_NONNULL_END
