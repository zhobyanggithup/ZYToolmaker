//
//  BaseMacroHeader.h
//  智能家居
//
//  Created by 周洋 on 2017/6/9.
//  Copyright © 2017年 HongChuangElectron. All rights reserved.
//

#ifndef BaseMacroHeader_h
#define BaseMacroHeader_h

//屏幕尺寸的判断
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCALE_WIDTH ([UIScreen mainScreen].bounds.size.width/375.0)
#define SCALE_HEIGHT ([UIScreen mainScreen].bounds.size.height/667.0)

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
//#define IS_IPHONE_4  (IS_IPHONE && SCREEN_MAX_LENGTH == )
#define IS_IPHONE_5  (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6  (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


#define IS_IOS_7 (NSFoundationVersionNumber>=NSFoundationVersionNumber_iOS_7_0? YES : NO)
#define kColor_RGB(x, y, z) [UIColor colorWithRed:(x)/255.0 green:(y)/255.0 blue:(z)/255.0 alpha:1]
#define LightGreyColor kColor_RGB(224, 224, 224)
#define LDWeakSelf(type)  __weak typeof(type) weak##type = type;

//通知中心
#define NSNotic_Center [NSNotificationCenter defaultCenter]
#define WeakObj(o) __weak typeof(o) o##Weak = o;

//NavBar高度
#define NavigationBar_HEIGHT 44
#define TopBar_HEIGHT 64
#define TabBar_HEIGHT 59
//配置导航栏和tabbar统一颜色
#define NavgationBackGroundColor kColor_RGB(82, 161, 255)
#define TabbarBackGroundColor [UIColor whiteColor]
//每页加载
#define PageNumbers 1
#define LoadingNumbers 10
/** TextField限定输入字数 */
#define TextNumber 30
#define TEXTPHONENUM 11
#define TEXTNUMBER 8
//设备功逻辑处理缓存
#define userDefault [NSUserDefaults standardUserDefaults]
#ifdef DEBUG
#define LDLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define LDLog(...)
#endif
/** 服务器响应显示提示框的时长 */
#define ResponseTime (1.0)
/** 上拉 下拉 刷新响应提示框时长 */
#define RefreshControlsTime (1.0)
#define ShangLaTime (0.5)
/** 网络请求超时时间 */
#define HTTPRequestTimeOut (30.f)
#endif /* BaseMacroHeader_h */
