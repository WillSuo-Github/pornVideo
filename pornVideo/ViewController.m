//
//  ViewController.m
//  pornVideo
//
//  Created by mac on 16/4/11.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"
#import "serverTool.h"
#import "pronModel.h"
#import "videoController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *sourceArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) videoController *videoVc;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //http://www.999re7.com/videos/40872/483f91c600f8416efbafb9f5ded100d7/
    
    [self setUpSubView];
    [self getData];
    
}

- (void)setUpSubView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:tableView];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
}

- (void)getData{
    
    
    
    
    [serverTool getPornListData:^(id responseData) {
        
        NSLog(@"%@",responseData);
        self.sourceArr = responseData;
        if (self.sourceArr.count == 0) {
            [self getData];
        }
        [self.tableView reloadData];
        
    } failBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
}

#pragma mark - 代理和数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.sourceArr.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    pronModel *model = self.sourceArr[indexPath.row];
    cell.textLabel.text = model.title;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    pronModel *model = self.sourceArr[indexPath.row];
    videoController *videoVc = [[videoController alloc] init];
    self.videoVc = videoVc;
    videoVc.urlStr = model.urlStr;
    [self.navigationController pushViewController:videoVc animated:YES];
}


#pragma mark - 懒加载
- (NSArray *)sourceArr{
    
    if (_sourceArr == nil) {
        _sourceArr = [NSArray array];
    }
    return _sourceArr;
}



@end
