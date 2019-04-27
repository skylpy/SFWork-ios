//
//  SFMineHeaderView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/1.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFMineHeaderView.h"

@interface SFMineHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *enterPage;
@property (weak, nonatomic) IBOutlet UIImageView *enterImage;

@end

@implementation SFMineHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.avatarImage.layer.cornerRadius = 22.5;
    self.avatarImage.clipsToBounds = YES;
    self.avatarImage.layer.borderWidth = 1;
    self.avatarImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.nameLabel.text = [SFInstance shareInstance].userInfo.name;
    self.phoneLabel.text = [SFInstance shareInstance].userInfo.phone;
    self.companyName.text = [SFInstance shareInstance].companyInfo.name;
    NSLog(@"%@",[SFInstance shareInstance].userInfo.smallAvatar);
    [self.avatarImage setImageWithURL:[NSURL URLWithString:[SFInstance shareInstance].userInfo.smallAvatar] placeholder:DefaultImage];
    
    self.enterImage.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.enterImage addGestureRecognizer:tap];
}

- (void)tapClick{
    NSLog(@"123");
    !self.enterPayClick?:self.enterPayClick();
}

- (void)setUserInfo:(SFUserInfo *)userInfo{
    
    _userInfo= userInfo;
    self.nameLabel.text = userInfo.name;
    self.phoneLabel.text = userInfo.phone;
    self.companyName.text = [SFInstance shareInstance].companyInfo.name;
    NSLog(@"%@",userInfo.smallAvatar);
    [self.avatarImage setImageWithURL:[NSURL URLWithString:userInfo.smallAvatar] placeholder:DefaultImage];
}

+ (instancetype)shareSFMineHeaderView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFMineHeaderView" owner:self options:nil].firstObject;
}

@end
