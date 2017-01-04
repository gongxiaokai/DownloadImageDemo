//
//  DownloadImage.m
//  DownloadImageDemo
//
//  Created by gongwenkai on 2017/1/3.
//  Copyright © 2017年 gongwenkai. All rights reserved.
//

#import "DownloadImage.h"
#import "DownloadOperation.h"


@interface DownloadImage()
@property (nonatomic,strong)NSOperationQueue *queue;
@property (nonatomic,strong)NSCache *imageCache;
@property (nonatomic,copy)NSString *cachePath;
@property (nonatomic,assign)int imageStartTag;

@end

@implementation DownloadImage

#pragma mark - 懒加载
- (NSString *)cachePath {
    if (!_cachePath) {
        _cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    }
    return _cachePath;
}

- (NSCache *)imageCache {
    if (!_imageCache) {
        _imageCache = [[NSCache alloc] init];
        _imageCache.countLimit = 100;
        
    }
    return _imageCache;
}

- (NSOperationQueue *)queue {
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

- (NSUInteger)MemoryCapacity {
    if (!_MemoryCapacity) {
        _MemoryCapacity = 1;
    }
    return _MemoryCapacity;
}

- (NSUInteger)diskCapacity {
    if (!_diskCapacity) {
        _diskCapacity = 10;
    }
    return _diskCapacity;
}

- (int)maxOperationCount {
    if (!_maxOperationCount) {
        _maxOperationCount = 2;
    }
    return _maxOperationCount;
}

#pragma mark - 初始化
+ (instancetype)downloadImageWithUrlStrArray:(NSArray<NSString*>*)urlArray withStartTag:(int)startTag {
    return [[DownloadImage alloc] initWithUrlStrArray:urlArray withStartTag:startTag];
}

+ (instancetype)downloadImageWithUrlStr:(NSString*)urlStr {
    return [[DownloadImage alloc] initWithUrlStr:urlStr];
}

- (instancetype)initWithUrlStrArray:(NSArray<NSString*>*)urlArray withStartTag:(int)startTag{
    self = [super init];
    if (self) {
        self.urlArray = urlArray;
        self.imageStartTag = startTag;
    }
    return self;
}

- (instancetype)initWithUrlStr:(NSString*)urlStr {
    self = [super init];
    if (self) {
        self.urlStr = urlStr;
    }
    return self;
}

//初始化 set方法 单个url装进数组
- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
    _urlArray = [NSArray arrayWithObject:urlStr];
}


#pragma mark - 加载图片
- (void)starDownloadImage {
    
    //设置内存缓存和磁盘缓存大小
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:self.MemoryCapacity * 1024 * 1024 diskCapacity:self.diskCapacity * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];

    //加载数据
    for (int i = 0; i < self.urlArray.count; i++) {
        int imageTag = self.imageStartTag + i;
        NSString *urlStr = self.urlArray[i];
        //从内存缓存中读取图片
        UIImage *memoryImage = [self.imageCache objectForKey:urlStr];
        if (memoryImage) {
            //block回调结果
            if (self.downloadFinishedBlock) {
                self.downloadFinishedBlock(memoryImage,imageTag,self.tag);
            }
            //代理回调结果
            if ([self.delegate respondsToSelector:@selector(downloadImageFinishedWith:andTag:withQueueTag:)]) {
                [self.delegate downloadImageFinishedWith:memoryImage andTag:imageTag withQueueTag:self.tag];
            }
            continue;
        }
        //从磁盘缓存中读取图片
        NSString *imagePath=[urlStr lastPathComponent];
        NSString *imageCachePath = [self.cachePath stringByAppendingPathComponent:imagePath];
        NSData *data = [NSData dataWithContentsOfFile:imageCachePath];
        if (data) {
            UIImage *diskImage = [UIImage imageWithData:data];
            //block回调结果
            if (self.downloadFinishedBlock) {
                self.downloadFinishedBlock(diskImage,imageTag,self.tag);
            }
            //代理回调结果
            if ([self.delegate respondsToSelector:@selector(downloadImageFinishedWith:andTag:withQueueTag:)]) {
                [self.delegate downloadImageFinishedWith:diskImage andTag:imageTag withQueueTag:self.tag];
            }
            continue;
        }
        
        
        //创建线程加载图片
        self.queue.maxConcurrentOperationCount = self.maxOperationCount;
        DownloadOperation *op = [DownloadOperation downloadOperationWithUrlStr:urlStr];
        
        op.tag = i + kImageViewTag;
        if (self.urlArray.count < self.maxOperationCount) {
            [op start];
        }else {
            [self.queue addOperation:op];
        }
    
        //线程回调结果
        op.imageDataBlock = ^(NSData *data,int tag){
            UIImage *image = [UIImage imageWithData:data];
            
            //写入内存缓存
            [self.imageCache setObject:image forKey:urlStr];
            //写入磁盘缓存
            [data writeToFile:imageCachePath atomically:YES];
            
            //block回调
            if (self.downloadFinishedBlock) {
                NSLog(@"tage ======%d",tag);
                self.downloadFinishedBlock(image,tag,self.tag);
            }
            //代理回调
            if ([self.delegate respondsToSelector:@selector(downloadImageFinishedWith:andTag:withQueueTag:)]) {
                [self.delegate downloadImageFinishedWith:image andTag:tag withQueueTag:self.tag];
            }
            
        };

    }
    
}

@end
