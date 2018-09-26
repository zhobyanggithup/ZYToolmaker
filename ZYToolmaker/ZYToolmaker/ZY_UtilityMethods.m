//
//  ZY_UtilityMethods.m
//  ZYCoffers
//
//  Created by 周洋 on 2018/9/20.
//  Copyright © 2018年 周洋. All rights reserved.
//

#import "ZY_UtilityMethods.h"

#import <CommonCrypto/CommonDigest.h>
#import <Foundation/Foundation.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import<SystemConfiguration/CaptiveNetwork.h>

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"


#define UUID_KEYCHAIN @"UUIDKeyChain"

@implementation ZY_UtilityMethods

+ (UIButton *)setBtnTitle:(NSString *)title titleColor:(UIColor *)titleColor backGroundImg:(UIImage *)backGroundImg titleFount:(int)titleFount {
    UIButton *btn = [UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setBackgroundImage:backGroundImg forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:titleFount];
    
    return btn;
}

+ (UILabel *)setLableText:(NSString *)title titleCorlor:(UIColor *)titleColor titleFount:(int)titleFount titleAlignment:(NSTextAlignment)titleAlignment {
    UILabel *label = [UILabel new];
    label.text = title;
    label.textColor = titleColor;
    label.textAlignment = titleAlignment;
    label.font = [UIFont systemFontOfSize:titleFount];
    return label;
}

+ (UITextField *)setTextFieldStyle:(UITextBorderStyle)style placeholder:(NSString *)placeholder textFiledFount:(int)Fount titleColor:(UIColor *)titleColor clearText:(BOOL)clearsText keyboardType:(UIKeyboardType)KeyBoardType {
    UITextField *textField = [UITextField new];
    textField.borderStyle = style;
    textField.placeholder = placeholder;
    textField.font = [UIFont systemFontOfSize:Fount];
    textField.textColor = titleColor;
    textField.clearsOnBeginEditing = clearsText;
    textField.keyboardType = KeyBoardType;
    return textField;
}

+ (NSString *)ToHex:(long long int)tmpid {
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<4; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
    }
    return str;
}


//十六进制转换成十进制:
+ (NSInteger)ToNumber:(NSString *)hexstring {
    if (hexstring.length == 0) {
        return 0;
    }
    NSInteger NewString =(NSInteger )strtoul([[hexstring substringWithRange:NSMakeRange(0, hexstring.length)]UTF8String],0,16);
    return NewString;
    
}
#pragma mark - 32位 小写
+(NSString *)MD5ForLower32Bate:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}

#pragma mark - 32位 大写
+(NSString *)MD5ForUpper32Bate:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    
    return digest;
}

