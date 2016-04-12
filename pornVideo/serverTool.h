//
//  serverTool.h
//  pornVideo
//
//  Created by mac on 16/4/11.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface serverTool : NSObject

+ (void)getPornListData:(void(^)(id responseData))successBlock failBlock:(void(^)(NSError *error))failBlock;

+ (void)getPornVideoDataWithUrlStr:(NSString *)urlStr successBlock:(void(^)(id responseData))successBlock failBlock:(void(^)(NSError *error))failBlock;

@end
