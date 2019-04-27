//
//  SFPublicSelectVIew.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/4.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFPublicSelectView.h"
#import "SFPublicSelectCell.h"

#define SCHorizontalMargin   15.0f
#define SCVerticalMargin     10.0f
static NSString * const SFPublicSelectCellID = @"SFPublicSelectCellID";

@interface SFPublicSelectView ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@end

@implementation SFPublicSelectView

+ (instancetype)loadNibView {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"SFPublicSelectView" owner:self options:nil] objectAtIndex:0];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self setupView];
    
}

- (void)setupView {
    /// 设置此属性为yes 不满一屏幕 也能滚动
    self.collectionView.alwaysBounceHorizontal = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    // 1.创建流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = layout;
    [self registerNibWithTableView];
    
}
  
#pragma mark - 代理方法 Delegate Methods
// 设置分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
// 每个分区上得元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.nameArray.count;
}
// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SFPublicSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SFPublicSelectCellID forIndexPath:indexPath];
    cell.title = self.nameArray[indexPath.row];
    if (self.nameArray.count-1 == indexPath.row) {
        
        cell.titleLabel.textColor = Color(@"#333333");
    }else{
         cell.titleLabel.textColor = Color(@"#01B38B");
    }
    return cell;
    
}
// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 35.0f;
//    CGFloat width = [self gainStringWidthWithString:self.nameArray[indexPath.row] font:15.0f height:height];
    CGFloat width = 66.0f;
    return CGSizeMake(width, height);
    
}

// 设置UIcollectionView整体的内边距（这样item不贴边显示）
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // 上 左 下 右
    return UIEdgeInsetsMake(SCVerticalMargin, SCHorizontalMargin, SCVerticalMargin, SCHorizontalMargin);
    
}
// 设置minimumLineSpacing：cell上下之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return SCHorizontalMargin;
    
}
// 设置minimumInteritemSpacing：cell左右之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return SCHorizontalMargin;
    
}
// 选中cell的回调
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    !self.didSelectClick?:self.didSelectClick(indexPath.row,self.nameArray);
}
#pragma mark - 对外方法 Public Methods
/// array数组里面放的元素 必须字符串类型的
- (void)refreshUIWithNameArray:(NSArray<NSString *> *)array {
    [self.nameArray removeAllObjects];
    [self.nameArray addObjectsFromArray:array];
    [self.collectionView reloadData];
    
}

#pragma mark - 内部方法 Private Methods
// 注册cell
- (void)registerNibWithTableView {
    [self.collectionView registerNib:[UINib nibWithNibName:@"SFPublicSelectCell" bundle:nil] forCellWithReuseIdentifier:SFPublicSelectCellID];
    
}
- (CGFloat)gainStringWidthWithString:(NSString *)string font:(CGFloat)font height:(CGFloat)height {
    if (string.length == 0) {
        return 0.0f;
        
    }
    CGSize maxSize = CGSizeMake(MAXFLOAT, height);
    CGSize realSize = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    /// 左右各16
    return (realSize.width + 2 * (SCHorizontalMargin + 1.f));
    
}

#pragma mark - 懒加载 Lazy Load
- (NSMutableArray *)nameArray {
    if (!_nameArray) {
        _nameArray = [NSMutableArray array];
        
    }
    return _nameArray;
    
}


@end