#pragma mark - 16位 大写
+ (NSString *)MD5ForUpper16Bate:(NSString *)str{
    
    NSString *md5Str = [self MD5ForUpper32Bate:str];
    
    NSString  *string;
    for (int i=0; i<24; i++) {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}
+(NSString *)md5String:(NSString *)sourceString{
    if(!sourceString){
        return nil;//判断sourceString如果为空则直接返回nil。
    }
    //MD5加密都是通过C级别的函数来计算，所以需要将加密的字符串转换为C语言的字符串
    const char *cString = sourceString.UTF8String;
    //创建一个C语言的字符数组，用来接收加密结束之后的字符
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    //MD5计算（也就是加密）
    //第一个参数：需要加密的字符串
    //第二个参数：需要加密的字符串的长度
    //第三个参数：加密完成之后的字符串存储的地方
    CC_MD5(cString, (CC_LONG)strlen(cString), result);
    //将加密完成的字符拼接起来使用（16进制的）。
    //声明一个可变字符串类型，用来拼接转换好的字符
    NSMutableString *resultString = [[NSMutableString alloc]init];
    //遍历所有的result数组，取出所有的字符来拼接
    for (int i = 0;i < CC_MD5_DIGEST_LENGTH; i++) {
        [resultString  appendFormat:@"%02x",result[i]];
        //%02x：x 表示以十六进制形式输出，02 表示不足两位，前面补0输出；超出两位，不影响。当x小写的时候，返回的密文中的字母就是小写的，当X大写的时候返回的密文中的字母是大写的。
    }
    //打印最终需要的字符
    LDLog(@"resultString === %@",resultString);
    return resultString;
}

+(NSString *)md5Data:(NSData *)sourceData{
    if (!sourceData) {
        return nil;//判断sourceString如果为空则直接返回nil。
    }
    //需要MD5变量并且初始化
    CC_MD5_CTX  md5;
    CC_MD5_Init(&md5);
    //开始加密(第一个参数：对md5变量去地址，要为该变量指向的内存空间计算好数据，第二个参数：需要计算的源数据，第三个参数：源数据的长度)
    CC_MD5_Update(&md5, sourceData.bytes, (CC_LONG)sourceData.length);
    //声明一个无符号的字符数组，用来盛放转换好的数据
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    //将数据放入result数组
    CC_MD5_Final(result, &md5);
    //将result中的字符拼接为OC语言中的字符串，以便我们使用。
    NSMutableString *resultString = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [resultString appendFormat:@"%02X",result[i]];
    }
    LDLog(@"resultString=========%@",resultString);
    return  resultString;
}
+(NSString *)base64EncodingWithData:(NSData *)sourceData{
    if (!sourceData) {//如果sourceData则返回nil，不进行加密。
        return nil;
    }
    NSString *resultString = [sourceData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return resultString;
}

+(id)base64EncodingWithString:(NSString *)sourceString{
    if (!sourceString) {
        return nil;//如果sourceString则返回nil，不进行解密。
    }
    NSData *resultData = [[NSData alloc]initWithBase64EncodedString:sourceString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return resultData;
}

/*
 *手机号验证
 */
+ (BOOL) isValidateMobile:(NSString *)mobileNum {
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-9]|8[0-9]|70)\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[0-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-9]|4[5]|5[0-9]|7[0-9]|8[0-9])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom    * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)){
        return YES;
    }
    else
    {
        return NO;
    }
}


+ (NSData *)zipNSDataWithImage:(UIImage *)sourceImage{
    //进行图像尺寸的压缩
    CGSize imageSize = sourceImage.size;//取出要压缩的image尺寸
    CGFloat width = imageSize.width;    //图片宽度
    CGFloat height = imageSize.height;  //图片高度
    //1.宽高大于1280(宽高比不按照2来算，按照1来算)
    if (width>1280) {
        if (width>height) {
            CGFloat scale = width/height;
            height = 1280;
            width = height*scale;
        }else{
            CGFloat scale = height/width;
            width = 1280;
            height = width*scale;
        }
        //2.高度大于1280
    }else if(height>1280){
        CGFloat scale = height/width;
        width = 1280;
        height = width*scale;
    }else{
    }
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [sourceImage drawInRect:CGRectMake(0,0,width,height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //进行图像的画面质量压缩
    NSData *data=UIImageJPEGRepresentation(newImage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(newImage, 0.7);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(newImage, 0.8);
        }else if (data.length>200*1024) {
            //0.25M-0.5M
            data=UIImageJPEGRepresentation(newImage, 0.9);
        }
    }
    return data;
}


+ (NSMutableURLRequest *)uploadImage:(NSString*)url uploadImage:(UIImage *)uploadImage params:(NSMutableDictionary *)params {
    [params setObject:uploadImage forKey:@"file"];
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //要上传的图片
    UIImage *image=[params objectForKey:@"file"];
    //得到图片的data
    NSData* data = UIImagePNGRepresentation(image);
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [params allKeys];
    
    //遍历keys
    for(int i = 0; i < [keys count]; i++)
    {
        //得到当前key
        NSString *key = [keys objectAtIndex:i];
        //如果key不是file，说明value是字符类型，比如name
        if(![key isEqualToString:@"file"])
        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
        }
    }
    
    //添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明file字段，文件名为image.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"image.png\"\r\n"];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc] initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData = [NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
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
    
    return request;
}

