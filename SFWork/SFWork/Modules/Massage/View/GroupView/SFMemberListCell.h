//
//  SFMemberListCell.h
//  ClassForEvery
//
//  Created by Adam on 2019/4/2.
//  Copyright © 2019年 Adam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFMemberListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headIMG;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *departMentLB;

@end

NS_ASSUME_NONNULL_END
