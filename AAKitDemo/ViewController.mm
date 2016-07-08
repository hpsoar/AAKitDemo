//
//  ViewController.m
//  ComponentDemo
//
//  Created by HuangPeng on 6/30/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

#import "ViewController.h"
#import "HostViewVC.h"
#import "DoctorListVC.h"
#import "TestCollectionVC.h"
#import "DoctorListVC2.h"
#import "ComponentDemo-Swift.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:[self btnWithTitle:@"ck hosting view" sel:@selector(hostViewDemo:)]];
    [self.view addSubview:[self btnWithTitle:@"ck collection" sel:@selector(collectionViewDemo:)]];
    [self.view addSubview:[self btnWithTitle:@"normal collection" sel:@selector(collectionViewDemo2:)]];
    [self.view addSubview:[self btnWithTitle:@"ck table" sel:@selector(ckTableVCDemo:)]];
    [self.view addSubview:[self btnWithTitle:@"ni table" sel:@selector(niTableVCDemo:)]];
    [self.view addSubview:[self btnWithTitle:@"asyncdisplay kit" sel:@selector(asyncDisplayDemo:)]];
    
}

- (UIButton *)btnWithTitle:(NSString *)title sel:(SEL)sel {
    static NSInteger i = 0;
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(10, 100 + i * 40, 120, 30)];
    [btn3 setTitle:title forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn3 addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    
    i += 1;
    return btn3;
}

- (void)ckTableVCDemo:(id)sender {
    DoctorListVC2 *vc = [DoctorListVC2 new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)hostViewDemo:(id)sender {
    HostViewVC *vc = [HostViewVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)collectionViewDemo:(id)sender {
    DoctorListVC *vc = [DoctorListVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)collectionViewDemo2:(id)sender {
    TestCollectionVC *vc = [TestCollectionVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)niTableVCDemo:(id)sender {
    DoctorListVC4 *vc = [DoctorListVC4 new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)asyncDisplayDemo:(id)sender {
    AsyncDisplayKitDemo *vc = [AsyncDisplayKitDemo new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