+ (UIColor *) colorWithHexString: (NSString *)color {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (NSString *) sha1:(NSString *)input {
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}


/** UUID */
+ (NSString *)GetUUID{
    
    NSMutableDictionary *UUIDKeyChain = (NSMutableDictionary *)[self load:UUID_KEYCHAIN];
    NSString * uuid;
    if (![UUIDKeyChain objectForKey:@"uuidkey"]) {
        uuid = [ZY_UtilityMethods getUUIDString];
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:uuid forKey:@"uuidkey"];
        [ZY_UtilityMethods save:UUID_KEYCHAIN data:dic];
    }else{
        uuid = [UUIDKeyChain objectForKey:@"uuidkey"];
    }
    
    return uuid;
}

+ (NSString*) getUUIDString
{
    
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    
    CFRelease(uuidObj);
    
    return uuidString;
    
}

+(void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [ZY_UtilityMethods getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}


+(NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,nil];
}


+(id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [ZY_UtilityMethods getKeychainQuery:service];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

- (void)deleteuuid{
    NSMutableDictionary *keychainQuery = [ZY_UtilityMethods getKeychainQuery:UUID_KEYCHAIN];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [ZY_UtilityMethods getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

//URL转码
+ (NSString *)URLEncodedString:(NSString*)sourceString {
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)sourceString,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

//URL解码
+(NSString *)URLDecodedString:(NSString *)str {
    
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}


//0A0A0A0A  后台返回8位十六进制时间转换10进制时间格式显示 转换方法
+ (NSString *)GetWeiTime:(NSString *)Str Title:(NSString *)Title FuTitle:(NSString *)FuTitle {
    NSString *a;
    NSString *b;
    NSString *c;
    NSString *d;
    
    if (Str.length == 0) {
        return [NSString stringWithFormat:@"0%@",Title];
    }
    
    if ([[Str substringToIndex:2] isEqualToString:@"00"]) {
        a = @"00";
    }else {
        a = [NSString stringWithFormat:@"%ld",(long)[ZY_UtilityMethods ToNumber:[Str substringToIndex:2]]];
    }
    
    NSRange range = {2,2};
    if ([[Str substringWithRange:range] isEqualToString:@"00"]) {
        b = @"00";
    }else {
        b = [NSString stringWithFormat:@"%ld",(long)[ZY_UtilityMethods ToNumber:[Str substringWithRange:range]]];
        if (b.length == 1) {
            b = [NSString stringWithFormat:@"0%ld",(long)[ZY_UtilityMethods ToNumber:[Str substringWithRange:range]]];
        }
    }
    
    NSRange ranges = {4,2};
    if ([[Str substringWithRange:ranges] isEqualToString:@"00"]) {
        c = @"00";
    }else {
        c = [NSString stringWithFormat:@"%ld",(long)[ZY_UtilityMethods ToNumber:[Str substringWithRange:ranges]]];
        if (c.length == 1) {
            c = [NSString stringWithFormat:@"0%ld",(long)[ZY_UtilityMethods ToNumber:[Str substringWithRange:range]]];
        }
    }
    
    if ([[Str substringFromIndex:6] isEqualToString:@"00"]) {
        d = @"00";
    }else {
        d = [NSString stringWithFormat:@"%ld",(long)[ZY_UtilityMethods ToNumber:[Str substringFromIndex:6]]];
    }
    
    NSString *XiaoShi = [NSString stringWithFormat:@"%@%@%@",a,b,c];
    int aa = [XiaoShi intValue];
    int bb = [d intValue];
    NSString *backStr = [NSString stringWithFormat:@"%d%@%d%@",aa,Title,bb,FuTitle];
    return backStr;
}

+ (NSString *)GetEightNumber:(NSString *)Str {
    NSString *a;
    NSString *b;
    NSString *c;
    NSString *d;
    
    if (Str.length == 0) {
        return @"0";
    }
    
    if ([[Str substringToIndex:2] isEqualToString:@"00"]) {
        a = @"00";
    }else {
        a = [NSString stringWithFormat:@"%ld",(long)[ZY_UtilityMethods ToNumber:[Str substringToIndex:2]]];
    }
    
    NSRange range = {2,2};
    if ([[Str substringWithRange:range] isEqualToString:@"00"]) {
        b = @"00";
    }else {
        b = [NSString stringWithFormat:@"%ld",(long)[ZY_UtilityMethods ToNumber:[Str substringWithRange:range]]];
        if (b.length == 1) {
            b = [NSString stringWithFormat:@"0%ld",(long)[ZY_UtilityMethods ToNumber:[Str substringWithRange:range]]];
        }
    }
    
    NSRange ranges = {4,2};
    if ([[Str substringWithRange:ranges] isEqualToString:@"00"]) {
        c = @"00";
    }else {
        c = [NSString stringWithFormat:@"%ld",(long)[ZY_UtilityMethods ToNumber:[Str substringWithRange:ranges]]];
        if (c.length == 1) {
            c = [NSString stringWithFormat:@"0%ld",(long)[ZY_UtilityMethods ToNumber:[Str substringWithRange:range]]];
        }
    }
    
    if ([[Str substringFromIndex:6] isEqualToString:@"00"]) {
        d = @"00";
    }else {
        d = [NSString stringWithFormat:@"%ld",(long)[ZY_UtilityMethods ToNumber:[Str substringFromIndex:6]]];
    }
    
    NSString *XiaoShi = [NSString stringWithFormat:@"%@%@%@%@",a,b,c,d];
    int aa = [XiaoShi intValue];
    NSString *backStr = [NSString stringWithFormat:@"%d",aa];
    return backStr;
}
//FFFFFFFFFF 设备允许使用时间 设备主板激活时间
+ (NSString *)GetDeviceTenNumber:(NSString *)Str {
    if (Str.length == 0) {
        return @"0分";
    }
    NSString *a;
    NSString *b;
    NSString *c;
    NSString *d;
    NSString *e;
    
    if ([[Str substringToIndex:2] isEqualToString:@"00"]) {
        a = @"00";
    }else {
        a = [NSString stringWithFormat:@"%ld",(long)[ZY_UtilityMethods ToNumber:[Str substringToIndex:2]]];
    }
    
    NSRange range = {2,2};
    if ([[Str substringWithRange:range] isEqualToString:@"00"]) {
        b = @"00";
    }else {
        b = [NSString stringWithFormat:@"%ld",(long)[ZY_UtilityMethods ToNumber:[Str substringWithRange:range]]];
        if (b.length == 1) {
            b = [NSString stringWithFormat:@"0%ld",(long)[ZY_UtilityMethods ToNumber:[Str substringWithRange:range]]];
        }
    }
    
    NSRange ranges = {4,2};
    if ([[Str substringWithRange:ranges] isEqualToString:@"00"]) {
        c = @"00";
    }else {
        c = [NSString stringWithFormat:@"%ld",(long)[ZY_UtilityMethods ToNumber:[Str substringWithRange:ranges]]];
        if (c.length == 1) {
            c = [NSString stringWithFormat:@"0%ld",(long)[ZY_UtilityMethods ToNumber:[Str substringWithRange:range]]];
        }
    }
    
    NSRange rangess = {6,2};
    if ([[Str substringWithRange:rangess] isEqualToString:@"00"]) {
        d = @"00";
    }else {
        d = [NSString stringWithFormat:@"%ld",(long)[ZY_UtilityMethods ToNumber:[Str substringWithRange:rangess]]];
        if (c.length == 1) {
            d = [NSString stringWithFormat:@"0%ld",(long)[ZY_UtilityMethods ToNumber:[Str substringWithRange:range]]];
        }
    }
    
    if ([[Str substringFromIndex:8] isEqualToString:@"00"]) {
        e = @"00";
    }else {
        e = [NSString stringWithFormat:@"%ld",(long)[ZY_UtilityMethods ToNumber:[Str substringFromIndex:6]]];
    }
    
    NSString *backStr;
    if ([a intValue] == 0) {
        if ([b intValue] == 0) {
            if ([c intValue] == 0) {
                if ([d intValue] == 0) {
                    if ([e intValue] == 0) {
                        backStr = [NSString stringWithFormat:@"0分"];
                    }else {
                        backStr = [NSString stringWithFormat:@"%d分",[e intValue]];
                    }
                }else {
                    backStr = [NSString stringWithFormat:@"%d小时%d分",[d intValue],[e intValue]];
                }
            }else {
                backStr = [NSString stringWithFormat:@"%d天%d小时%d分",[c intValue],[d intValue],[e intValue]];
            }
        }else {
            backStr = [NSString stringWithFormat:@"%d月%d天%d小时%d分",[b intValue],[c intValue],[d intValue],[e intValue]];
        }
    }else {
        backStr = [NSString stringWithFormat:@"%d年%d月%d天%d小时%d分",[a intValue],[b intValue],[c intValue],[d intValue],[e intValue]];
    }
    
    return backStr;
}
//0A0A0A0A  节省电量转换方式
+ (NSString *)GetDianLiang:(NSString *)Str Title:(NSString *)Title{
    NSString *a;
    NSString *b;
    NSString *c;
    NSString *d;
    
    if (Str.length == 0) {
        return [NSString stringWithFormat:@"0%@",Title];
    }
    
    if ([[Str substringToIndex:2] isEqualToString:@"00"]) {
        a = @"00";
    }else {
        a = [NSString stringWithFormat:@"%ld",(long)[ZY_UtilityMethods ToNumber:[Str substringToIndex:2]]];
    }
    
    NSRange range = {2,2};
    if ([[Str substringWithRange:range] isEqualToString:@"00"]) {
        b = @"00";
    }else {
        b = [NSString stringWithFormat:@"%ld",(long)[ZY_UtilityMethods ToNumber:[Str substringWithRange:range]]];
        if (b.length == 1) {
            b = [NSString stringWithFormat:@"0%ld",(long)[ZY_UtilityMethods ToNumber:[Str substringWithRange:range]]];
        }
    }
    
    NSRange ranges = {4,2};
    if ([[Str substringWithRange:ranges] isEqualToString:@"00"]) {
        c = @"00";
    }else {
        c = [NSString stringWithFormat:@"%ld",(long)[ZY_UtilityMethods ToNumber:[Str substringWithRange:ranges]]];
        if (c.length == 1) {
            c = [NSString stringWithFormat:@"0%ld",(long)[ZY_UtilityMethods ToNumber:[Str substringWithRange:range]]];
        }
    }
    
    if ([[Str substringFromIndex:6] isEqualToString:@"00"]) {
        d = @"00";
    }else {
        d = [NSString stringWithFormat:@"%ld",(long)[ZY_UtilityMethods ToNumber:[Str substringFromIndex:6]]];
    }
    
    NSString *XiaoShi = [NSString stringWithFormat:@"%@%@%@",a,b,c];
    int aa = [XiaoShi intValue];
    int bb = [d intValue];
    NSString *backStr = [NSString stringWithFormat:@"%d.%d%@",aa,bb,Title];
    return backStr;
}


// 过滤字符串中的非汉字、字母、数字
- (void)SetDelegateTextField:(UITextField *)TextField {
    UITextRange *selectedRange = TextField.markedTextRange;
    UITextPosition *position = [TextField positionFromPosition:selectedRange.start offset:0];
    if (!position) {
        // 没有高亮选择的字
        // 1. 过滤非汉字、字母、数字字符
        TextField.text = [self filterCharactor:TextField.text withRegex:@"[^a-zA-Z0-9\u4e00-\u9fa5]"];
        // 2. 截取
        if (TextField.text.length >= 16) {
            TextField.text = [TextField.text substringToIndex:16];
        }
    } else {
        // 有高亮选择的字 不做任何操作
    }
}

// 过滤字符串中的非汉字、字母、数字
- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr{
    NSString *filterText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:filterText options:NSMatchingReportCompletion range:NSMakeRange(0, filterText.length) withTemplate:@""];
    return result;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    // 解决当双击切换标点时误删除正常文字 bug
    NSString *punctuateSring = @"，。？！._@/#";
    if (range.length == 0 && string.length == 1 && [punctuateSring containsString:string]) {
        return NO;
    }
    return YES;
}

+ (NSString *)GetSSIDWifiName {
    /** 此方法虽然无内存泄漏 但是大写全部改为小写了 */
    //    NSArray *ifs = CFBridgingRelease(CNCopySupportedInterfaces());
    //    id info = nil;
    //    for (NSString *ifnam in ifs) {
    //        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((CFStringRef)ifnam);
    //        if (info && [info count]) {
    //            break;
    //        }
    //    }
    //    NSDictionary *dic = (NSDictionary *)info;
    //    NSString *ssid = [[dic objectForKey:@"SSID"]lowercaseString];
    //    return ssid;
    
    
    /** 此方法有内存泄漏 */
    NSString *wifiName;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;//获取Wi-Fi数组
    
    for (NSString *interfaceName in interfaces) {
        
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            
            LDLog(@"network info -> %@", networkInfo);//这里是当前链接的Wi-Fi的mac地址以及Wi-Fi的名字
            
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
            
        }
        
    }
    
    //储存用户第一次登陆进来时候的网络名称
    return wifiName;
    
}



//判断字符串是否为空
+ (BOOL)isStringNil:(NSString *)string {
    string = [NSString stringWithFormat:@"%@",string];
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([string isEqualToString:@"<null>"]) {
        return YES;
    }
    if ([string isEqualToString:@"null"]) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        
        return YES;
    }
    return NO;
}

