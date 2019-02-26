//
//  LsView.h
//  ScrollDemo
//
//  Created by 中国孔 on 2019/2/26.
//  Copyright © 2019 孔令辉. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^whichButtonSelect)(NSInteger index);

@interface LsView : UIView

@property (strong , nonatomic)NSArray *titleArray;//顶部显示的标题数组
@property (assign , nonatomic) NSInteger titleindex;

@property (strong , nonatomic) void (^whichButtonSelect)(NSInteger index);



@end

NS_ASSUME_NONNULL_END
