//
//  ZY_AFN_Encapsulation.m
//  封印一切
//
//  Created by 周洋 on 2018/4/4.
//  Copyright © 2018年 周洋. All rights reserved.
//

#import "ZY_AFN_Encapsulation.h"
@implementation ZY_AFN_Encapsulation

/**
 *  是否开启https SSL 验证
 *
 *  @return YES为开启，NO为关闭
 */
#define openHttpsSSL NO
/**
 *  SSL 证书名称，仅支持cer格式。“app.bishe.com.cer”,则填“app.bishe.com”
 */
#define certificate @"adn"
/** 默认超时时间 */
#define kTimeOutInterval 15.f
+ (AFHTTPSessionManager *)TFSharedManager {
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        // 超时时间
        manager.requestSerializer.timeoutInterval = kTimeOutInterval;
        // 声明上传的是json格式的参数，需要你和后台约定好，不然会出现后台无法获取到你上传的参数问题
//        manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
        // 声明获取到的数据格式
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
        manager.responseSerializer = [AFJSONResponseSerializer serializer]; // AFN会JSON解析返回的数据
        // 个人建议还是自己解析的比较好，有时接口返回的数据不合格会报3840错误，大致是AFN无法解析返回来的数据
        // 加上这行代码，https ssl 验证。
        if(openHttpsSSL){
            [manager setSecurityPolicy:[self TFCustomSecurityPolicy]];
        }
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain", nil];
        // 设置超时时间
        manager.requestSerializer.timeoutInterval = 30.f;
    });
    return manager;
}
+ (AFHTTPSessionManager *)TFSharedManagerJianXie {
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        // 超时时间
        manager.requestSerializer.timeoutInterval = kTimeOutInterval;
        // 声明上传的是json格式的参数，需要你和后台约定好，不然会出现后台无法获取到你上传的参数问题
        //        manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
        // 声明获取到的数据格式
        //        manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
        manager.responseSerializer = [AFJSONResponseSerializer serializer]; // AFN会JSON解析返回的数据
        // 个人建议还是自己解析的比较好，有时接口返回的数据不合格会报3840错误，大致是AFN无法解析返回来的数据
        // 加上这行代码，https ssl 验证。
        if(openHttpsSSL){
            [manager setSecurityPolicy:[self TFCustomSecurityPolicy]];
        }
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain", nil];
        // 设置超时时间
        manager.requestSerializer.timeoutInterval = 15.f;
    });
    return manager;
}

//普通方式传输不用json
+ (AFHTTPSessionManager *)TFSharedManagerShaBiHouTai {
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        // 超时时间
        manager.requestSerializer.timeoutInterval = kTimeOutInterval;
        // 声明上传的是json格式的参数，需要你和后台约定好，不然会出现后台无法获取到你上传的参数问题
        manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
//        manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
        // 声明获取到的数据格式
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
        manager.responseSerializer = [AFJSONResponseSerializer serializer]; // AFN会JSON解析返回的数据
        // 个人建议还是自己解析的比较好，有时接口返回的数据不合格会报3840错误，大致是AFN无法解析返回来的数据
        // 加上这行代码，https ssl 验证。
        if(openHttpsSSL){
            [manager setSecurityPolicy:[self TFCustomSecurityPolicy]];
        }
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
        // 设置超时时间
        manager.requestSerializer.timeoutInterval = 15.f;
    });
    return manager;
}
+ (NSURLSession *)ZY_URLSession {
    static NSURLSession *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [NSURLSession sharedSession];
    });
    return manager;
}
+ (AFSecurityPolicy*)TFCustomSecurityPolicy{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:certificate ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    securityPolicy.pinnedCertificates = @[certData];
    return securityPolicy;
}

