//
//  ZY_ProgressPack.h
//  ZYToolmaker
//
//  Created by 周洋 on 2018/9/26.
//  Copyright © 2018年 周洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ZY_ProgressPack : NSObject

/**
 [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
 SVProgressHUDMaskTypeNone = 1,  // 默认 没有遮罩
 SVProgressHUDMaskTypeClear,   //透明
 SVProgressHUDMaskTypeBlack,     //黑色
 SVProgressHUDMaskTypeGradient,  //光斑效果/聚光
 SVProgressHUDMaskTypeCustom   //自定义类型
 */

/**
 图形样式
 [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
 SVProgressHUDAnimationTypeFlat,  //圆圈
 SVProgressHUDAnimationTypeNative //菊花
 */

//常用showProgress
- (void)setSucceedViewShowTime:(CGFloat)ShowTime ShowTitle:(NSString *)showTitle;
- (void)setErrorViewShowTime:(CGFloat)ShowTime ShowTitle:(NSString *)showTitle;
- (void)setWarningViewShowTitle:(NSString *)showTitle;

/** 开启关闭菊花圈圈 */
- (void)GetProgressShowTitle:(NSString *)Title;
//转圈圈 几秒后结束
- (void)GetProgressShowTime:(CGFloat)ShowTime Title:(NSString *)Title;
//结束视图
- (void)GetDismissProgress;
@end
