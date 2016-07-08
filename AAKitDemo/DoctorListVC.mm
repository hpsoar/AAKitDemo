//
//  DoctorListVC.m
//  ComponentDemo
//
//  Created by HuangPeng on 7/1/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

#import "DoctorListVC.h"
#import "DoctorModel.h"
#import "DoctorInfoComponent.h"
#import <CKComponentSubclass.h>

@interface TestHeaderView : AACollectionReusableView

@end

@implementation TestHeaderView

@end

@interface DoctorListVC ()
@property (nonatomic, strong) DoctorListOptions *doctorListOptions;
@end

@implementation DoctorListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.doctorListOptions = [DoctorModel doctorListOptions];
    self.modelRefresher.modelController = [AAModelController newWithDataSource:[MockDoctorModelDataSource new]];
    self.modelRefresher.modelOptions = self.doctorListOptions;
    
    [self.refreshController enableHeaderRefresh];
    
    [self registerHeaderClass:[TestHeaderView class]];
    
    [self.modelRefresher refresh:ModelRefreshTypeTop];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"test" style:UIBarButtonItemStyleDone target:self action:@selector(getTextField:)];
}


- (void)getTextField:(id)sender {
    
}

- (void)refresher:(AAModelRefresher *)refresher didFinishLoadWithType:(ModelRefreshType)type result:(AAModelResult *)result {
    if (result.error) {
        
    }
    else {
        if (self.doctorListOptions.page == 0) {
            [self.modelViewUpdater removeSectionAtIndex:0];
        }
        NSArray *doctors = result.model;
        if (doctors.count > 0) {
            [self.modelViewUpdater addObjectsFromArray:doctors];
        }
        
        if (doctors.count == self.doctorListOptions.pageSize) {
            self.doctorListOptions.page += 1;
        }
        
        [self test:doctors.firstObject];
        
        [self.refreshController enableFooterRefresh];
    }
}

- (void)test:(DoctorModel *)doctor {
    DoctorInfoComponent *c = (DoctorInfoComponent *)[doctor componentWithContext:nil];
    CKSizeRange contrainedSize = CKSizeRange(CGSizeMake(CGRectGetWidth(self.view.frame), 0),
                                             CGSizeMake(CGRectGetWidth(self.view.frame), INFINITY));
    CKComponentLayout layout = [c layoutThatFits:contrainedSize parentSize:contrainedSize.max];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView headerAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[TestHeaderView identifier] forIndexPath:indexPath];
    
    reusableview.backgroundColor = [UIColor greenColor];
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize headerSize = CGSizeMake(320, 104);
    return headerSize;
}

@end
