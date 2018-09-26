//
//  ZY_ProgressPack.m
//  ZYToolmaker
//
//  Created by 周洋 on 2018/9/26.
//  Copyright © 2018年 周洋. All rights reserved.
//

#import "ZY_ProgressPack.h"

@implementation ZY_ProgressPack
//成功
- (void)setSucceedViewShowTime:(CGFloat)ShowTime ShowTitle:(NSString *)showTitle {
    
    [SVProgressHUD setMinimumDismissTimeInterval:ShowTime];
    [SVProgressHUD showSuccessWithStatus:showTitle];
}

//失败
- (void)setErrorViewShowTime:(CGFloat)ShowTime ShowTitle:(NSString *)showTitle {
    
    [SVProgressHUD setMinimumDismissTimeInterval:ShowTime];
    [SVProgressHUD showErrorWithStatus:showTitle];
}

//警告
- (void)setWarningViewShowTitle:(NSString *)showTitle {
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    [SVProgressHUD showInfoWithStatus:showTitle];
}

//转圈圈
- (void)GetProgressShowTitle:(NSString *)Title {
    [SVProgressHUD showWithStatus:Title];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

//转圈圈 限定时间
- (void)GetProgressShowTime:(CGFloat)ShowTime Title:(NSString *)Title {
    [SVProgressHUD showWithStatus:Title];
    [SVProgressHUD dismissWithDelay:ShowTime];
}

//结束
- (void)GetDismissProgress {
    [SVProgressHUD dismiss];
}
@end
