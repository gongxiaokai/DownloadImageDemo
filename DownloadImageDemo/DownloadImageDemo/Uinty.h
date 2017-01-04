//
//  Uinty.h
//  DownloadImageDemo
//
//  Created by gongwenkai on 2017/1/3.
//  Copyright © 2017年 gongwenkai. All rights reserved.
//

#ifndef Uinty_h
#define Uinty_h
#import <UIKit/UIKit.h>

typedef void(^DownloadImageDataBlock)(NSData *data,int tag);
typedef void(^DownloadImageBlock)(UIImage *image,int tag,int queueTag);


static int const  kImageViewTag = 1990;



//线程操作协议
@protocol DownloadOperationDelegate <NSObject>
//线程下载数据完成
- (void)downloadOperationWithData:(NSData*)data withTag:(int)tag;

@end

//下载操作协议
@protocol DownloadImageDelegate <NSObject>
//图片回调
- (void)downloadImageFinishedWith:(UIImage*)image andTag:(int)tag withQueueTag:(int)queueTag;
@end

#endif /* Uinty_h */
