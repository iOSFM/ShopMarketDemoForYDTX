//
//  NetWorkService.m
//  YDTXFunDemo
//
//  Created by Story5 on 13/12/2016.
//  Copyright © 2016 Story5. All rights reserved.
//

#import "NetWorkService.h"

@interface NetWorkService ()

@property (nonatomic,retain) AFHTTPSessionManager *httpSessionManager;

@end

static NetWorkService *instance = nil;

@implementation NetWorkService

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

#pragma mark - Project ShopMarket GET/POST methods
- (void)requestForDataByURLModuleKey:(URLModuleKeyType)urlModuleKey
{
    NSString *requestURLString = [self getRequestURLStringByURLModuleKey:urlModuleKey];
    RequestMethod requestMethod = [self getRequestMethodByURLModuleKey:urlModuleKey];
    switch (requestMethod) {
        case GET:
        {
            [self.httpSessionManager GET:requestURLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
            break;
        case POST:
        {
            [self.httpSessionManager POST:requestURLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
        default:
            break;
    }
    
}

#pragma mark - get info form 'URLInterface.plist' file
- (NSDictionary *)getRequestInfoDictionaryByURLModuleKey:(URLModuleKeyType)urlModuleKey
{
    NSDictionary *requestInfoDictionary = nil;
    switch (urlModuleKey) {
        case URLModuleKeyTypeShopCategory:
        {
            requestInfoDictionary = [self.urlDictionary objectForKey:@"ShopCategory"];
        }
            break;
        case URLModuleKeyTypeCategoryList:
        {
            requestInfoDictionary = [self.urlDictionary objectForKey:@"CategoryList"];
        }
            break;
        case URLModuleKeyTypeHomeListAggregatedData:
        {
            requestInfoDictionary = [self.urlDictionary objectForKey:@"HomeListAggregatedData"];
        }
            break;
        case URLModuleKeyTypeProductDetail:
        {
            requestInfoDictionary = [self.urlDictionary objectForKey:@"ProductDetail"];
        }
            break;
        case URLModuleKeyTypeProductDetailModel:
        {
            requestInfoDictionary = [self.urlDictionary objectForKey:@"ProductDetailModel"];
        }
            break;
        case URLModuleKeyTypeAddAddress:
        {
            requestInfoDictionary = [self.urlDictionary objectForKey:@"AddAddress"];
        }
            break;
        case URLModuleKeyTypeAddressList:
        {
            requestInfoDictionary = [self.urlDictionary objectForKey:@"AddressList"];
        }
            break;
        case URLModuleKeyTypeModifyAddressShowInfo:
        {
            requestInfoDictionary = [self.urlDictionary objectForKey:@"ModifyAddressShowInfo"];
        }
            break;
        case URLModuleKeyTypeCommitModifyAddress:
        {
            requestInfoDictionary = [self.urlDictionary objectForKey:@"CommitModifyAddress"];
        }
            break;
        case URLModuleKeyTypeDeleteAddress:
        {
            requestInfoDictionary = [self.urlDictionary objectForKey:@"DeleteAddress"];
        }
            break;
        default:
            break;
    }
    return [requestInfoDictionary copy];
}

- (NSString *)getRequestURLStringByURLModuleKey:(URLModuleKeyType)urlModuleKey
{
    NSDictionary *requestInfoDictionary = [self getRequestInfoDictionaryByURLModuleKey:urlModuleKey];
    NSString *URLString = [requestInfoDictionary objectForKey:@"RequestURL"];
    return URLString;
}

- (RequestMethod)getRequestMethodByURLModuleKey:(URLModuleKeyType)urlModuleKey
{
    NSDictionary *requestInfoDictionary = [self getRequestInfoDictionaryByURLModuleKey:urlModuleKey];
    NSString *methodString = [requestInfoDictionary objectForKey:@"RequestMethod"];
    if ([methodString isEqualToString:@"GET"]) {
        return GET;
    } else if ([methodString isEqualToString:@"POST"]) {
        return POST;
    }
    return RequestMethodNone;
}

- (NSDictionary *)getRequestParamByURLModuleKey:(URLModuleKeyType)urlModuleKey
{
    NSDictionary *requestInfoDictionary = [self getRequestInfoDictionaryByURLModuleKey:urlModuleKey];
    NSDictionary *requestParam = [requestInfoDictionary objectForKey:@"RequestParam"];
    return requestParam;
}

- (NSDictionary *)getResponseParamByURLModuleKey:(URLModuleKeyType)urlModuleKey
{
    NSDictionary *requestInfoDictionary = [self getRequestInfoDictionaryByURLModuleKey:urlModuleKey];
    NSDictionary *responseParam = [requestInfoDictionary objectForKey:@"ResponseParam"];
    return responseParam;
}

#pragma mark - Response Status
- (NSString *)showMessageWithResponseStatus:(ResponseStatus)aStatus
{
    NSString *message = nil;
    switch (aStatus) {
        case responseSuccessed:
            message = @"成功";
            break;
        case responseFailed:
            message = @"失败";
            break;
        case responseIllegalData:
            message = @"数据不合法";
            break;
        case responseIllegalParam:
            message = @"非法参数";
            break;
            
        default:
            break;
    }
    return message;
}



#pragma mark - get
- (NSMutableDictionary *)urlDictionary
{
    if (_urlDictionary == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"URLInterface" ofType:@"plist"];
        _urlDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }
    return _urlDictionary;
}


#pragma mark - AFHTTPSessionManager
- (AFHTTPSessionManager *)httpSessionManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 超时时间
    //    manager.requestSerializer.timeoutInterval = 200;
    
    // 声明上传的是json格式的参数，需要你和后台约定好，不然会出现后台无法获取到你上传的参数问题
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
    //        manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
    
    // 声明获取到的数据格式
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    manager.responseSerializer = [AFJSONResponseSerializer serializer]; // AFN会JSON解析返回的数据
    // 个人建议还是自己解析的比较好，有时接口返回的数据不合格会报3840错误，大致是AFN无法解析返回来的数据
    return manager;
}

#pragma mark - AF GET/POST methods
- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress * _Nonnull))downloadProgress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    return [self.httpSessionManager GET:URLString parameters:parameters progress:downloadProgress success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress * _Nonnull))uploadProgress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    return [self.httpSessionManager POST:URLString parameters:parameters progress:uploadProgress success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> _Nonnull))block progress:(void (^)(NSProgress * _Nonnull))uploadProgress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))success failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failure
{    return [self.httpSessionManager POST:URLString parameters:parameters constructingBodyWithBlock:block progress:uploadProgress success:success failure:failure];
}

@end
