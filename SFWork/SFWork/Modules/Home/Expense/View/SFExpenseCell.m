//
//  SFExpenseCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/26.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFExpenseCell.h"
#import "SFExpCollectCell.h"

static NSString * const SFExpCollectCellID = @"SFExpCollectCellID";

#define cellH (kWidth - 4) / 2

@interface SFExpenseCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray * dataSource;

@end

@implementation SFExpenseCell

- (NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)setModel:(SFExpenseModel *)model{
    _model = model;
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:model.persons];
    [self.collectionView reloadData];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init]; // 瀑布流
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical; // 纵向
    _collectionView.collectionViewLayout = flowLayout;
    _collectionView.backgroundColor = bgColor;
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    flowLayout.minimumInteritemSpacing = 1;      // cell之间左右间隔
    flowLayout.minimumLineSpacing = 1;          // cell之间上下间隔
    _collectionView.scrollEnabled = NO;
    [_collectionView registerNib:[UINib nibWithNibName:@"SFExpCollectCell" bundle:nil] forCellWithReuseIdentifier:SFExpCollectCellID];
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 1, 0, 1);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = CGSizeZero;
    size = CGSizeMake(kWidth , 0);
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeZero;
    
    size = CGSizeMake(cellH, 40);
    return size;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SFExpCollectCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:SFExpCollectCellID forIndexPath:indexPath];
    SFApprpvalModel * model = self.dataSource[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SFApprpvalModel * model = self.dataSource[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellSelectModel:)]) {
        
        [self.delegate cellSelectModel:model];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