+ (NSString *)isNil:(NSString *)string {
    string = [NSString stringWithFormat:@"%@",string];
    if ([ZY_UtilityMethods isStringNil:string]) {
        return @"";
    }
    return string;
}


+ (NSString *)GetFilterElementNumber:(NSString *)Str {
    if (Str.length == 0 | Str.length != 4) {
        return @"0";
    }
    NSString *a = [NSString stringWithFormat:@"%ld",(long)[self ToNumber:[NSString stringWithFormat:@"%@",[Str substringWithRange:NSMakeRange(0,2)]]]];
    NSString *b = [NSString stringWithFormat:@"%ld",(long)[self ToNumber:[NSString stringWithFormat:@"%@",[Str substringWithRange:NSMakeRange(2,2)]]]];
    if (b.length == 1 && [b intValue] == 0) {
        b = @"00";
    }
    if ([a intValue] == 0) {
        if ([b intValue] == 0) {
            return [NSString stringWithFormat:@"%@%@",a,b];
        }else {
            return [NSString stringWithFormat:@"%@",b];
        }
    }
    return [NSString stringWithFormat:@"%@%@",a,b];
}


+ (NSString *)getRandomStringWithNum:(NSInteger)num {
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < num; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
}

+ (NSString *)ret32bitString:(NSUInteger)num {
    
    char data[num];
    
    for (int x=0; x < num; data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:data length:num encoding:NSUTF8StringEncoding];
    
}

