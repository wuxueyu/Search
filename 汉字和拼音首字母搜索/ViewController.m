//
//  ViewController.m
//  汉字和拼音首字母搜索
//
//  Created by wuxueyu on 16/7/5.
//  Copyright © 2016年 wuxueyu. All rights reserved.
//

#import "ViewController.h"
#import "YTSearchViewController.h"
#import "AppDelegate.h"
#import "YTSearchModel.h"

@interface ViewController ()

@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *arrayName = @[@"哈尔滨",@"北京",@"厦门",@"武汉",@"成都",@"沈阳",@"大连",@"郑州"];
    
    for (int i = 0; i < arrayName.count; i ++) {
        NSString *str = arrayName[i];
        YTSearchModel *model = [[YTSearchModel alloc] init];
        model.name = arrayName[i];
        [self.dataSource addObject:model];
    }
    
}


-(void)setupUI{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:@"进入搜索页面" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    button.bounds = CGRectMake(0, 0, 200, 100);
    button.center = self.view.center;
    [self.view addSubview:button];
    
}

-(void)buttonDidClicked{
    
    YTSearchViewController *controller = [[YTSearchViewController alloc] init];
    controller.externalDataSource = self.dataSource;
    [self.navigationController pushViewController:controller animated:YES];
   
    
}


-(NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        
        _dataSource =[NSMutableArray array];
    }
    
    return _dataSource;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
