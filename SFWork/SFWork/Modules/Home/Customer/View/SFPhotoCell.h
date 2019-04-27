//
//  SFPhotoCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFPhotoCell : UICollectionViewCell

@property (nonatomic, copy) NSString *URLSTring;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (nonatomic, copy) NSString *urlString;;

@end

NS_ASSUME_NONNULL_END