- (void)GetLoginCoolies:(NSString *)UrlStr {
    //获取cookie
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage]cookiesForURL:[NSURL URLWithString:UrlStr]];
    for (NSHTTPCookie *tempCookie in cookies) {
        //打印cookies
        [[NSUserDefaults standardUserDefaults]setObject:tempCookie.name forKey:@"LoginCookieName"];
        [[NSUserDefaults standardUserDefaults]setObject:tempCookie.value forKey:@"LoginCookieValue"];
        LDLog(@"cookie----%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginCookieValue"]);
    }
}

+ (BOOL)GetIsNewVersion:(NSString *)AppStr serverStr:(NSString *)serverStr {
    AppStr = [NSString stringWithFormat:@"%@",AppStr];
    serverStr = [NSString stringWithFormat:@"%@",serverStr];
    if ([AppStr isEqualToString:serverStr]) {
        return YES;
    }
    NSRange range1 = [AppStr rangeOfString:@"."];
    int APPStr1 = [[NSString stringWithFormat:@"%@",[AppStr substringToIndex:range1.location]] intValue];
    NSString *AppStrHouXu = [AppStr substringFromIndex:range1.location+1];
    NSRange range2 = [AppStrHouXu rangeOfString:@"."];
    int APPStr2 = [[NSString stringWithFormat:@"%@",[AppStrHouXu substringToIndex:range2.location]] intValue];
    int APPStr3 = [[NSString stringWithFormat:@"%@",[AppStrHouXu substringFromIndex:range2.location+1]] intValue];
    
    NSRange rangeTwo1 = [serverStr rangeOfString:@"."];
    int serverStr1 = [[NSString stringWithFormat:@"%@",[serverStr substringToIndex:rangeTwo1.location]] intValue];
    NSString *serverStrHouXu = [serverStr substringFromIndex:rangeTwo1.location+1];
    NSRange rangeTwo2 = [serverStrHouXu rangeOfString:@"."];
    int serverStr2 = [[NSString stringWithFormat:@"%@",[serverStrHouXu substringToIndex:rangeTwo2.location]] intValue];
    int serverStr3 = [[NSString stringWithFormat:@"%@",[serverStrHouXu substringFromIndex:rangeTwo2.location+1]] intValue];
    
    if (APPStr1 > serverStr1) {
        return YES;
    }else if (APPStr1 == serverStr1 && APPStr2 > serverStr2) {
        return YES;
    }else if (APPStr1 == serverStr1 && APPStr2 == serverStr2 && APPStr3 > serverStr3) {
        return YES;
    }else
        
        return NO;
}

