//
//  ViewController.m
//  test
//
//  Created by 兴业 on 16/3/31.
//  Copyright © 2016年 ckfear. All rights reserved.
//

#import "ViewController.h"
#import "CustomView.h"
#import "TestFramework.h"
#import "ServerList.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation ViewController
#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupDataSource];
    [self setupSearchBar];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.searchBar];
}

#pragma mark - setupProperty
- (void)setupTableView{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}

- (void)setupDataSource{
    self.dataSource = [NSMutableArray array];
    self.dataSource = [NSMutableArray arrayWithArray:[[TestFramework shareFramework] searchServerListsByServerName:@""]];
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ServerList *server = obj;
        NSLog(@"ID=%@ ,serverName = %@, serverIP = %@, cerSuffix = %@", @(server.ID), server.serverName, server.serverIP, server.cerSuffix);
    }];
    [self.tableView reloadData];
}

- (void)setupSearchBar{
    CGRect rect = [[UIScreen mainScreen] bounds];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(rect), 44)];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat labelWidth = CGRectGetWidth(rect)/3;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(rect), 44)];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, 44)];
    label1.text = @"服务器名";
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, 0, labelWidth, 44)];
    label2.text = @"服务器IP";
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth*2, 0, labelWidth, 44)];
    label3.text = @"证书后缀";
    
    [view addSubview:label1];
    [view addSubview:label2];
    [view addSubview:label3];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"serverCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        [self configCell:cell];
    }
    UILabel *label1 = [cell.contentView viewWithTag:1];
    UILabel *label2 = [cell.contentView viewWithTag:2];
    UILabel *label3 = [cell.contentView viewWithTag:3];
    
    ServerList *server =  self.dataSource[indexPath.row];
    label1.text = server.serverName;
    label2.text = server.serverIP;
    label3.text = server.cerSuffix;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataSource removeObjectAtIndex:row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}


- (void)configCell:(UITableViewCell *)cell{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat labelWidth = CGRectGetWidth(rect)/3;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, 44)];
    label1.tag = 1;
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, 0, labelWidth, 44)];
    label2.tag = 2;
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth*2, 0, labelWidth, 44)];
    label3.tag = 3;
    
    NSArray *array = @[label1, label2, label3];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = obj;
        [cell.contentView addSubview:view];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
