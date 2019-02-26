//
//  ViewController.m
//  ScrollDemo
//
//  Created by 中国孔 on 2019/2/26.
//  Copyright © 2019 孔令辉. All rights reserved.
//

#import "ViewController.h"
#import "LsView.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong , nonatomic) LsView *lsView;
@property (strong , nonatomic) UITableView *tableView;
// Section 数组
@property (strong , nonatomic) NSMutableArray *sectionArray;
// 顶部的View
@property (strong , nonatomic) UIView *headerView;
// 开关标签 保证上下滑动与点击按钮时最多只响应一个事件
@property (assign , nonatomic) BOOL scrollEnable;
// 单独记录每一个按钮点击时候tableview 需要偏离的距离
@property (strong , nonatomic) NSMutableArray *headerOffsetArray;


@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationItem.title = @"联动选择器";
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
     [self.view addSubview:self.tableView];
    
    [self makeSectionHeaderContentOffset];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
     self.scrollEnable = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offset = scrollView.contentOffset.y;
    
    [self fixlsViewExpreseLocation:offset];
    
    [self configtitleExpressContent:offset];
    
}


// tableView 滚动时候动态切换按钮的显示状态

- (void)configtitleExpressContent:(CGFloat)offset{
 
    //1.0 判断当前BUTTON事件 不是按钮点击事件 做出响应
    if (!self.scrollEnable) {
        
        for (int i = 0; i < self.headerOffsetArray.count; i ++) {
         
            // 最后一个单独处理
            if (i == self.headerOffsetArray.count -1) {
                
                if (offset >= [self.headerOffsetArray[i] floatValue]) {
                   
                    [self.lsView setTitleindex:i];
                }
                
            }else{
                
                if (offset >= [self.headerOffsetArray[i] floatValue] && offset < [self.headerOffsetArray[i+1] floatValue]) {
                    
                    [self.lsView setTitleindex:i];
                
                }
                
            }
            
            
        }
        
    }
    
    
    
}


// 顶部点击按钮显示位置 动态布局
//动态的修正 顶部按钮的显示位置 向上滚动时固定在导航栏下 向下滚动时候 恢复到初始化位置
- (void)fixlsViewExpreseLocation:(CGFloat)offset{
    
    // 1.0 判断此时h是否将要被导航栏遮挡
    if (offset > 200) {
        
        // 避免滚动时重复一直调用
        if ([self.lsView.superview isEqual:self.view]) {
            return;
        }
        // 将要被导航栏遮挡 固定位置在导航栏下方
        self.lsView.frame = CGRectMake(0, [[UIApplication sharedApplication] statusBarFrame].size.height + 40, SCREEN_WIDTH, 44);
        [self.view addSubview:self.lsView];
        
    }else{
        
        // 避免滚动时重复一直调用
        if ([self.lsView.superview isEqual:self.tableView]) {
            return;
        }
        
        self.lsView.frame = CGRectMake(0, 250, SCREEN_WIDTH, 44);
        [self.headerView addSubview:self.lsView];
    }
    
    

}

















// 把点击顶部按钮时 tableView需要作出的便宜量计算出来
- (void)makeSectionHeaderContentOffset{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self.headerOffsetArray removeAllObjects];
        
        for (int i= 0; i < self.lsView.titleArray.count; i ++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
            
            CGRect rect = [self.tableView rectForSection:indexPath.section];
            
            CGFloat offset = rect.origin.y - [[UIApplication sharedApplication] statusBarFrame].size.height - 44 - 44;
            
            [self.headerOffsetArray addObject:[NSNumber numberWithFloat:offset]];

        }

    });
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.lsView.titleArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"这是第%ld个展示的cell",indexPath.row];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return self.sectionArray[section];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}


- (NSMutableArray *)headerOffsetArray{
    
    if (!_headerOffsetArray) {
        
        _headerOffsetArray = [NSMutableArray array];
    }
    return _headerOffsetArray;
}


- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableHeaderView = self.headerView;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableCell"];
      
        [self.view addSubview:_tableView];
        [_tableView addSubview:_lsView];
    }
    return _tableView;
}



- (LsView *)lsView{
    
    if (!_lsView) {
    
        _lsView = [LsView new];
        _lsView.frame = CGRectMake(0, 250, SCREEN_WIDTH, 50);
        _lsView.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
//        _lsView.backgroundColor = [UIColor redColor];
        _lsView.titleArray = @[@"城市服务",@"出行服务",@"生活缴费",@"家居生活",@"生物团体",@"美团外卖",@"蚂蚁金服",@"金融理财",@"生活服务"];
        
        __weak typeof(self) weakSelf = self;
//        [self.headerView addSubview:_lsView];
        _lsView.whichButtonSelect = ^(NSInteger index) {
          
            CGRect rect = [weakSelf.tableView rectForSection:index];
            
            CGFloat offset = rect.origin.y - [[UIApplication sharedApplication] statusBarFrame].size.height - 44 - 44;
            
            [weakSelf.tableView setContentOffset:CGPointMake(0, offset) animated:YES];
            weakSelf.scrollEnable = YES;
            
        };
        
    }
    
    return _lsView;
}


- (UIView *)headerView{
    
    if (!_headerView) {
        
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fzlmnhctxb_62928.jpg"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 250);
        [_headerView addSubview:imageView];
        
    }
    return _headerView;
}


- (NSMutableArray *)sectionArray{
    
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray array];
        
        for (int i = 0;i < self.lsView.titleArray.count; i ++) {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
            headerView.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
            
            UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
            titlelabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
            titlelabel.text = self.lsView.titleArray[i];
            titlelabel.font = [UIFont systemFontOfSize:15.0f];
            titlelabel.textAlignment = NSTextAlignmentCenter;
            titlelabel.center = headerView.center;
            
            [headerView addSubview:titlelabel];
            [_sectionArray addObject:headerView];
            
        }
        
    }
    return _sectionArray;
}


@end
