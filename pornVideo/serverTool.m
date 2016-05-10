//
//  serverTool.m
//  pornVideo
//
//  Created by mac on 16/4/11.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "serverTool.h"
#import "pronModel.h"


@implementation serverTool


+ (void)getPornListData:(void(^)(id responseData))successBlock failBlock:(void(^)(NSError *error))failBlock{
    
    NSString *urlString = [NSString stringWithFormat:@"!!!!"];  //拼接请求网址
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; //中文转义
    NSURL *url = [NSURL URLWithString:urlString];  //得到URL
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler: ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //得到的data数据转换为字符串
        
        //        NSLog(@"%@",data);
        
        NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //        NSLog(@"%@", html);
        
        //2.从返回的字符串中匹配出(正则表达式过滤)想要的. (另写一个方法findAnswerInHTML)
        //然后通过代理传递结果给主线程,用于更新UI
        //        NSLog(@"%@",connectionError);
        
        
        
        NSArray *arr = [self findListInHTML:html];
        
        successBlock(arr);
        
    }];
}


+ (NSMutableArray *)findListInHTML:(NSString *)html {
    
    //    NSLog(@"%@",html);
    //将需要取出的用(.*?)代替. 大空格换行等用.*?代替,表示忽略.
    

    NSString *pattern = @"<div class=\"thumb-content\">.*?<a href=\"(.*?)\" class=\"kt_imgrc\" title=\"(.*?)\">";
    
    //实例化正则表达式，需要指定两个选项
    //NSRegularExpressionCaseInsensitive  忽略大小写
    //NSRegularExpressionDotMatchesLineSeparators 让.能够匹配换行
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators error:nil];
    
    //匹配出结果集
    
    NSArray *checkResultArr = [regex matchesInString:html options:NSMatchingReportCompletion range:NSMakeRange(0, html.length)];
    
    // 取出找到的内容. 数字分别对应第几个带括号(.*?), 取0时输出匹配到的整句.
    
    
    //        NSLog(@"%@\n", [pattern substringWithRange:checkResult.range]);
    
    //        NSString *result = [html substringWithRange:[checkResult rangeAtIndex:0]];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSTextCheckingResult *checkResult in checkResultArr) {
        
        
        NSString *urlStr = [html substringWithRange:[checkResult rangeAtIndex:1]];
        NSString *title = [html substringWithRange:[checkResult rangeAtIndex:2]];
        
        //        NSRange range = NSMakeRange(50, result.length - 50);
        //        result = [result substringWithRange:range];
        //        result = [result substringToIndex:result.length - 9];
        
        //        NSLog(@"%@",result);
        
//        NSLog(@"%@*************%@",urlStr,title);
        
        pronModel *model = [[pronModel alloc] init];
        model.title = title;
        model.urlStr = urlStr;
        
        [arr addObject:model];
        
        
    }
    
    
    //    NSLog(@"数据为----->%@", result);
    return arr;
}


+ (void)getPornVideoDataWithUrlStr:(NSString *)urlStr successBlock:(void(^)(id responseData))successBlock failBlock:(void(^)(NSError *error))failBlock{
    
    NSString *urlString = [NSString stringWithFormat:@"%@",urlStr];  //拼接请求网址
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; //中文转义
    NSURL *url = [NSURL URLWithString:urlString];  //得到URL
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler: ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //得到的data数据转换为字符串
        
        //        NSLog(@"%@",data);
        
        NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //        NSLog(@"%@", html);
        
        //2.从返回的字符串中匹配出(正则表达式过滤)想要的. (另写一个方法findAnswerInHTML)
        //然后通过代理传递结果给主线程,用于更新UI
        //        NSLog(@"%@",connectionError);
        
        
        
        NSString *urlStr = [self findVideoInHTML:html];
        
        successBlock(urlStr);
        
    }];
}


+ (NSString *)findVideoInHTML:(NSString *)html {
    
    //    NSLog(@"%@",html);
    //将需要取出的用(.*?)代替. 大空格换行等用.*?代替,表示忽略.
    
    
    NSString *pattern = @"video_url: '(.*?)',";
    
    //实例化正则表达式，需要指定两个选项
    //NSRegularExpressionCaseInsensitive  忽略大小写
    //NSRegularExpressionDotMatchesLineSeparators 让.能够匹配换行
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators error:nil];
    
    //匹配出结果集
    
    NSArray *checkResultArr = [regex matchesInString:html options:NSMatchingReportCompletion range:NSMakeRange(0, html.length)];
    
    // 取出找到的内容. 数字分别对应第几个带括号(.*?), 取0时输出匹配到的整句.
    
    
    //        NSLog(@"%@\n", [pattern substringWithRange:checkResult.range]);
    
    //        NSString *result = [html substringWithRange:[checkResult rangeAtIndex:0]];
    NSString *videoUrl;
    for (NSTextCheckingResult *checkResult in checkResultArr) {
        
        
        NSString *urlStr = [html substringWithRange:[checkResult rangeAtIndex:1]];
        
        
        //        NSRange range = NSMakeRange(50, result.length - 50);
        //        result = [result substringWithRange:range];
        //        result = [result substringToIndex:result.length - 9];
        
        //        NSLog(@"%@",result);
        
        videoUrl = urlStr;
        
    }
    
    
    //    NSLog(@"数据为----->%@", result);
    return videoUrl;
}


@end
