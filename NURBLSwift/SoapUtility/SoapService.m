//
//  SoapService.m
//  SOAP-IOS
//
//  Created by Elliott on 13-7-26.
//  Copyright (c) 2013年 Elliott. All rights reserved.
//

#import "SoapService.h"
#import "AFNetworking.h"
#import "Soap.h"

@implementation ResponseData 

@end

@implementation SoapService

-(id)initWithPostUrl:(NSString *)url SoapAction:(NSString *)soapAction{
    self=[super init];
    if(self){
        self.PostUrl=url;
        self.SoapAction=soapAction;
    }
    return self;
}
-(NSString*)Getdata:(NSData *)returnData methodName:(NSString *)name {
    NSString *retstr = @"";
    DDXMLDocument *xmldoc = [[DDXMLDocument alloc] initWithData:returnData options:0 error:nil];
    NSArray *arrdata = [xmldoc nodesForXPath:@"//SOAP-ENV:Body" error:nil];
    for (DDXMLElement *itm in arrdata) {
        //NSString * messageName=[NSString stringWithFormat:@"%@%@",methodName,@"SoapIn"];
        NSString *respname = [NSString stringWithFormat:@"%@%@",name,@"Response"];
        NSArray *itm2 = [itm elementsForName:respname];
        if (itm2.count>0) {
            DDXMLElement* itm3 = [itm2 lastObject];
            NSString *resultname = [NSString stringWithFormat:@"%@%@",name,@"Result"];
            NSArray *itm4 = [itm3 elementsForName:resultname];
            if (itm4.count>0) {
                retstr = [[itm4 lastObject] stringValue];
                //NSLog(retstr);
            }
        }
    }
    return retstr;
    
}
-(ResponseData *)PostSync:(NSString *)postData methodName:(NSString *)name{
    
    NSMutableURLRequest *request=[self CreatRequest:postData];
    // Response对象，用来得到返回后的数据，比如，用statusCode==200 来判断返回正常
    NSHTTPURLResponse *response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:&response error:nil];
    // 处理返回的数据
    //NSString *strReturn = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
   
    NSString *retdt = [self Getdata:returnData methodName:name];
    ResponseData *result=[[ResponseData alloc] init];
    result.StatusCode=response.statusCode;
    result.Content=retdt;

    return result;
}

-(NSData *)PostSyncData:(NSString *)postData methodName:(NSString *)name{
    
    NSMutableURLRequest *request=[self CreatRequest:postData];
    // Response对象，用来得到返回后的数据，比如，用statusCode==200 来判断返回正常
    NSHTTPURLResponse *response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:&response error:nil];
    
  //    // 处理返回的数据
//    NSString *strReturn = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//    
//    ResponseData *result=[[ResponseData alloc] init];
//    result.StatusCode=response.statusCode;
//    result.Content=strReturn;
    
    return returnData;
}
-(void)PostAsync:(NSString *)postData methodName:(NSString *)name Success:(SuccessBlock)success falure:(FailureBlock)failure{
    NSMutableURLRequest *request=[self CreatRequest:postData];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
         NSString *retdt = [self Getdata:operation.responseData methodName:name];
        
         success(retdt);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         failure(error);
    }];
    [operation start];
}

-(NSMutableURLRequest *)CreatRequest:(NSString *)postData{
    // 要请求的地址
    NSString *urlString=self.PostUrl;
    // 将地址编码
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    // 实例化NSMutableURLRequest，并进行参数配置
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    if(self.Timeout){
        [request setTimeoutInterval: self.Timeout];
    }else{
        [request setTimeoutInterval: 30];
    }
    if(self.SoapAction){
        [request addValue:self.SoapAction forHTTPHeaderField:@"SOAPAction"];
    }
    if(self.ContentType){
        [request addValue:self.ContentType forHTTPHeaderField:@"Content-Type"];
    }else{
        [request addValue:@"text/xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    }
    if(self.UserAgent){
        [request addValue:self.UserAgent forHTTPHeaderField:@"User-Agent"];
    }else{
        [request addValue:@"IOS App (power by elliott)" forHTTPHeaderField:@"User-Agent"];
    }
    if(self.AcceptEncoding){
        [request addValue:self.AcceptEncoding forHTTPHeaderField:@"Accept-Encoding"];
    }
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

@end