//- (void)ShowUserIsOffline:(NSString *)Message BackCode:(NSString *)Code {
//    if ([[NSString stringWithFormat:@"%@",Message]isEqualToString:ISLoginOFF]) {
//        [[NSUserDefaults standardUserDefaults]setObject:@"NO"  forKey:@"IsLogin"];
//        [[ZY_ProgressPack alloc]setWarningViewShowTitle:ISLoginOFF];
//        UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
//        [rootViewController presentViewController:[loginViewController new] animated:NO completion:nil];
//        return ;
//    }
//    if ([Code intValue] == 2) {
//        [[NSUserDefaults standardUserDefaults]setObject:@"NO"  forKey:@"IsLogin"];
//        [[ZY_ProgressPack alloc]setWarningViewShowTitle:ISLoginOFF];
//        UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
//        [rootViewController presentViewController:[loginViewController new] animated:NO completion:nil];
//        return ;
//    }
//}

/** 检测字符串里是否包含空格及特殊字符及空格 */
+ (BOOL)checkStringIsContainsSpecialCharacters:(NSString *)String UserInputTextFiledTitle:(NSString *)TitleStr {
    if ([ZY_UtilityMethods isStringNil:String]) {
        [[ZY_ProgressPack alloc]setWarningViewShowTitle:[NSString stringWithFormat:@"%@不能为空",TitleStr]];
        return YES;
    }
    //提示 标签不能输入特殊字符
    NSString *str =@"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    if (![emailTest evaluateWithObject:String]) {
        [[ZY_ProgressPack alloc]setWarningViewShowTitle:[NSString stringWithFormat:@"%@包含空格及特殊字符",TitleStr]];
        return YES;
    }
    if ([TitleStr isEqualToString:@"用户名"]) {
        if (String.length > TextNumber) {
            [[ZY_ProgressPack new]setWarningViewShowTitle:@"用户名不能大于25位!"];
            return YES;
        }
    }
    if ([TitleStr isEqualToString:@"密码"]) {
        if (String.length < 6) {
            [[ZY_ProgressPack new]setWarningViewShowTitle:@"密码不能小于6位!"];
            return YES;
        }
    }
    if ([TitleStr isEqualToString:@"手机号"]) {
        if (String.length != 11) {
            [[ZY_ProgressPack new]setWarningViewShowTitle:@"手机号位数不正确"];
            return YES;
        }
    }
    return NO;
}
/** 检测手机号码 */
+ (BOOL)checkStringIsPhone:(NSString *)String {
    if ([ZY_UtilityMethods isStringNil:String]) {
        [[ZY_ProgressPack alloc]setWarningViewShowTitle:[NSString stringWithFormat:@"手机号不能为空"]];
        return YES;
    }
    if (String.length != 11) {
        [[ZY_ProgressPack alloc]setWarningViewShowTitle:[NSString stringWithFormat:@"手机号码输入位数不正确"]];
        return YES;
    }
    
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < String.length) {
        NSString * string = [String substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            [[ZY_ProgressPack alloc]setWarningViewShowTitle:[NSString stringWithFormat:@"手机号码只能输入数字"]];
            return YES;
            break;
        }
        i++;
    }
    return NO;
}
//时间戳转换
- (NSString *)TimeStamp:(NSString *)strTime {
    if ([ZY_UtilityMethods isStringNil:strTime]) {
        return @"";
    }
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[strTime doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
    
}

@end
