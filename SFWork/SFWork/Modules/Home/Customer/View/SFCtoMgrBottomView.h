//
//  SFCtoMgrBottomView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/11.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, CtoButtonType){
    //以下是枚举成员
    comType = 0,//客户
    busType = 1,//商家
    priType = 2//下属
    
};

@protocol SFCtoMgrBottomViewDelegate <NSObject>

- (void)selectClick:(CtoButtonType)type;

@end

@interface SFCtoMgrBottomView : UIView

+ (instancetype)shareBottomView;

@property (nonatomic,weak) id <SFCtoMgrBottomViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
