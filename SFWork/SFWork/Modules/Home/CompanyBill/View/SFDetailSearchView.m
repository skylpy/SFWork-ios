//
//  SFDetailSearchView.m
//  SFWork
//
//  Created by fox on 2019/4/17.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "SFDetailSearchView.h"

@interface SFDetailSearchView ()
@property (strong, nonatomic) UILabel * titleLB;

@end

@implementation SFDetailSearchView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    }
    return self;
}

- (void)createItemWithTitleArray:(NSArray *)titleArray{
    UIView * mainView = [[UIView alloc]initWithFrame:CGRectZero];
    mainView.backgroundColor = [UIColor whiteColor];
    mainView.clipsToBounds = YES;
    mainView.layer.cornerRadius = 8;
    [self addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(45);
        make.right.mas_equalTo(-45);
        make.centerY.equalTo(self);
    }];
    
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"btn_close_window_gray"] forState:0];
    [closeBtn setTitleColor:[UIColor blackColor] forState:0];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.height.width.mas_equalTo(40);
    }];

    
    UILabel * titleLB = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLB.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    titleLB.font = [UIFont systemFontOfSize:16.0];
    titleLB.text = @"请问您要搜索哪一项？";
    titleLB.textAlignment = 1;
    [mainView addSubview:titleLB];
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.left.right.mas_equalTo(0);
    }];
    _titleLB = titleLB;
    
    UIView * lastLine;
    CGFloat itemH = 50.0;
    for (int i = 0; i < titleArray.count; i ++) {
        UIView * line = [[UIView alloc]initWithFrame:CGRectZero];
        line.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0];
        [mainView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLB.mas_bottom).offset(19+i*itemH);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        
        
        UIButton * itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemBtn setTitle:titleArray[i] forState:0];
        [itemBtn setTitleColor:[UIColor blackColor] forState:0];
        itemBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        itemBtn.tag = 101 + i;
        [itemBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:itemBtn];
        [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLB.mas_bottom).offset(20+i*itemH);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
        
        if (titleArray.count == i + 1) {
            lastLine = line;
        }
    }
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectZero];
    line.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0];
    [mainView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastLine).offset(itemH);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:0];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:0];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastLine).offset(itemH);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleLB.text = titleStr;
}

- (void)closeBtnAction:(UIButton *)sender{
    [self removeFromSuperview];
}

- (void)selectAction:(UIButton *)sender{
    [self removeFromSuperview];
    if (self.selectIndexBlock) {
        self.selectIndexBlock(sender.tag);
    }
}

@end
