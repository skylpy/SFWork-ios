
//
//  SFSelectPersonCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/26.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSelectPersonCell.h"
#import "SFPhotoCell.h"

static NSString * const SFPhotoCellID = @"SFPhotoCellID";
#define cellH (kWidth - 100) / 5
@interface SFSelectPersonCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray * dataSource;
@end

@implementation SFSelectPersonCell


- (NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init]; // 瀑布流
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical; // 纵向
    _collectionView.collectionViewLayout = flowLayout;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    flowLayout.minimumInteritemSpacing = 10;      // cell之间左右间隔
    flowLayout.minimumLineSpacing = 8;          // cell之间上下间隔
    _collectionView.scrollEnabled = NO;
    [_collectionView registerNib:[UINib nibWithNibName:@"SFPhotoCell" bundle:nil] forCellWithReuseIdentifier:SFPhotoCellID];
}

- (void)cellImageArr:(NSArray *)arr withIsE:(BOOL)isE{
    
    _isE = isE;
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:arr];
    [self.collectionView reloadData];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 20, 0, 20);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = CGSizeZero;
    size = CGSizeMake(kWidth , 0);
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeZero;
    
    size = CGSizeMake(cellH, cellH);
    return size;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    if (self.dataSource.count >= 5 || !self.isE) {
        
        return self.dataSource.count;
    }
    return self.dataSource.count +1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SFPhotoCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:SFPhotoCellID forIndexPath:indexPath];
    
    cell.iconImage.image = [UIImage imageNamed:@"btn_add_people"];
 
    if (indexPath.row < self.dataSource.count) {
        cell.URLSTring = self.dataSource[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.dataSource.count) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(cellPersonClickUpload:)]) {
            
            [self.delegate cellPersonClickUpload:self.dataSource];
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
