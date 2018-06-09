//
//  YFLCustomActionSheet.m
//  LemonActionSheet
//
//  Created by Cherish on 2016/12/9.
//  Copyright © 2016年 Cherish. All rights reserved.
//

#import "YFLCustomActionSheet.h"

/***  当前屏幕宽度    ***/
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
/***  当前屏幕高度    ***/
#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height
/***  RGB宏定义      ***/
#define kRGBColor(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
/***  判断是否为有效字符串 ***/
#define kValidStr(str) [self validString:str]
// 行间距
#define kLineHeight (1 / [UIScreen mainScreen].scale)
// self 本身的tag值
#define kSelfTag 100860

@interface YFLCustomActionSheet ()<UITableViewDelegate,UITableViewDataSource>

//黑色背景
@property (nonatomic,strong) UIView *backgroundView;
//取消文字
@property (nonatomic,copy)  NSString *cancleTitle;
//标题
@property (nonatomic,copy)  NSString *alertTitle;
//显示其他内容数组
@property (nonatomic,strong) NSMutableArray *subTitlesArray;
//表
@property (nonatomic,strong) UITableView*tableView;

@end

@implementation YFLCustomActionSheet

#pragma mark - Init Methods
- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
      
        [self setUp];
    }
    return self;
    
}//初始化方法


#pragma mark - Private methods
- (void)setUp
{
    
    _backgroundView = [[UIView alloc]initWithFrame:self.bounds];
    _backgroundView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7f];
    [self addSubview:_backgroundView];
    
}// 创建背景


- (NSString *)validString:(NSString *)string
{
    
    if ([self isBlankString:string]) {
        return  @"";
    } else {
        return string;
    }
}//有效字符串


- (BOOL)isBlankString:(NSString *)string
{
    
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    if ([string isKindOfClass:[NSString class]] == NO) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    if ([string isEqualToString:@""]) {
        return YES;
    }
    return NO;
}//判断是否为空字符串


- (CGFloat)tableViewTotalHeight
{
    
    return  50.0 * (self.subTitlesArray.count + 1) + 5.0f + ([kValidStr(self.alertTitle) length] != 0 ? 60 : 0);
    
}//表总高度


#pragma Action Methods
- (void)show
{
   
    // 判断当前窗口是否存在此视图，如果存在，那么调用次方法直接不响应
    if ([[UIApplication sharedApplication].keyWindow viewWithTag:kSelfTag]) {
        
        return;
    }
    
    //从下往上弹出动画
    self.backgroundView.alpha = 0.0;
    self.tableView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, [self tableViewTotalHeight]);
    
    UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:self];
    self.tag = kSelfTag;
    
    
    [UIView animateKeyframesWithDuration:0.2f delay:0 options:(UIViewKeyframeAnimationOptionCalculationModeLinear) animations:^{
        
        self.backgroundView.alpha = 1.0;
         self.tableView.transform = CGAffineTransformMakeTranslation(0, -[self tableViewTotalHeight]);
        
    } completion:^(BOOL finished) {
        
        
    }];
    
    
    
}//显示actionSheet


- (void)dismiss
{
    [UIView animateWithDuration:0.22f animations:^{
        self.backgroundView.alpha = 0.0;
        self.tableView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if(finished) {
            [self removeFromSuperview];
        }
    }];
    
}//移除actionsheet


- (void)dismissWithCell:(UITableViewCell*)cell
{
  
    // 拿到是否是第一组,如果是第一组的话，直接移除
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath.section == 1) {
        
        [self dismiss];
        
    }else{
        
        [UIView animateKeyframesWithDuration:0.22f delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            self.backgroundView.alpha = 0.0;
            self.tableView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
            if(finished) {
                if (_clickItem) {
                    _clickItem(indexPath.row);
                }
                //[self dismiss];
                [self removeFromSuperview];
            }
            
        }];
        
        
    }
    
    
}//点击单元格

