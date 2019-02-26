//
//  LsView.m
//  ScrollDemo
//
//  Created by 中国孔 on 2019/2/26.
//  Copyright © 2019 孔令辉. All rights reserved.
//

#import "LsView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
@interface LsView ()

@property (strong , nonatomic) UIScrollView *scrollView;
@property (assign , nonatomic) CGFloat totalWidth;
@property (strong , nonatomic) UIView *bottomView;//底部线条
@property (strong , nonatomic) NSMutableArray *buttonArray;

@property (strong , nonatomic) UIButton *currentbutton;//当前选选择的按钮

@end

@implementation LsView


- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
    }
    return self;
    
}




// (按钮 + 间隙长度)是否超出屏幕宽度
- (BOOL)isMoreLenComparewithscreenWidth{
    
    CGFloat buttonWidth = 0;
    buttonWidth += 18;
    
    for (int i = 0; i < self.titleArray.count; i ++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:18.0f];
        label.text = self.titleArray[i];
        
        [label sizeToFit];
        buttonWidth += label.frame.size.width;
        buttonWidth += 22;//间隙宽度
        
        _totalWidth += label.frame.size.width;
    }
    
    if (buttonWidth <= SCREEN_WIDTH - 18) {
        
        return NO;
    }else{
        
        return YES;
    }
    
    
}


- (void)setTitleindex:(NSInteger)titleindex{
    
    // 判断 当前显示位置位与 选择按钮需要滚动位置时 不处理
    // titleArray 数组为空 不处理
    if (_titleindex == titleindex) {
    
        return;
    }

    _titleindex = titleindex;
    
    if (self.titleArray.count == 0) {
        
        return;
    }
    
    // 取到当前选择的按钮 处理滚动事件
    UIButton *currentBtn = self.buttonArray[titleindex];
    [self changeSelectbuttonAction:currentBtn];
    
}


- (void)setTitleArray:(NSArray *)titleArray{
    
    _titleArray = titleArray;
    
    BOOL islarge = [self isMoreLenComparewithscreenWidth];
    
    [self addSubview:self.scrollView];

    
    NSInteger btnOffset = 0;
    if (islarge) {
        
        // 当按钮宽度大于屏幕总宽度时
        for (int i = 0; i < self.titleArray.count; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:51.0f/255.0f blue:180.0f/255.0f alpha:1.0f] forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:15.0f];

            button.tag = i;
            [button sizeToFit];

            CGFloat btnX  = i ? btnOffset+38:18;

            button.frame = CGRectMake(btnX, 6, button.frame.size.width, 44);
            
            btnOffset = CGRectGetMaxX(button.frame);
            button.titleLabel.textAlignment = NSTextAlignmentLeft;
            [button addTarget:self action:@selector(changeSelectbuttonAction:) forControlEvents:UIControlEventTouchUpInside];


            [self.scrollView addSubview:button];
            [self.buttonArray addObject:button];

            if (i == 0) {

                button.selected = YES;
                button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
                self.currentbutton = button;
                
                self.bottomView.frame = CGRectMake(button.frame.origin.x, self.scrollView.frame.size.height-2, button.frame.size.width, 2);
                self.bottomView.backgroundColor = [UIColor redColor];
                [self.scrollView addSubview:self.bottomView];

            }

            
        }
  
        
    }
    else{
    // 当按钮总宽度小于 屏幕宽度时
       // 1.0计算 计算个按钮之间的间距
        CGFloat btnWidth = (SCREEN_WIDTH - self.totalWidth)/(self.titleArray.count + 1);
        
        for (int i = 0; i < self.titleArray.count; i ++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:51.0f/255.0f blue:180.0f/255.0f alpha:1.0f] forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            
            button.tag = i;
            [button sizeToFit];

            CGFloat btnX = i ? btnWidth + btnOffset : 18;
            button.frame = CGRectMake(btnX, 6, button.frame.size.width, 44);
            
            btnOffset = CGRectGetMaxX(button.frame);
            button.titleLabel.textAlignment = NSTextAlignmentLeft;
            
            [button addTarget:self action:@selector(changeSelectbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
            button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [self.scrollView addSubview:button];
            [self.buttonArray addObject:button];
            
            
            if (i == 0) {
                button.selected = YES;
                button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
                self.currentbutton = button;
                
                self.bottomView.frame = CGRectMake(button.frame.origin.x, self.scrollView.frame.size.height - 3, button.frame.size.width, 2);
                [self.scrollView addSubview:self.bottomView];
                
            }
            
            
        }
        
  
    }
    
  
    self.scrollView.contentSize = CGSizeMake(btnOffset + 18, 44);
    
}

// 修改当前选中按钮及底部线条 事件
- (void)changeSelectbuttonAction:(UIButton *)button{

    // 取消之前选中按钮的选中事件
    self.currentbutton.selected = NO;
    self.currentbutton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    // 更新选中当前按钮的选中结果
    self.currentbutton = button;
    self.currentbutton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    self.currentbutton.selected = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        // 1. 更新底部指示线条的位置
        // 2. 更新scrollview 的滚动位置
        
        if (button.tag == 0) {
            
            self.bottomView.frame = CGRectMake(self.currentbutton.frame.origin.x, self.scrollView.frame.size.height - 2, self.currentbutton.frame.size.width, 2);
            
            [self.scrollView scrollRectToVisible:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
            
        }else{
            
            
            UIButton *preButton = self.buttonArray[button.tag - 1];
            
            CGFloat offSetX = CGRectGetMaxX(preButton.frame) - 18;
            
            self.bottomView.frame = CGRectMake(self.currentbutton.frame.origin.x, self.scrollView.frame.size.height - 2, self.currentbutton.frame.size.width, 2);
            
            [self.scrollView scrollRectToVisible:CGRectMake(offSetX, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
            
        }
        
        
        if (self.whichButtonSelect) {
            
            self.titleindex = button.tag;
            self.whichButtonSelect(button.tag);
            
        }
    
    }];
    
    
}



- (UIScrollView *)scrollView{
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 46)];
        _scrollView.showsVerticalScrollIndicator = _scrollView.showsHorizontalScrollIndicator = NO;
        
        _scrollView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIView *)bottomView{
    
    if (!_bottomView) {
        
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f];
        
    }
    
    return _bottomView;
}


- (NSMutableArray *)buttonArray{
    
    if (!_buttonArray) {
        
        _buttonArray = [NSMutableArray array];
    }
 
    return _buttonArray;
}


@end
