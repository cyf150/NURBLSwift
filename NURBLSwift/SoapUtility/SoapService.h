//
//  SoapService.h
//  SOAP-IOS
//
//  Created by Elliott on 13-7-26.
//  Copyright (c) 2013年 Elliott. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface ResponseData : NSObject

@property NSInteger StatusCode;
@property NSString *Content;

@end

typedef void (^SuccessBlock) (NSString *response);
typedef void (^FailureBlock) (NSError *response);

@interface SoapService : NSObject

@property (nonatomic,strong) NSString *SoapAction;
@property (nonatomic,strong) NSString *UserAgent;
@property (nonatomic,strong) NSString *ContentType;
@property (nonatomic,strong) NSString *PostUrl;
@property (nonatomic,strong) NSString *AcceptEncoding;
@property (nonatomic) NSInteger Timeout;

@property (nonatomic,strong) SuccessBlock success;
@property (nonatomic,strong) FailureBlock failure;

-(id)initWithPostUrl:(NSString *)url SoapAction:(NSString *)soapAction;

-(ResponseData *)PostSync:(NSString *)postData methodName:(NSString *)name;
-(NSData *)PostSyncData:(NSString *)postData methodName:(NSString *)name;
-(void)PostAsync:(NSString *)postData methodName:(NSString *)name Success:(SuccessBlock)success falure:(FailureBlock)falure;

@end
