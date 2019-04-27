//
//  SFSelectEmpView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/14.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSelectEmpView.h"


static NSString * const SFEmpButtonCellID = @"SFEmpButtonCellID";
#define cellH (kWidth - 100) / 5

@interface SFSelectEmpView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray * dataSource;
@end

@implementation SFSelectEmpView

- (NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

+ (instancetype)shareSFSelectEmpView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFSelectEmpView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init]; // 瀑布流
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = flowLayout;
    /// 设置此属性为yes 不满一屏幕 也能滚动
    self.collectionView.alwaysBounceHorizontal = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[SFEmpButtonCell class] forCellWithReuseIdentifier:SFEmpButtonCellID];
    
    @weakify(self)
    [[self.sureButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.selectEmpClick?:self.selectEmpClick(self.dataSource);
    }];
}

- (void)setList:(NSMutableArray *)list{
    _list = list;
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:list];
    [self.collectionView reloadData];
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    CGSize size = CGSizeZero;
//    size = CGSizeMake(kWidth , 0);
//    return size;
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeZero;
    
    size = CGSizeMake(cellH, 30);
    return size;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SFEmpButtonCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:SFEmpButtonCellID forIndexPath:indexPath];
    SFOrgListModel * model = self.dataSource[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //    SFHomeModel * model = self.array[indexPath.row];
    //
    //    if (self.delegate&&[self.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
    //
    //        [self.delegate collectionView:model didSelectItemAtIndexPath:indexPath];
    //    }
}

@end


@interface SFEmpButtonCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SFEmpButtonCell



- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self drawUI];
    }
    return self;
}

- (void)setModel:(SFOrgListModel *)model{
    
    _model = model;
    self.titleLabel.text = model.name;
}

- (void)drawUI {
    
    [self addSubview:self.titleLabel];
    self.titleLabel.layer.cornerRadius = 5;
    self.titleLabel.clipsToBounds = YES;
    self.titleLabel.layer.borderWidth = 1;
    self.titleLabel.layer.borderColor = defaultColor.CGColor;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        
        _titleLabel = [UILabel createALabelText:@"111" withFont:[UIFont fontWithName:kRegFont size:14] withColor:defaultColor];
        _titleLabel.textAlignment = UITextAlignmentCenter;
    }
    return _titleLabel;
}


@end
