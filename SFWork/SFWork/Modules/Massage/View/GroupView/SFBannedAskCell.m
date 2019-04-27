//
//  SFBannedAskCell.m
//  ClassForEvery
//
//  Created by Adam on 2019/4/2.
//  Copyright © 2019年 Adam. All rights reserved.
//

#import "SFBannedAskCell.h"
#import "SFAllContactListViewController.h"
#import "SFAddCollectionCell.h"
#import "SFGroupMemberModel.h"

@interface SFBannedAskCell ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    BOOL _isAddState; //YES 为添加状态 默认为移除状态
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionConstraint;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray * banListArray;

@end

@implementation SFBannedAskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self createCollectionView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)createCollectionView{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat itemWidth = 48;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth+22);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //每个分区的四边间距UIEdgeInsetsMake
    layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    
    _collectionView.collectionViewLayout = layout;
    //mainCollectionView 的背景色
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    [_collectionView registerNib:[UINib nibWithNibName:@"SFAddCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"SFAddCollectionCell"];
    _collectionConstraint.constant = (_banListArray.count/7+1)*80;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SFAllContactListViewController * avc = [SFAllContactListViewController new];
    avc.isBan = self.isBan;
    avc.selectSureBlock = ^(NSArray * _Nonnull selectList) {
        [self addAndRemoveBanListRequest:selectList];
    };
    if (_banListArray.count>0) {
        avc.currChatId = _groupId;
        if (indexPath.row == _banListArray.count) {
            avc.isShowNoBan = YES;
            _isAddState = YES;
            avc.title = @"";
            avc.title = self.isBan.integerValue == 1?@"选择发言成员":@"选择禁言成员";
        }else if (indexPath.row == _banListArray.count+1) {
            avc.isShowBan = YES;
            _isAddState = NO;
            avc.title = self.isBan.integerValue == 1?@"移出发言成员":@"移出禁言成员";
        }
        [_rootVC.navigationController pushViewController:avc animated:YES];
    }else{
        avc.currChatId = _groupId;
        avc.isShowNoBan = YES;
        _isAddState = YES;
        [_rootVC.navigationController pushViewController:avc animated:YES];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_banListArray.count>0) {
        return _banListArray.count+2;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SFAddCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SFAddCollectionCell" forIndexPath:indexPath];
    cell.nameLB.hidden = YES;
    if (_banListArray.count>0) {
        if (indexPath.row == _banListArray.count) {
            [cell.headIMG setImage:[UIImage imageNamed:@"btn_upload_small_pic"]];
        }else if (indexPath.row == _banListArray.count+1) {
            [cell.headIMG setImage:[UIImage imageNamed:@"btn_minus_small_pic"]];
        }else{
            if (self.banListArray.count>indexPath.row) {
                SFGroupMemberModel * model = self.banListArray[indexPath.row];
                [cell.headIMG setImageWithURL:[NSURL URLWithString:model.smallAvatar] placeholder:DefaultImage];
                cell.nameLB.hidden = NO;
                cell.nameLB.text = model.name;
            }
        }
        
    }else{
        [cell.headIMG setImage:[UIImage imageNamed:@"btn_upload_small_pic"]];
    }
    
    return cell;
}

/**
 * 展示所有被禁言的成员
 */
- (void)showAllBanMemberList:(NSString *)groupId{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:groupId forKey:@"groupId"];
    if (self.isBan.integerValue == 1) {
        [params setObject:@(0) forKey:@"isIgnoreBanAll"];
    }else{
        [params setObject:@(1) forKey:@"isBan"];
    }
    
    [SFBaseModel BPOST:BASE_URL(@"/message/chat/group/searchMember") parameters:params success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        self.banListArray = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[SFGroupMemberModel class] json:model.result]];
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
    }];
}

/**
 * 展示所有没有禁言的成员
 */
- (void)showALlNobanMemberList:(NSString *)groupId{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:groupId forKey:@"groupId"];
    if (self.isBan.integerValue == 1) {
        [params setObject:@(1) forKey:@"isIgnoreBanAll"];
    }else{
        [params setObject:@(0) forKey:@"isBan"];
    }
    
    [SFBaseModel BPOST:BASE_URL(@"/message/chat/group/searchMember") parameters:params success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        self.banListArray = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[SFGroupMemberModel class] json:model.result]];
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
    }];
}

/**
 * 添加禁言的成员
    banList 处理的列表
 */
- (void)addAndRemoveBanListRequest:(NSArray *)banList{
    NSString * url = @"";
    NSMutableArray * memberIds = [NSMutableArray array];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:_groupId forKey:@"id"];
    for (SFGroupMemberModel * model in banList) {
        [memberIds addObject:model.employeeId];
    }
    [params setObject:memberIds forKey:@"memberIds"];
    if (_isBan.integerValue == 1) {
        if (_isAddState) {
            url = @"/message/chat/group/addWhitelist";
        }else{
            url = @"/message/chat/group/removeWhitelist";
        }
    }else{
        if (_isAddState) {
            url = @"/message/chat/group/banMember";
        }else{
            url = @"/message/chat/group/unBanMember";
        }
    }
    [SFBaseModel BPOST:BASE_URL(url) parameters:params success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        [MBProgressHUD showInfoMessage:@"操作成功"];
        if (self.isBan.integerValue == 1) {
            [self showALlNobanMemberList:self.groupId];
        }else{
            [self showAllBanMemberList:self.groupId];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [MBProgressHUD showInfoMessage:@"操作失败"];
    }];
}


@end