+ (void)AFNHTTP_GETWithParam:(NSDictionary *)param URLStr:(NSString *)URLStr WaitingProgressStr:(NSString *)WaitingProgressStr SuccessProgressStr:(NSString *)SuccessProgressStr ErrorProgressStr:(NSString *)ErrorProgressStr HeaderParamStr:(id)HeaderParamStr HeaderStr:(NSString *)HeaderStr OutTime:(NSTimeInterval)OutTime Progress:(void(^)(NSProgress *uploadProgress))progress success:(void(^)(NSURLSessionTask *task , NSDictionary *responseDic))success fail:(void(^)(NSURLSessionTask *task , NSError *error))fail {
    ZY_ProgressPack *ProgressPack = [[ZY_ProgressPack alloc]init];
    if (WaitingProgressStr.length != 0) {
        [ProgressPack GetProgressShowTitle:WaitingProgressStr];
    }
    AFHTTPSessionManager *manager = [self TFSharedManager];
    manager.requestSerializer.timeoutInterval = OutTime;//超时时间
    //如果传进来的Header有值就走这一步
    if (HeaderStr.length != 0) {
        [manager.requestSerializer setValue:HeaderParamStr forHTTPHeaderField:HeaderStr];//请求头请求体
    }
    [manager GET:URLStr parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (SuccessProgressStr.length != 0) {
            [ProgressPack setSucceedViewShowTime:ResponseTime ShowTitle:SuccessProgressStr];
        }
        success(task ,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (ErrorProgressStr.length != 0) {
            [ProgressPack setErrorViewShowTime:ResponseTime ShowTitle:ErrorProgressStr];
        }
        fail(task,error);
    }];
}

+ (void)AFNHTTP_POSTWithParam:(NSDictionary *)param URLStr:(NSString *)URLStr WaitingProgressStr:(NSString *)WaitingProgressStr SuccessProgressStr:(NSString *)SuccessProgressStr ErrorProgressStr:(NSString *)ErrorProgressStr HeaderParamStr:(id)HeaderParamStr HeaderStr:(NSString *)HeaderStr OutTime:(NSTimeInterval)OutTime Progress:(void(^)(NSProgress *uploadProgress))progress success:(void(^)(NSURLSessionTask *task , NSDictionary *responseDic))success fail:(void(^)(NSURLSessionTask *task , NSError *error))fail {
    ZY_ProgressPack *ProgressPack = [[ZY_ProgressPack alloc]init];
    if (WaitingProgressStr.length != 0) {
        [ProgressPack GetProgressShowTitle:WaitingProgressStr];
    }
    AFHTTPSessionManager *manager = [self TFSharedManager];
    manager.requestSerializer.timeoutInterval = OutTime;//超时时间
    //如果传进来的Header有值就走这一步
    if (HeaderStr.length != 0) {
        [manager.requestSerializer setValue:HeaderParamStr forHTTPHeaderField:HeaderStr];//请求头请求体
    }
    [manager POST:URLStr parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (SuccessProgressStr.length != 0) {
            [ProgressPack setSucceedViewShowTime:ResponseTime ShowTitle:SuccessProgressStr];
        }
        success(task ,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (ErrorProgressStr.length != 0) {
            [ProgressPack setErrorViewShowTime:ResponseTime ShowTitle:ErrorProgressStr];
        }
        fail(task,error);
    }];
}

+ (void)NSURLSession_RequestType:(NSString *)RequestType URLStr:(NSString *)URLStr BodyStr:(NSString *)BodyStr WaitingProgressStr:(NSString *)WaitingProgressStr SuccessProgressStr:(NSString *)SuccessProgressStr ErrorProgressStr:(NSString *)ErrorProgressStr OutTime:(NSTimeInterval)OutTime CorrespondingResults:(void(^)(NSString *Data , NSURLResponse *Response , NSError *Error))CorrespondingResults {
    ZY_ProgressPack *ProgressPack = [[ZY_ProgressPack alloc]init];
    if (WaitingProgressStr.length != 0) {
        [ProgressPack GetProgressShowTitle:WaitingProgressStr];
    }
    NSURLSession *session = [self ZY_URLSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLStr]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:OutTime];
    request.HTTPMethod = RequestType;
    request.HTTPBody=[BodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
        NSString *resultStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (resultStr.length != 0) {
            [[ZY_ProgressPack new]setSucceedViewShowTime:ResponseTime ShowTitle:SuccessProgressStr];
        }
        if (error != 0) {
            [[ZY_ProgressPack new]setSucceedViewShowTime:ResponseTime ShowTitle:ErrorProgressStr];
        }
    CorrespondingResults(resultStr , response , error);
        
    }];
    [task resume];
}

