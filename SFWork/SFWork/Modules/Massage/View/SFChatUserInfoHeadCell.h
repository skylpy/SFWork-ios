//
//  SFChatUserInfoHeadCell.h
//  SFWork
//
//  Created by fox on 2019/3/26.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFChatUserInfoHeadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *companyNameLB;
@property (weak, nonatomic) IBOutlet UILabel *departMentLB;
@property (weak, nonatomic) IBOutlet UIImageView *headIMG;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UIImageView *sexLB;

@end

NS_ASSUME_NONNULL_END
