//
//  DownloadImage.h
//  DownloadImageDemo
//
//  Created by gongwenkai on 2017/1/3.
//  Copyright © 2017年 gongwenkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadOperation.h"



@interface DownloadImage : NSObject

//加载完成
@property (nonatomic,copy)DownloadImageBlock downloadFinishedBlock;
//加载单张时使用
@property (nonatomic,copy)NSString *urlStr;
//加载多张时使用
@property (nonatomic,strong)NSArray *urlArray;
//队列线程最大并发数
@property (nonatomic,assign)int  maxOperationCount;
//代理
@property (nonatomic,strong)id<DownloadImageDelegate> delegate;
//标识
@property (nonatomic,assign)int tag;

//磁盘缓存 内存缓存 单位：M
@property (nonatomic,assign)NSUInteger diskCapacity;
@property (nonatomic,assign)NSUInteger MemoryCapacity;

//初始化传url数组
- (instancetype)initWithUrlStrArray:(NSArray<NSString*>*)urlArray withStartTag:(int)startTag ;
//初始化单url
- (instancetype)initWithUrlStr:(NSString*)urlStr ;
//类工厂
+ (instancetype)downloadImageWithUrlStrArray:(NSArray<NSString*>*)urlArray withStartTag:(int)startTag ;
+ (instancetype)downloadImageWithUrlStr:(NSString*)urlStr ;


//开始下载
- (void)starDownloadImage;

@end
