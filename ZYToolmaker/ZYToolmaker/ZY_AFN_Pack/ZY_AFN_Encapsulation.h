//
//  ZY_AFN_Encapsulation.h
//  封印一切
//
//  Created by 周洋 on 2018/4/4.
//  Copyright © 2018年 周洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZY_AFN_Encapsulation : NSObject

#pragma mark ----- GET请求
/**
 Get请求调用方法(可设置超时时间,请求进度,转圈圈等待文字,成功失败提示框文字)

 @param param 请求参数
 @param URLStr 请求URL
 @param WaitingProgressStr 发送数据请求等待时候转圈圈的文字
 @param SuccessProgressStr 获取数据成功的文字提示框
 @param ErrorProgressStr 获取数据失败的文字提示框
 @param HeaderParamStr 请求体
 @param HeaderStr 请求头
 @param OutTime 请求超时 时间
 @param progress 请求进度--下载的进度条等 一般用不到
 @param success 请求成功的回调
 @param fail 请求失败的回调
 */
+ (void)AFNHTTP_GETWithParam:(NSDictionary *)param URLStr:(NSString *)URLStr WaitingProgressStr:(NSString *)WaitingProgressStr SuccessProgressStr:(NSString *)SuccessProgressStr ErrorProgressStr:(NSString *)ErrorProgressStr HeaderParamStr:(id)HeaderParamStr HeaderStr:(NSString *)HeaderStr OutTime:(NSTimeInterval)OutTime Progress:(void(^)(NSProgress *uploadProgress))progress success:(void(^)(NSURLSessionTask *task , NSDictionary *responseDic))success fail:(void(^)(NSURLSessionTask *task , NSError *error))fail;


#pragma mark ----- POST请求
/**
 POST请求调用方法(可设置超时时间,请求进度,转圈圈等待文字,成功失败提示框文字)
 
 @param param 请求参数
 @param URLStr 请求URL
 @param WaitingProgressStr 发送数据请求等待时候转圈圈的文字
 @param SuccessProgressStr 获取数据成功的文字提示框
 @param ErrorProgressStr 获取数据失败的文字提示框
 @param HeaderParamStr 请求体
 @param HeaderStr 请求头
 @param OutTime 请求超时 时间
 @param progress 请求进度--下载的进度条等 一般用不到
 @param success 请求成功的回调
 @param fail 请求失败的回调
 */
+ (void)AFNHTTP_POSTWithParam:(NSDictionary *)param URLStr:(NSString *)URLStr WaitingProgressStr:(NSString *)WaitingProgressStr SuccessProgressStr:(NSString *)SuccessProgressStr ErrorProgressStr:(NSString *)ErrorProgressStr HeaderParamStr:(id)HeaderParamStr HeaderStr:(NSString *)HeaderStr OutTime:(NSTimeInterval)OutTime Progress:(void(^)(NSProgress *uploadProgress))progress success:(void(^)(NSURLSessionTask *task , NSDictionary *responseDic))success fail:(void(^)(NSURLSessionTask *task , NSError *error))fail;


#pragma mark ------ 发送请求主体为字符串  无接受参数类型
/**
 发送请求主体为字符串  无接受参数类型(可设置超时时间,请求类型,转圈圈等待文字,成功失败提示框文字)

 @param RequestType 请求类型 POST or GET
 @param URLStr 请求地址URL
 @param BodyStr 请求主体(字符串?)
 @param WaitingProgressStr 发送数据请求等待时候转圈圈的文字
 @param SuccessProgressStr 获取数据成功的文字提示框
 @param ErrorProgressStr 获取数据失败的文字提示框
 @param OutTime 请求超时 时间
 @param CorrespondingResults 收到服务器相应 成功 or 失败 or 数据
 */
+ (void)NSURLSession_RequestType:(NSString *)RequestType URLStr:(NSString *)URLStr BodyStr:(NSString *)BodyStr WaitingProgressStr:(NSString *)WaitingProgressStr SuccessProgressStr:(NSString *)SuccessProgressStr ErrorProgressStr:(NSString *)ErrorProgressStr OutTime:(NSTimeInterval)OutTime CorrespondingResults:(void(^)(NSString *Data , NSURLResponse *Response , NSError *Error))CorrespondingResults;

#pragma mark ------ POST图片上传 改
/**
 ********************      POST向服务器上传图片       ********************

 @param strUrl 请求的网址
 @param params 发送请求的参数的字典
 @param WaitingProgressStr 发送数据请求等待时候转圈圈的文字
 @param SuccessProgressStr 获取数据成功的文字提示框
 @param ErrorProgressStr 获取数据失败的文字提示框
 @param OutTime 请求超时 时间
 @param imageArray 需要上传图片的数组
 @param fileArray 接收上传文件的key的数组
 @param imageNameArray 上传图片取什么名字的数组（自己取的）
 @param CorrespondingResults 收到服务器相应 成功 or 失败 or 数据
 */
