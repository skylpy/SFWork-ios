//
//  SFPublicSelectVIew.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/4.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFPublicSelectView : UIView

+ (instancetype)loadNibView;

// 名字记录的数组
@property (nonatomic, strong) NSMutableArray *nameArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (copy,nonatomic)void(^didSelectClick)(NSInteger row,NSArray * array);

@end

NS_ASSUME_NONNULL_END
