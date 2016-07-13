//
//  TestCollectionVC.h
//  ComponentDemo
//
//  Created by HuangPeng on 7/3/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestCollectionVC : UICollectionViewController

@end

@interface TestItem : NSObject

@property (nonatomic, strong) NSArray *data;
@property (nonatomic) NSInteger index;
@property (nonatomic) CGSize size;

@property (nonatomic, copy) dispatch_block_t didChangeBlock;

@end

@interface TestCollectionViewCell : UICollectionViewCell

- (void)updateWithData:(TestItem *)item;

@end