//
//  ZY_UtilityMethods.h
//  ZYCoffers
//
//  Created by 周洋 on 2018/9/20.
//  Copyright © 2018年 周洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ZY_UtilityMethods : NSObject
//按钮
+ (UIButton *)setBtnTitle:(NSString *)title titleColor:(UIColor *)titleColor backGroundImg:(UIImage *)backGroundImg titleFount:(int)titleFount;
//文本Label
+ (UILabel *)setLableText:(NSString *)title titleCorlor:(UIColor *)titleColor titleFount:(int)titleFount titleAlignment:(NSTextAlignment)titleAlignment;
//文本框
+ (UITextField *)setTextFieldStyle:(UITextBorderStyle)style placeholder:(NSString *)placeholder textFiledFount:(int)Fount titleColor:(UIColor *)titleColor clearText:(BOOL)clearsText keyboardType:(UIKeyboardType)KeyBoardType;

//十进制转化成十六进制
+(NSString *)ToHex:(long long int)tmpid;

//十六进制转换成十进制:
+ (NSInteger)ToNumber:(NSString *)hexstring;
/** MD5加密 */
#pragma mark - 32位 小写
+(NSString *)MD5ForLower32Bate:(NSString *)str;
#pragma mark - 32位 大写
+(NSString *)MD5ForUpper32Bate:(NSString *)str;
#pragma mark - 16位 大写
+ (NSString *)MD5ForUpper16Bate:(NSString *)str;
#pragma mark - 16位 小写
+(NSString *)MD5ForLower16Bate:(NSString *)str;


+ (NSString *)md5String:(NSString *)sourceString;//md5字符串加密
+ (NSString *)md5Data:(NSData *)sourceData;//md5data加密
+ (NSString *)base64EncodingWithData:(NSData *)sourceData;//base64加密
+ (id)base64EncodingWithString:(NSString *)sourceString;//base64解密
//SHA1 算法加密?
+ (NSString *)sha1:(NSString *)input;

//手机号码验证
+ (BOOL) isValidateMobile:(NSString *)mobileNum;

//压缩图片
+ (NSData *)zipNSDataWithImage:(UIImage *)sourceImage;

//图片上传南京
+ (NSMutableURLRequest *)uploadImage:(NSString*)url uploadImage:(UIImage *)uploadImage params:(NSMutableDictionary *)params;

// 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *)colorWithHexString:(NSString *)color;

//获取用户唯一标识 (这个不是唯一永恒不变的 在特殊情况下还是会变的 在这个项目中不是那么重要 但是不能做手机终端真正的唯一标识)
+ (NSString *)GetUUID;
- (void)deleteuuid;
//获取用户的IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4;
+ (NSDictionary *)getIPAddresses;
//URL转码
+ (NSString *)URLEncodedString:(NSString*)sourceString;
//URL解码
+(NSString *)URLDecodedString:(NSString *)str;

//0A0A0A0A  后台返回8位十六进制时间转换10进制时间格式显示 转换方法
+ (NSString *)GetWeiTime:(NSString *)Str Title:(NSString *)Title FuTitle:(NSString *)FuTitle;

//0A0A0A0A  后台返回8位十六进制z转换
+ (NSString *)GetEightNumber:(NSString *)Str ;
//FFFFFFFFFF 设备允许使用时间 设备主板激活时间
+ (NSString *)GetDeviceTenNumber:(NSString *)Str;
//节省电量
+ (NSString *)GetDianLiang:(NSString *)Str Title:(NSString *)Title;

//TextField代理 过滤特殊字符
- (void)SetDelegateTextField:(UITextField *)TextField;

//获取无线网络名称
+ (NSString *)GetSSIDWifiName;

//判断字符串是否为空
+ (BOOL)isStringNil:(NSString *)string;
//字符串参数若为空返回 @""
+ (NSString *)isNil:(NSString *)string;

//直饮机滤芯返回4位十六进制值处理
+ (NSString *)GetFilterElementNumber:(NSString *)Str;

//谁机生成数字+字符串
+ (NSString *)getRandomStringWithNum:(NSInteger)num;
//谁机生成字母
+ (NSString *)ret32bitString:(NSUInteger)num;
//获取登录时候后台传给的cookies
- (void)GetLoginCoolies:(NSString *)UrlStr;
//传入App的和后台的版本号对比 是否为最新版本
//YES 即为最新版本 NO 不是
+ (BOOL)GetIsNewVersion:(NSString *)AppStr serverStr:(NSString *)serverStr;
//当用户在其他地方登录或者用户长时间未登录离线处理
//- (void)ShowUserIsOffline:(NSString *)Message BackCode:(NSString *)Code;

/** 检测字符串里是否包含空格及特殊字符及空格 */
+ (BOOL)checkStringIsContainsSpecialCharacters:(NSString *)String UserInputTextFiledTitle:(NSString *)TitleStr;
/** 检测手机号码 */
+ (BOOL)checkStringIsPhone:(NSString *)String;
/** 时间戳转换 */
- (NSString *)TimeStamp:(NSString *)strTime;
@end
