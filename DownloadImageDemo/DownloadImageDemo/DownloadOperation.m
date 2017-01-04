//
//  DownloadOperation.m
//  DownloadImageDemo
//
//  Created by gongwenkai on 2017/1/3.
//  Copyright © 2017年 gongwenkai. All rights reserved.
//

#import "DownloadOperation.h"
@interface DownloadOperation()
@property(nonatomic,copy)NSString *urlStr;

@end

@implementation DownloadOperation

- (instancetype)initWithUrlStr:(NSString*)urlStr {
    self = [super init];
    if (self) {
        self.urlStr = urlStr;
    }
    return self;
}

+ (instancetype)downloadOperationWithUrlStr:(NSString*)urlStr {
    return [[DownloadOperation alloc] initWithUrlStr:urlStr];
}

-(void)main {

    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    //模拟耗时
    sleep(1);
    //返回主线程
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        //block通知
        if (self.imageDataBlock) {
            self.imageDataBlock(data,self.tag);
        }
        //代理通知
        if ([self.delegate respondsToSelector:@selector(downloadOperationWithData:withTag:)]) {
            [self.delegate downloadOperationWithData:data withTag:self.tag];
        }
    }];
 
    }


@end