+ (void)PostImagesToServer:(NSString *) strUrl dicPostParams:(NSMutableDictionary *)params WaitingProgressStr:(NSString *)WaitingProgressStr SuccessProgressStr:(NSString *)SuccessProgressStr ErrorProgressStr:(NSString *)ErrorProgressStr OutTime:(NSTimeInterval)OutTime imageArray:(NSArray *) imageArray file:(NSArray *)fileArray imageName:(NSArray *)imageNameArray CorrespondingResults:(void(^)(NSDictionary *Data , NSURLResponse *Response , NSError *Error))CorrespondingResults;


#pragma mark ----- GET请求简写化
/**
 Get请求调用方法(可设置超时时间,请求进度,转圈圈等待文字,成功失败提示框文字)
 @param param 请求参数
 @param URLStr 请求URL
 @param WaitingProgressStr 发送数据请求等待时候转圈圈的文字
 @param success 请求成功的回调
 @param fail 请求失败的回调
 */
+ (void)AFNHTTP_GETJianXieParam:(NSDictionary *)param URLStr:(NSString *)URLStr WaitingProgressStr:(NSString *)WaitingProgressStr  success:(void(^)(NSURLSessionTask *task , NSDictionary *responseDic))success fail:(void(^)(NSURLSessionTask *task , NSError *error))fail;


#pragma mark ----- POST请求简写化
/**
 POST请求调用方法(可设置超时时间,请求进度,转圈圈等待文字,成功失败提示框文字)
 @param param 请求参数
 @param URLStr 请求URL
 @param WaitingProgressStr 发送数据请求等待时候转圈圈的文字
 @param success 请求成功的回调
 @param fail 请求失败的回调
 */
+ (void)AFNHTTP_POSTJianXieParam:(NSDictionary *)param URLStr:(NSString *)URLStr WaitingProgressStr:(NSString *)WaitingProgressStr  success:(void(^)(NSURLSessionTask *task , NSDictionary *responseDic))success fail:(void(^)(NSURLSessionTask *task , NSError *error))fail;

#pragma mark ------ POST简写图片上传 改
/**
 ********************      POST向服务器上传图片       ********************
 
 @param strUrl 请求的网址
 @param params 发送请求的参数的字典
 @param WaitingProgressStr 发送数据请求等待时候转圈圈的文字
 @param OutTime 请求超时 时间
 @param imageArray 需要上传图片的数组
 @param fileArray 接收上传文件的key的数组
 @param imageNameArray 上传图片取什么名字的数组（自己取的）
 @param CorrespondingResults 收到服务器相应 成功 or 失败 or 数据
 */
+ (void)PostImagesToServer:(NSString *) strUrl dicPostParams:(NSMutableDictionary *)params WaitingProgressStr:(NSString *)WaitingProgressStr  OutTime:(NSTimeInterval)OutTime imageArray:(NSArray *) imageArray file:(NSArray *)fileArray imageName:(NSArray *)imageNameArray CorrespondingResults:(void(^)(NSDictionary *Data , NSURLResponse *Response , NSError *Error))CorrespondingResults;

#pragma mark ----- GET请求简写化
/**
 Get请求调用方法(可设置超时时间,请求进度,转圈圈等待文字,成功失败提示框文字)
 @param param 请求参数
 @param URLStr 请求URL
 @param WaitingProgressStr 发送数据请求等待时候转圈圈的文字
 @param success 请求成功的回调
 @param fail 请求失败的回调
 */
+ (void)AFNHTTP_GETHttpJianXieParam:(NSDictionary *)param URLStr:(NSString *)URLStr WaitingProgressStr:(NSString *)WaitingProgressStr  success:(void(^)(NSURLSessionTask *task , NSDictionary *responseDic))success fail:(void(^)(NSURLSessionTask *task , NSError *error))fail;


#pragma mark ----- POST请求简写化
/**
 POST请求调用方法(可设置超时时间,请求进度,转圈圈等待文字,成功失败提示框文字)
 @param param 请求参数
 @param URLStr 请求URL
 @param WaitingProgressStr 发送数据请求等待时候转圈圈的文字
 @param success 请求成功的回调
 @param fail 请求失败的回调
 */
+ (void)AFNHTTP_POSTHttpJianXieParam:(NSDictionary *)param URLStr:(NSString *)URLStr WaitingProgressStr:(NSString *)WaitingProgressStr  success:(void(^)(NSURLSessionTask *task , NSDictionary *responseDic))success fail:(void(^)(NSURLSessionTask *task , NSError *error))fail;

@end
