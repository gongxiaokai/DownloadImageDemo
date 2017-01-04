//
//  ViewController.m
//  DownloadImageDemo
//
//  Created by gongwenkai on 2017/1/3.
//  Copyright © 2017年 gongwenkai. All rights reserved.
//

#import "ViewController.h"
#import "DownloadImage.h"
@interface ViewController ()<DownloadImageDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    for (int i = 0; i < 6; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, i*105, 100, 100)];
        imgView.tag = i + kImageViewTag;
        imgView.backgroundColor = [UIColor redColor];
        [self.view addSubview:imgView];
    }
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(120, 100, 100, 100)];
    imgView.backgroundColor = [UIColor redColor];
    imgView.tag = 1234;
    [self.view addSubview:imgView];
    
    NSLog(@"%@",NSHomeDirectory());

}


//通过代理回调操作
- (void)downloadImageFinishedWith:(UIImage*)image andTag:(int)tag withQueueTag:(int)queueTag{
    if (queueTag == 0) {
        UIImageView *img = [self.view viewWithTag:tag];
        img.image = image;
    } else if (queueTag == 1) {
        UIImageView *imgV = [self.view viewWithTag:1234];
        imgV.image = image;
    }

}

- (IBAction)clickLoadImages:(id)sender {
    //下载多张图片
    DownloadImage *download = [DownloadImage downloadImageWithUrlStrArray:@[@"http://img.hb.aicdn.com/6e004cb3c5f58f016a57b90f8bbb93d7075453f2efd0-anTckt_fw658",@"http://img.hb.aicdn.com/fb18b522caf2821adb7af96f8656787f8d9bdad31bdec-6f6h4X_fw658",@"http://img.hb.aicdn.com/22e4dfd8d135de7ae0d451e351c00bddf732919920840-BMRw4Z_fw658",@"http://img.hb.aicdn.com/536c96af48b38faca5bcad20ba0ea6aba8929b711e5b4-lvdBlI_fw658",@"http://img.hb.aicdn.com/055e5458bd340a52ca0067f5d7c22b6c3b18d119292ae-QLEsYp_fw658",@"http://img.hb.aicdn.com/b50481ab8a2b4e3587068df0552ebad08409f0b3ca23-8gBQ9x_fw658"] withStartTag:kImageViewTag];
    //设置并发数
    download.maxOperationCount = 3;
    download.tag = 0;
    download.delegate = self;
    /*   block 回调 结果
     download.downloadFinishedBlock = ^(UIImage *image,int tag,int queueTag) {
     UIImageView *img = [self.view viewWithTag:tag];
     img.image = image;
     NSLog(@"jicia====%d",tag);
     };
     */
    //开始下载
    [download starDownloadImage];

    
}

- (IBAction)clickLoadSingalImage:(id)sender {
    
    //单张下载
    
    DownloadImage *down = [DownloadImage downloadImageWithUrlStr:@"http://img.hb.aicdn.com/b50481ab8a2b4e3587068df0552ebad08409f0b3ca23-8gBQ9x_fw658"];
    down.tag = 1;
    down.delegate = self;
    
    /*   block 回调 结果
     down.downloadFinishedBlock = ^(UIImage *image,int tag,int queueTag) {
     UIImageView *imgV = [self.view viewWithTag:1234];
     imgV.image = image;
     };
     */
    [down starDownloadImage];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cleanAll:(id)sender {
    
    for (int i = 0; i < 6; i++) {
        UIImageView *imgView = [self.view viewWithTag:i + kImageViewTag];
        imgView.image = nil;
    }
    UIImageView *imgView = [self.view viewWithTag:1234];
    imgView.image = nil;
    
}


@end
