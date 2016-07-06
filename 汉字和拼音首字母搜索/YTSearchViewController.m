//
//  YTSearchViewController.h
//  汉字和拼音首字母搜索
//
//  Created by wuxueyu on 16/7/5.
//  Copyright © 2016年 wuxueyu. All rights reserved.
//

#import "YTSearchViewController.h"
#import "YTSearchModel.h"
#import "ICPinyinGroup.h"

@interface YTSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UISearchBar *searchBar;

@property (nonatomic,strong) NSArray *dataSource;



@property (nonatomic,strong) UIAlertView *confirmAlertView;

@end

@implementation YTSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataSource = [NSArray array];
    
    [self buildTableView];
    
    [self buildSearchBar];
    
    [self buildRightBarItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardDidShowNotification object:nil];
}
- (void)showKeyBoard:(NSNotification *)noti
{
    CGFloat height = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size.height;
    
    CGRect frame = _tableView.frame;
    frame.size.height = [UIScreen mainScreen].bounds.size.height - height;
    _tableView.frame = frame;
}
#pragma mark 创建searbar布局视图
- (void)buildSearchBar
{
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 44, 44.f)];
    _searchBar.placeholder = @"请输要查询的名称和首字母拼音";
  
    [_searchBar setSearchResultsButtonSelected:YES];
  
    [_searchBar becomeFirstResponder];
    
    _searchBar.delegate = self;
    
    _searchBar.keyboardType = UIKeyboardTypeDefault;
    
    [_searchBar sizeToFit];
    
    [self.navigationItem setHidesBackButton:YES];
    
    self.navigationItem.titleView = _searchBar;
    
}
#pragma mark 自定义右侧取消按钮
- (void)buildRightBarItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setFrame:CGRectMake(0, 0, 44, 44)];
    
    [button setTitle:@"取消" forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}
- (void)cancelButtonAction:(UIButton *)button
{
    [_searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)buildTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
}
#pragma mark tableView 代理方法和数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    YTSearchModel *village = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = village.name;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}

#pragma mark searchbar代理方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self fileterArray:searchText];
}

- (void)fileterArray:(NSString *)searchText
{
    //创建谓词搜索 通过name 和 firstCharactors 两个属性来查找结果 判断是否包含用户输入的内容
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains [cd] %@ || SELF.firstCharactors contains [cd] %@",searchText,searchText];
    self.dataSource = [self.externalDataSource filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
}

-(void)setExternalDataSource:(NSArray *)externalDataSource{
    
    _externalDataSource = externalDataSource;
    
    //遍历数据源 获取首字母
    for (YTSearchModel *villages in externalDataSource) {
        
        NSMutableString *firstCharactors = [NSMutableString string];
        for (int i = 0; i < villages.name.length; i ++) {
            
        NSString *str =[villages.name substringWithRange:NSMakeRange(i, 1)];
        //汉字转为拼音
        unichar pinyin =[ICPinyinGroup firstCharactor:str];
        [firstCharactors appendString:[[NSString stringWithFormat:@"%C",pinyin]lowercaseString]];
        
        }
        villages.firstCharactors = firstCharactors;
    }
    
}


@end
