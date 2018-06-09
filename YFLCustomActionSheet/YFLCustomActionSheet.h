//
//  YFLCustomActionSheet.h
//  LemonActionSheet
//
//  Created by Cherish on 2016/12/9.
//  Copyright © 2016年 Cherish. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CustomActionSheetClickItem)(NSInteger curentIndex);

@interface YFLCustomActionSheet : UIView


/**
 *  初始化
 *
 *  @param cancelTitle 取消
 *  @param alertTitle  提示文字
 *  @param title       子控件文本
 */

+ (id)actionSheetWithCancelTitle:(NSString *)cancelTitle alertTitle:(NSString *)alertTitle SubTitles:(NSString *)title,...NS_REQUIRES_NIL_TERMINATION;


//显示
- (void)show;


//点击actionsheet
@property (nonatomic,copy) CustomActionSheetClickItem clickItem;
- (void)returnCustomActionSheetClickItemWithBlock:(CustomActionSheetClickItem)block;





@end
