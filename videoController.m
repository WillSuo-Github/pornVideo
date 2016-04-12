//
//  videoController.m
//  pornVideo
//
//  Created by mac on 16/4/12.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "videoController.h"
#import "serverTool.h"
#import "KRVideoPlayerController.h"

@interface videoController ()
@property (nonatomic, strong) KRVideoPlayerController *videoPlayer;

@end

@implementation videoController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpSubView];
    
    [self getVideoData];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.videoPlayer dismiss];
}

- (void)getVideoData{
    
    [serverTool getPornVideoDataWithUrlStr:self.urlStr successBlock:^(id responseData) {
        NSLog(@"%@",responseData);
        
        [self.videoPlayer setContentURL:[NSURL URLWithString:responseData]];
    } failBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)setUpSubView{
    
    self.videoPlayer = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 250)];
    
    [self.navigationController.view addSubview:self.videoPlayer.view];
    
}


@end
