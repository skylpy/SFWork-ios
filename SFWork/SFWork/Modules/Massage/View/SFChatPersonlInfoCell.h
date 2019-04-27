//
//  SFChatPersonlInfoCell.h
//  SFWork
//
//  Created by fox on 2019/3/25.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFChatPersonlInfoCell : UITableViewCell
@property (copy, nonatomic) void (^addBtnActionBlock)(void);
@property (weak, nonatomic) IBOutlet UIImageView *headIMG;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;

@end

NS_ASSUME_NONNULL_END
