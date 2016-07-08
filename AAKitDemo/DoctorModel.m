//
//  DoctorModel.m
//  ComponentDemo
//
//  Created by HuangPeng on 7/1/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

#import "DoctorModel.h"


@implementation DoctorModel

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    return [propertyName mj_underlineFromCamel];
}

@end

@implementation DoctorListOptions

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    return [propertyName mj_underlineFromCamel];
}

- (Class)modelClass {
    return [DoctorModel class];
}

- (void)reset {
    [super reset];
    self.page = 0;
}

@end

@implementation DoctorModel (API)

+ (DoctorListOptions *)doctorListOptions {
    DoctorListOptions *options = [DoctorListOptions new];
    options.pageSize = 20;
    return options;
}

+ (AAURLModelDataSource *)doctorListDataSource {
    AAURLModelDataSource *dataSource = [AAURLModelDataSource newWithKit:nil API:@"/api/doctor/list/"];
    return dataSource;
}

@end

#pragma mark - mock

@implementation MockDoctorModelDataSource

- (void)fetch:(AAModelOptions *)options callback:(void (^)(id, NSError *))callback {
    DoctorListOptions *doctorListOptions = (DoctorListOptions *)options;
    
    NSArray *names = @[@"张三", @"李四Aagf", @"王麻子yyyyy", @"AAfygf" ];
    NSArray *titles = @[ @"主任医师", @"副主任医师", @"院长", @"zfghij" ];
    NSArray *clinics = @[ @"内科", @"外科", @"骨科", @"神经科", @"内分泌科", @"眼科", @"牙科" ];
    NSArray *hospitals = @[ @"北医三院", @"校医院", @"协和医院", @"同济医院" ];
    NSArray *goodAts = [[self class] goodAts];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:20];
    NSInteger dataCount = names.count * titles.count * clinics.count * goodAts.count;
    if (doctorListOptions.pageSize * doctorListOptions.page < dataCount) {
        for (NSInteger i = 0; i < doctorListOptions.pageSize; ++i) {
            NSDictionary *d = @{ @"_id": @(doctorListOptions.page * doctorListOptions.pageSize + i),
                                 @"name": names[arc4random() % 4],
                                 @"title": titles[arc4random() % 4],
                                 @"clinic": clinics[arc4random() % 7],
                                 @"hospital": hospitals[arc4random() % 4],
                                 @"good_at": [[self class] randomGoodAt],
                                 };
            [result addObject:d];
        }
    }
    
    if (callback) {
        callback(result, nil);
    }
}

+ (NSArray *)goodAts {
    return @[ @"吃饭、睡觉、打豆豆",
              @"无所不会、无所不能",
              @"什么都不会。",
              @"发斯蒂芬森的大沙发垫是发撒的发水电费是打发撒的发水电费点撒辅导书发撒的发水电费撒东方时代发撒撒旦法算法大师安师大发撒的发水电费撒旦法阿凡达萨阿德沙发上东方大厦范德萨范德萨发生的发生的发生的发生的发生的发撒的发水电费撒",
              @"dsfasdfasdfsadfsafsadfasdfasdfas sdfsadfasdf asdfasdfasdfsad asdfsadfasdf asdfasdfasdfsadf asdfadsfsadf  asdfasdfdsfasdd   asdfasdfsafd"];
}

+ (NSString *)randomGoodAt {
    static int r = 0;
    r = arc4random() % 5;
    return [self goodAts][r];
}

@end
