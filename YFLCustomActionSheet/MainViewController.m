//
//  MainViewController.m
//  YFLCustomActionSheet
//
//  Created by Cherish on 2018/6/9.
//  Copyright © 2018年 Cherish. All rights reserved.
//

#import "MainViewController.h"

#import "YFLCustomActionSheet.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"自定义ActionShheet";
    
    // Do any additional setup after loading the view.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    YFLCustomActionSheet *actionSheet = [YFLCustomActionSheet actionSheetWithCancelTitle:@"取消" alertTitle:@"确定退出登录?" SubTitles:@"确定", nil];
    
    [actionSheet returnCustomActionSheetClickItemWithBlock:^(NSInteger curentIndex) {
       
        NSLog(@"'%ld",(long)curentIndex);
        
    }];
    
    [actionSheet show];
    
    
    
}




@end
