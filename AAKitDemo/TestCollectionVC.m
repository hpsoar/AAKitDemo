//
//  TestCollectionVC.m
//  ComponentDemo
//
//  Created by HuangPeng on 7/3/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

#import "TestCollectionVC.h"

static NSString *kReuseIdentifier = @"cell";

@interface TestCollectionVC() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray *data;
@end


@implementation TestCollectionVC

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [layout setMinimumInteritemSpacing:0];
    [layout setMinimumLineSpacing:0];
    
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[TestCollectionViewCell class] forCellWithReuseIdentifier:kReuseIdentifier];
    
    self.data = [self randomData];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView reloadData];
}

- (NSArray *)randomData {
    NSArray *d = @[ @"dfasfsdfasdfsaf",
                    @"发撒的发水电费撒多发点沙发垫是辅导书发撒的发水电费的时发撒的发水电费是打发斯蒂芬森打发水电费撒旦法撒电风扇安师大发撒的发水电费大师发生的发撒的发水电费就快了几斤几两接口" ];
    NSMutableArray *data = [NSMutableArray arrayWithCapacity:10];
    for (NSInteger i = 0; i < 10; ++i) {
        TestItem *item = [TestItem new];
        item.data = d;
        [data addObject:item];
        
        __weak typeof(self) weakSelf = self;
        item.didChangeBlock = ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [weakSelf.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        };
    }
    return data;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseIdentifier forIndexPath:indexPath];
    TestItem *d = self.data[indexPath.row];
    [cell updateWithData:d];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    TestItem *item = self.data[indexPath.row];
    return item.size;
}

@end

@implementation TestItem

- (CGSize)size {
    if (self.index == 0) {
        return CGSizeMake(375, 40);
    }
    return CGSizeMake(375, 120);
}

@end

@implementation TestCollectionViewCell {
    UILabel *_label;
    UIButton *_btn;
    TestItem *_item;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 0)];
        _label.textColor = [UIColor blackColor];
        [self.contentView addSubview:_label];
        
        _btn = [[UIButton alloc] initWithFrame:CGRectMake(300, 0, 60, 30)];
        [_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_btn setTitle:@"toggle" forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btn];
    }
    return self;
}

- (void)toggle:(id)sender {
    _item.index = 1 - _item.index;
    if (_item.didChangeBlock) {
        _item.didChangeBlock();
    }
}

- (void)updateWithData:(TestItem *)item {
    _item = item;
    NSString *t = _item.data[_item.index];
    _label.text = t;
    _label.numberOfLines = 0;
    _label.frame = CGRectMake(10, 10, 280, 0);
    [_label sizeToFit];
}

@end