+ (void)PostImagesToServer:(NSString *) strUrl dicPostParams:(NSMutableDictionary *)params WaitingProgressStr:(NSString *)WaitingProgressStr SuccessProgressStr:(NSString *)SuccessProgressStr ErrorProgressStr:(NSString *)ErrorProgressStr OutTime:(NSTimeInterval)OutTime imageArray:(NSArray *) imageArray file:(NSArray *)fileArray imageName:(NSArray *)imageNameArray CorrespondingResults:(void(^)(NSDictionary *Data , NSURLResponse *Response , NSError *Error))CorrespondingResults {
    ZY_ProgressPack *ProgressPack = [[ZY_ProgressPack alloc]init];
    if (WaitingProgressStr.length != 0) {
        [ProgressPack GetProgressShowTitle:WaitingProgressStr];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //分界线的标识符
        NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
        NSURL *url = [NSURL URLWithString:strUrl];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        //超时时间
        request.timeoutInterval = OutTime;
        //分界线 --AaB03x
        NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
        //结束符 AaB03x--
        NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
        //要上传的图片
        UIImage *image;
        
        //将要上传的图片压缩 并赋值与上传的Data数组
        NSMutableArray *imageDataArray = [NSMutableArray array];
        for (int i = 0; i<imageArray.count; i++) {
            //要上传的图片
            image= imageArray[i];
            /**************  将图片压缩成我们需要的数据包大小 *******************/
            NSData * data = UIImageJPEGRepresentation(image, 1.0);
            CGFloat dataKBytes = data.length/1000.0;
            CGFloat maxQuality = 0.9f;
            CGFloat lastData = dataKBytes;
            while (dataKBytes > 1024 && maxQuality > 0.01f) {
                //将图片压缩成1M
                maxQuality = maxQuality - 0.01f;
                data = UIImageJPEGRepresentation(image, maxQuality);
                dataKBytes = data.length / 1000.0;
                if (lastData == dataKBytes) {
                    break;
                }else{
                    lastData = dataKBytes;
                }
            }
            /**************  将图片压缩成我们需要的数据包大小 *******************/
            [imageDataArray addObject:data];
        }
        
        //http body的字符串
        NSMutableString *body=[[NSMutableString alloc]init];
        //参数的集合的所有key的集合
        NSArray *keys= [params allKeys];
        
        //遍历keys
        for(int i=0;i<[keys count];i++) {
            //得到当前key
            NSString *key=[keys objectAtIndex:i];
            
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            
            //添加字段的值
            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
            
        }
        
        //声明myRequestData，用来放入http body
        NSMutableData *myRequestData=[NSMutableData data];
        //将body字符串转化为UTF8格式的二进制
        [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        
        //循环加入上传图片
        for(int i = 0; i< [imageDataArray count] ; i++){
            //要上传的图片
            //得到图片的data
            NSData* data =  imageDataArray[i];
            NSMutableString *imgbody = [[NSMutableString alloc] init];
            //此处循环添加图片文件
            //添加图片信息字段
            ////添加分界线，换行
            [imgbody appendFormat:@"%@\r\n",MPboundary];
            [imgbody appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n", fileArray[i],imageNameArray[i]];
            //声明上传文件的格式
            [imgbody appendFormat:@"Content-Type: application/octet-stream; charset=utf-8\r\n\r\n"];
            
            //将body字符串转化为UTF8格式的二进制
            [myRequestData appendData:[imgbody dataUsingEncoding:NSUTF8StringEncoding]];
            //将image的data加入
            [myRequestData appendData:data];
            [myRequestData appendData:[ @"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        //声明结束符：--AaB03x--
        NSString *end=[[NSString alloc]initWithFormat:@"%@\r\n",endMPboundary];
        //加入结束符--AaB03x--
        [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        
        //设置HTTPHeader中Content-Type的值
        NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
        //设置HTTPHeader
        [request setValue:content forHTTPHeaderField:@"Content-Type"];
        //设置Content-Length
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
        //设置http body
        [request setHTTPBody:myRequestData];
        //http method
        [request setHTTPMethod:@"POST"];
        
        // 3.获得会话对象
        NSURLSession *session = [NSURLSession sharedSession];
        // 4.根据会话对象，创建一个Task任务
        NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSString *resultStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (resultStr.length != 0) {
                [[ZY_ProgressPack new]setSucceedViewShowTime:ResponseTime ShowTitle:SuccessProgressStr];
            }
            if (error != 0) {
                [[ZY_ProgressPack new]setSucceedViewShowTime:ResponseTime ShowTitle:ErrorProgressStr];
            }
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            CorrespondingResults(dict , response , error);
        }];
        //5.最后一步，执行任务，(resume也是继续执行)。
        [sessionDataTask resume];
    });
}



#pragma mark ----- GET请求简写化
/**
 Get请求调用方法(可设置超时时间,请求进度,转圈圈等待文字,成功失败提示框文字)
 @param param 请求参数
 @param URLStr 请求URL
 @param WaitingProgressStr 发送数据请求等待时候转圈圈的文字
 @param success 请求成功的回调
 @param fail 请求失败的回调
 */
+ (void)AFNHTTP_GETJianXieParam:(NSDictionary *)param URLStr:(NSString *)URLStr WaitingProgressStr:(NSString *)WaitingProgressStr  success:(void(^)(NSURLSessionTask *task , NSDictionary *responseDic))success fail:(void(^)(NSURLSessionTask *task , NSError *error))fail {
    ZY_ProgressPack *ProgressPack = [[ZY_ProgressPack alloc]init];
    if (WaitingProgressStr.length != 0) {
        [ProgressPack GetProgressShowTitle:WaitingProgressStr];
    }
    AFHTTPSessionManager *manager = [self TFSharedManagerJianXie];
    manager.requestSerializer.timeoutInterval = kTimeOutInterval;//超时时间
    //请求头请求体 下面可以根据而修改 这里我是方便自己使用了
    NSString *Names = [[NSUserDefaults standardUserDefaults]objectForKey:@"LoginCookieName"];
    NSString *Values = [[NSUserDefaults standardUserDefaults]objectForKey:@"LoginCookieValue"];
    NSString * str = [NSString stringWithFormat:@"%@=%@",Names,Values];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Cookie"];

    [manager GET:URLStr parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task ,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];
}


#pragma mark ----- POST请求简写化
/**
 POST请求调用方法(可设置超时时间,请求进度,转圈圈等待文字,成功失败提示框文字)
 @param param 请求参数
 @param URLStr 请求URL
 @param WaitingProgressStr 发送数据请求等待时候转圈圈的文字
 @param success 请求成功的回调
 @param fail 请求失败的回调
 */
+ (void)AFNHTTP_POSTJianXieParam:(NSDictionary *)param URLStr:(NSString *)URLStr WaitingProgressStr:(NSString *)WaitingProgressStr  success:(void(^)(NSURLSessionTask *task , NSDictionary *responseDic))success fail:(void(^)(NSURLSessionTask *task , NSError *error))fail {
    ZY_ProgressPack *ProgressPack = [[ZY_ProgressPack alloc]init];
    if (WaitingProgressStr.length != 0) {
        [ProgressPack GetProgressShowTitle:WaitingProgressStr];
    }
    AFHTTPSessionManager *manager = [self TFSharedManagerJianXie];
    manager.requestSerializer.timeoutInterval = kTimeOutInterval;//超时时间
    //请求头请求体 下面可以根据而修改 这里我是方便自己使用了
    NSString *Names = [[NSUserDefaults standardUserDefaults]objectForKey:@"LoginCookieName"];
    NSString *Values = [[NSUserDefaults standardUserDefaults]objectForKey:@"LoginCookieValue"];
    NSString * str = [NSString stringWithFormat:@"%@=%@",Names,Values];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Cookie"];
    [manager POST:URLStr parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task ,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];
}


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
+ (void)PostImagesToServer:(NSString *) strUrl dicPostParams:(NSMutableDictionary *)params WaitingProgressStr:(NSString *)WaitingProgressStr  OutTime:(NSTimeInterval)OutTime imageArray:(NSArray *) imageArray file:(NSArray *)fileArray imageName:(NSArray *)imageNameArray CorrespondingResults:(void(^)(NSDictionary *Data , NSURLResponse *Response , NSError *Error))CorrespondingResults {
    ZY_ProgressPack *ProgressPack = [[ZY_ProgressPack alloc]init];
    if (WaitingProgressStr.length != 0) {
        [ProgressPack GetProgressShowTitle:WaitingProgressStr];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //分界线的标识符
        NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
        NSURL *url = [NSURL URLWithString:strUrl];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        //超时时间
        request.timeoutInterval = OutTime;
        //分界线 --AaB03x
        NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
        //结束符 AaB03x--
        NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
        //要上传的图片
        UIImage *image;
        
        //将要上传的图片压缩 并赋值与上传的Data数组
        NSMutableArray *imageDataArray = [NSMutableArray array];
        for (int i = 0; i<imageArray.count; i++) {
            //要上传的图片
            image= imageArray[i];
            /**************  将图片压缩成我们需要的数据包大小 *******************/
            NSData * data = UIImageJPEGRepresentation(image, 1.0);
            CGFloat dataKBytes = data.length/1000.0;
            CGFloat maxQuality = 0.9f;
            CGFloat lastData = dataKBytes;
            while (dataKBytes > 1024 && maxQuality > 0.01f) {
                //将图片压缩成1M
                maxQuality = maxQuality - 0.01f;
                data = UIImageJPEGRepresentation(image, maxQuality);
                dataKBytes = data.length / 1000.0;
                if (lastData == dataKBytes) {
                    break;
                }else{
                    lastData = dataKBytes;
                }
            }
            /**************  将图片压缩成我们需要的数据包大小 *******************/
            [imageDataArray addObject:data];
        }
        
        //http body的字符串
        NSMutableString *body=[[NSMutableString alloc]init];
        //参数的集合的所有key的集合
        NSArray *keys= [params allKeys];
        
        //遍历keys
        for(int i=0;i<[keys count];i++) {
            //得到当前key
            NSString *key=[keys objectAtIndex:i];
            
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            
            //添加字段的值
            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
            
        }
        
        //声明myRequestData，用来放入http body
        NSMutableData *myRequestData=[NSMutableData data];
        //将body字符串转化为UTF8格式的二进制
        [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        
        //循环加入上传图片
        for(int i = 0; i< [imageDataArray count] ; i++){
            //要上传的图片
            //得到图片的data
            NSData* data =  imageDataArray[i];
            NSMutableString *imgbody = [[NSMutableString alloc] init];
            //此处循环添加图片文件
            //添加图片信息字段
            ////添加分界线，换行
            [imgbody appendFormat:@"%@\r\n",MPboundary];
            [imgbody appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n", fileArray[i],imageNameArray[i]];
            //声明上传文件的格式
            [imgbody appendFormat:@"Content-Type: application/octet-stream; charset=utf-8\r\n\r\n"];
            
            //将body字符串转化为UTF8格式的二进制
            [myRequestData appendData:[imgbody dataUsingEncoding:NSUTF8StringEncoding]];
            //将image的data加入
            [myRequestData appendData:data];
            [myRequestData appendData:[ @"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        //声明结束符：--AaB03x--
        NSString *end=[[NSString alloc]initWithFormat:@"%@\r\n",endMPboundary];
        //加入结束符--AaB03x--
        [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];

        //设置HTTPHeader中Content-Type的值
        NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
        //设置HTTPHeader
        [request setValue:content forHTTPHeaderField:@"Content-Type"];
        //设置Content-Length
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
        //设置http body
        [request setHTTPBody:myRequestData];
        //http method
        [request setHTTPMethod:@"POST"];
        
        // 3.获得会话对象
        NSURLSession *session = [NSURLSession sharedSession];
        //请求头请求体 下面可以根据而修改 这里我是方便自己使用了
        NSString *Names = [[NSUserDefaults standardUserDefaults]objectForKey:@"LoginCookieName"];
        NSString *Values = [[NSUserDefaults standardUserDefaults]objectForKey:@"LoginCookieValue"];
        NSString * str = [NSString stringWithFormat:@"%@=%@",Names,Values];
        [request setValue:str forHTTPHeaderField:@"Cookie"];
        // 4.根据会话对象，创建一个Task任务
        NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            NSString *resultStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            CorrespondingResults(dict , response , error);
        }];
        //5.最后一步，执行任务，(resume也是继续执行)。
        [sessionDataTask resume];
    });
}



#pragma mark ----- GET请求简写化
/**
 Get请求调用方法(可设置超时时间,请求进度,转圈圈等待文字,成功失败提示框文字)
 @param param 请求参数
 @param URLStr 请求URL
 @param WaitingProgressStr 发送数据请求等待时候转圈圈的文字
 @param success 请求成功的回调
 @param fail 请求失败的回调
 */
+ (void)AFNHTTP_GETHttpJianXieParam:(NSDictionary *)param URLStr:(NSString *)URLStr WaitingProgressStr:(NSString *)WaitingProgressStr  success:(void(^)(NSURLSessionTask *task , NSDictionary *responseDic))success fail:(void(^)(NSURLSessionTask *task , NSError *error))fail {
    ZY_ProgressPack *ProgressPack = [[ZY_ProgressPack alloc]init];
    if (WaitingProgressStr.length != 0) {
        [ProgressPack GetProgressShowTitle:WaitingProgressStr];
    }
    AFHTTPSessionManager *manager = [self TFSharedManagerShaBiHouTai];
    manager.requestSerializer.timeoutInterval = kTimeOutInterval;//超时时间
    //请求头请求体 下面可以根据而修改 这里我是方便自己使用了
    NSString *Names = [[NSUserDefaults standardUserDefaults]objectForKey:@"LoginCookieName"];
    NSString *Values = [[NSUserDefaults standardUserDefaults]objectForKey:@"LoginCookieValue"];
    NSString * str = [NSString stringWithFormat:@"%@=%@",Names,Values];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Cookie"];
    
    [manager GET:URLStr parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task ,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];
}


#pragma mark ----- POST请求简写化
/**
 POST请求调用方法(可设置超时时间,请求进度,转圈圈等待文字,成功失败提示框文字)
 @param param 请求参数
 @param URLStr 请求URL
 @param WaitingProgressStr 发送数据请求等待时候转圈圈的文字
 @param success 请求成功的回调
 @param fail 请求失败的回调
 */
+ (void)AFNHTTP_POSTHttpJianXieParam:(NSDictionary *)param URLStr:(NSString *)URLStr WaitingProgressStr:(NSString *)WaitingProgressStr  success:(void(^)(NSURLSessionTask *task , NSDictionary *responseDic))success fail:(void(^)(NSURLSessionTask *task , NSError *error))fail {
    ZY_ProgressPack *ProgressPack = [[ZY_ProgressPack alloc]init];
    if (WaitingProgressStr.length != 0) {
        [ProgressPack GetProgressShowTitle:WaitingProgressStr];
    }
    AFHTTPSessionManager *manager = [self TFSharedManagerShaBiHouTai];
    manager.requestSerializer.timeoutInterval = kTimeOutInterval;//超时时间
    //请求头请求体  下面可以根据而修改 这里我是方便自己使用了
    NSString *Names = [[NSUserDefaults standardUserDefaults]objectForKey:@"LoginCookieName"];
    NSString *Values = [[NSUserDefaults standardUserDefaults]objectForKey:@"LoginCookieValue"];
    NSString * str = [NSString stringWithFormat:@"%@=%@",Names,Values];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Cookie"];
    [manager POST:URLStr parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task ,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];
}























@end
