//
//  SFTableViewCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/6.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFTableViewCell.h"

@interface SFTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
@property (weak, nonatomic) IBOutlet UIButton *editrButton;
@property (weak, nonatomic) IBOutlet UIButton *roleButton;

@end

@implementation SFTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    @weakify(self)
    [[self.editrButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(edirtPersonModel:)]) {
            
            [self.delegate edirtPersonModel:self.model];
        }
    }];
    
    self.roleButton.layer.borderWidth = 1;
    self.roleButton.layer.borderColor = defaultColor.CGColor;
    self.roleButton.layer.cornerRadius = 2;
    self.roleButton.clipsToBounds = YES;
}

- (void)setModel:(SFEmployeesModel *)model{
    _model = model;
    
    [self.avatarImage setImageWithURL:[NSURL URLWithString:model.avatar] placeholder:[UIImage imageNamed:@"icon_rectangle_personal_green"]];
    self.nameLabel.text = model.name;
    if (![model.role isEqualToString:@"EMPLOYEE"]) {
        NSString * role = [model.role isEqualToString:@"SUPERADMIN"]?@"超级管理员":
        [model.role isEqualToString:@"DEPARTMENTADMIN"]?@"部门管理员":@"";
        self.roleButton.hidden = NO;
        [self.roleButton setTitle:role forState:UIControlStateNormal];
    }else{
        self.roleButton.hidden = YES;
    }
    
//    self.jobLabel.text = model.
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
