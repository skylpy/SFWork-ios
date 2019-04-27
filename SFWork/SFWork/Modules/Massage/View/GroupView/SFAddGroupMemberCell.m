//
//  SFAddGroupMemberCell.m
//  ClassForEvery
//
//  Created by Adam on 2019/4/2.
//  Copyright © 2019年 Adam. All rights reserved.
//

#import "SFAddGroupMemberCell.h"
#import "SFAddCollectionCell.h"
#import "SFGroupMemberModel.h"

@interface SFAddGroupMemberCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionConstraint;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *countLB;
@end

@implementation SFAddGroupMemberCell

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

- (void)setGroupInfoModel:(SFGroupInfoModel *)groupInfoModel{
    if (groupInfoModel!=nil) {
        _groupInfoModel = groupInfoModel;
        _collectionConstraint.constant = (groupInfoModel.members.count/7+1)*58;
        _countLB.text = [NSString stringWithFormat:@"%ld人",groupInfoModel.members.count];
        [self.collectionView reloadData];
    }
    
}

- (void)createCollectionView{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat itemWidth = 48;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
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
    _collectionConstraint.constant = (1/7+1)*58;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.groupInfoModel.members.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SFAddCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SFAddCollectionCell" forIndexPath:indexPath];
    if (self.groupInfoModel.members.count>indexPath.row) {
        SFGroupMemberModel * model = self.groupInfoModel.members[indexPath.row];
        [cell.headIMG setImageWithURL:[NSURL URLWithString:model.avatar] placeholder:DefaultImage];
    }
    
    return cell;
}

@end
