//
//  ViewController.h
//  test
//
//  Created by 兴业 on 16/3/31.
//  Copyright © 2016年 ckfear. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshUI)(NSString *account);

@interface ViewController : UIViewController

@property (nonatomic, strong) UIView *testView;

@property (nonatomic, copy) NSString *testString;

@property (nonatomic, assign) NSInteger testInteger;

@end

