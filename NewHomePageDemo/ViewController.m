//
//  ViewController.m
//  NewHomePageDemo
//
//  Created by MacOS on 2018/7/19.
//  Copyright © 2018年 MacOS. All rights reserved.
//

#import "ViewController.h"
#import "ScrollMenuView.h"
#import "MainViewController.h"
#import "YX.h"
#import "YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView.h"

#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,ScrollMenuDIYFBCDelgate>
@property (nonatomic,strong) YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView *tableView;
@property (nonatomic,strong) UITableView *producListTableView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) UIView *headTopView;
@property (nonatomic,strong) ScrollMenuView *scrollMenu;


@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;

@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;

@property (nonatomic, assign) BOOL canScroll;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    image.image = [UIImage imageNamed:@"head.jpg"];
    [self.headTopView addSubview:image];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 180)];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor blueColor];

    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = view;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kLeaveTopNotificationName object:nil];
    
    [self initTopView];
    [self initBottomView];
}
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    NSLog(@"statusBar.backgroundColor--->%@",statusBar.backgroundColor);
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}
-(void)initTopView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kTopBarHeight)];
    topView.backgroundColor = [UIColor orangeColor];
    //topView.alpha = 0.0;
    UILabel *textLabel = [[UILabel alloc] initWithFrame:topView.bounds];
    textLabel.text = @"顶部BAR";
    textLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:textLabel];
    [self.view addSubview:topView];
}

-(void)initBottomView{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-kBottomBarHeight, CGRectGetWidth(self.view.frame), kBottomBarHeight)];
    bottomView.backgroundColor = [UIColor orangeColor];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:bottomView.bounds];
    textLabel.text = @"底部BAR";
    textLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:textLabel];
    [self.view addSubview:bottomView];
}
-(void)acceptMsg : (NSNotification *)notification{
    //NSLog(@"%@",notification);
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}
-(ScrollMenuView *)scrollMenu{
    
    if (!_scrollMenu) {
        
        _scrollMenu = [[ScrollMenuView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 44)];
        _scrollMenu.delegate = self;//代理事件根据需要添加，ScrollMenuDIYFBCDelgate
        //NSArray *array=@[@"首页",@"热点",@"最新"];
        //NSArray *array=@[@"首页",@"热点",@"最新",@"最火",@"最冷",@"商业"];
        NSArray *array=@[@"首页",@"热点",@"最新",@"最火",@"最冷",@"商业",@"艺术",@"文化",@"教育",@"历史",@"文学",@"社会",@"美术",@"地理",@"科学"];
        //初始化菜单栏
        [_scrollMenu initScrollMenuFrame:CGRectMake(0, 0, SCREENW, 44) andTitleArray:array andDisplayNumsOfMenu:6];
        //初始化内容翻页
        [_scrollMenu ScrollViewContent:CGRectMake(0, 0, SCREENW, SCREENH)];
        
        //[self.navigationController.navigationBar addSubview:scrollMenu];//添加菜单栏
        //[self.navigationController.navigationBar addSubview:scrollMenu.plusMenuBTN];//添加加号按钮
        
        //添加滚动内容页面到指定视图
        //[self.view addSubview:scrollMenu.contentScrollView];
        
        //添加子视图，请求数据
        for (int i = 0 ; i < array.count; i++) {
            MainViewController *vc = [[MainViewController alloc]init];
            vc.view.frame=CGRectMake(i * SCREENW, 0, SCREENW, SCREENH);
            [vc postNetWorkingWithTitle:array[i]];//传递请求数据
            [_scrollMenu.contentScrollView addSubview:vc.view];
            [self addChildViewController:vc];
            
        }
    }
    return _scrollMenu;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), SCREEN_HEIGHT-kBottomBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(UIView *)headTopView{
    if (!_headTopView) {
        _headTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 180)];
        _headTopView.userInteractionEnabled = YES;
        _headTopView.backgroundColor = [UIColor blueColor];
    }
    return _headTopView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 1;
        
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cellid1"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellid1"];
        }
        
        if ([indexPath section] == 0) {
            
            [cell.contentView addSubview:self.headTopView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
        
            cell.backgroundColor = [UIColor blueColor];
            [cell.contentView addSubview:self.scrollMenu.contentScrollView];
        }
        
        return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    CGFloat height = 0.;
    if (section==0) {
        height = 180;
    }else {
         height = CGRectGetHeight(self.view.frame)-kBottomBarHeight-kTopBarHeight;
    }
    return height;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return self.scrollMenu;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

        if (section == 0) {

            return 0;

        }else{

            return 44;
        }


}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat tabOffsetY = [_tableView rectForSection:1].origin.y-kTopBarHeight;
    CGFloat offsetY = scrollView.contentOffset.y;
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    if (offsetY>=tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        _isTopIsCanNotMoveTabView = YES;
    }else{
        _isTopIsCanNotMoveTabView = NO;
    }
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
            //NSLog(@"滑动到顶端");
            [[NSNotificationCenter defaultCenter] postNotificationName:kGoTopNotificationName object:nil userInfo:@{@"canScroll":@"1"}];
            _canScroll = NO;
        }
        if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
            //NSLog(@"离开顶端");
            if (!_canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        }
    }
}

/*
 ScrollMenuDIYFBCDelgate  代理事件，根据需求可用可不用
 */
-(void)MenuButtonIsReallyClick:(UISegmentedControl *)SegmentedC{
    NSLog(@"v----selectedSegmentIndex = %ld",SegmentedC.selectedSegmentIndex);
}
-(void)PlusButtonIsReallyClick:(UIButton *)button{
    NSLog(@"v----PlusButtonIsReallyClick =%ld",button.tag);
}
-(void)PlusShowViewInsideButtonIsReallyClick:(UIButton *)button{
    NSLog(@"v----PlusShowViewInsideButtonIsReallyClick = %ld",button.tag);
}
-(void)scrollToWhichMenu:(int)MenuSegmentIndex{
    NSLog(@"v----scrollToWhichMenu = %d",MenuSegmentIndex);
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
