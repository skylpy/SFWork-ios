//
//  SFFilesBottomView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/11.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, FilesButtonType){
    //以下是枚举成员
    deleteType = 0,//删除
    downloadType = 1,//下载
    sendType = 2,//发送
    renameType = 3,//重命名
    removeType = 4//移动
};

@protocol SFFilesBottomViewDelegate <NSObject>

- (void)filesOpationType:(FilesButtonType)type;

@end

@interface SFFilesBottomView : UIView

@property (nonatomic, weak) id <SFFilesBottomViewDelegate> delegate;

+ (instancetype)shareAllBottomView;

+ (instancetype)shareFourBottomView;

+ (instancetype)shareThereBottomView;

@end

NS_ASSUME_NONNULL_END