#pragma mark - Public Methods
+ (id)actionSheetWithCancelTitle:(NSString *)cancelTitle alertTitle:(NSString *)alertTitle SubTitles:(NSString *)title,...NS_REQUIRES_NIL_TERMINATION
{
    
    YFLCustomActionSheet *actionSheet = [[YFLCustomActionSheet alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth , kScreenHeight)];
    
    actionSheet.cancleTitle = cancelTitle;
    actionSheet.alertTitle = alertTitle;
    
    // VALIST是C语言中解决变参问题的一组宏
    // 定义一具VA_LIST型的变量，这个变量是指向参数的指针
    va_list argumentList;
    
    id subTitle; /*(id -> NSString);*/
    
    if(title){
        
        [actionSheet.subTitlesArray addObject:title];
        
        // 用VA_START宏初始化刚定义的VA_LIST变量
        va_start(argumentList, title);
        
        //VA_ARG返回可变的参数，VA_ARG的第二个参数是你要返回的参数的类型,如果函数有多个可变参数的，依次调用VA_ARG获取各个参数
        while((subTitle = va_arg(argumentList, id))) {
            NSString *tit = [subTitle copy];
            [actionSheet.subTitlesArray addObject:tit];
        }
        // 用VA_END宏结束可变参数的获取
        va_end(argumentList);
        
    }
    
    return actionSheet;
    
}//初始化


- (void)returnCustomActionSheetClickItemWithBlock:(CustomActionSheetClickItem)block
{
    _clickItem = block;
    
}//点击actionsheetItem


#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}//组数


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        
        return self.subTitlesArray.count;
        
    }else{
        return 1;
    }
  
    
}//单元格个数


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"identifier"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    if (indexPath.section == 0) {
      
        NSString *subTitle = self.subTitlesArray[indexPath.row];
        
   
            
        cell.textLabel.textColor = kRGBColor(102, 102, 102);

        
        
        cell.textLabel.text = subTitle;
        
    }else{
        
        cell.textLabel.text = self.cancleTitle;
        cell.textLabel.textColor = kRGBColor(102, 102, 102);
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}//创建单元格


#pragma mark - UITableView Delegate
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
      
        //如果没有警告，返回为空
        if (kValidStr(self.alertTitle).length == 0 ) {
        
            return nil;
        }
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        view.backgroundColor = [UIColor whiteColor];
        
        
        //提醒
        UIColor *textColor = ([self.alertTitle rangeOfString:@"报名试吃团"].location != NSNotFound)  || ([self.alertTitle rangeOfString:@"是否拔草"].location != NSNotFound) ? [[UIColor blackColor] colorWithAlphaComponent:1] :   [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:kValidStr(self.alertTitle)];
        
 
        [string addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, self.alertTitle.length)];

        
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0f] range:NSMakeRange(0, self.alertTitle.length)];
        [string addAttribute:NSKernAttributeName value:@(0.2) range:NSMakeRange(0, self.alertTitle.length)];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paraStyle.alignment = NSTextAlignmentCenter;
        paraStyle.lineSpacing = 3.0f;
        [string addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, self.alertTitle.length)];
        
    
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, kScreenWidth - 20 * 2, 50)];
        label.attributedText = string;
        label.numberOfLines = 0;
        [view addSubview:label];
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 64 - kLineHeight, kScreenWidth, kLineHeight);
        [view.layer addSublayer:layer];
        layer.backgroundColor = kRGBColor(238, 238, 238).CGColor;
        
        
        return view;
        
    }else{
     
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
        view.backgroundColor = kRGBColor(238, 238, 238);
        return view;
        
    }
    
}//组头部视图


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        
        if ([kValidStr(self.alertTitle) length] == 0) {
            
            return 0.1f;
        }else{
            
            return 60.0f;
        }
    }else{
        
        return 5.0f;
    }
    
}//头部视图的高度


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}//单元格高度


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}//分割线0间距


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
    [self dismissWithCell:currentCell];
    
}//单击单元格


#pragma mark - OverRide Methods
- (NSMutableArray*)subTitlesArray
{
    
    if (_subTitlesArray == nil) {
        
        _subTitlesArray = [[NSMutableArray alloc]init];
        
    }
    return _subTitlesArray;
    
}//子标题数组


- (UITableView*)tableView
{
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc]init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView  = nil;
        _tableView.separatorColor = kRGBColor(238, 238, 238);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self addSubview:_tableView];
    }
   
    return _tableView;
}//创建表


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = touches.anyObject;
    
    if (![touch.view isEqual:self.tableView]) {
    
        //响应第一组cell取消事件，remove即可
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
        [self dismissWithCell:cell];
        
    }
    
}//触点


@end
