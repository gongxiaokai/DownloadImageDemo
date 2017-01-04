//
//  DownloadOperation.h
//  DownloadImageDemo
//
//  Created by gongwenkai on 2017/1/3.
//  Copyright © 2017年 gongwenkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Uinty.h"




@interface DownloadOperation : NSOperation

//block
@property (nonatomic,copy)DownloadImageDataBlock imageDataBlock;
//标识
@property (nonatomic,assign)int tag;

//代理
@property (nonatomic,strong)id<DownloadOperationDelegate> delegate;

//初始化
- (instancetype)initWithUrlStr:(NSString*)urlStr;

+ (instancetype)downloadOperationWithUrlStr:(NSString*)urlStr;
@end
