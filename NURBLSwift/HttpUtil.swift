//
//  HttpUtil.swift
//  dhcnur
//
//  Created by cyf on 14/10/24.
//  Copyright (c) 2014年 cyf. All rights reserved.
//

import UIKit
import AFNetworking
class HttpUtil :NSObject {

    func requestwithurlandparam(urlstr:String,paramdic:NSDictionary,CompletinonHander:(data:AnyObject)->Void)
    {
        let manager=AFHTTPRequestOperationManager()
        //var url = "http://api.openweathermap.org/data/2.5/weather"
        //var url = "http://10.160.16.30/dthealth/web/csp/dhc.nurse.pda.common.getdata.csp?className=Nur.Iphone.Common&methodName=logon&type=Method"
        //var urlstr:NSString = "
        var set=NSSet()
        manager.responseSerializer.acceptableContentTypes=set.setByAddingObject("text/html")
        //let params=["userName":"dh444444","password":"30","logonLocType":""]
        manager.GET(urlstr,
            parameters: paramdic,
            success: {
                (operation:AFHTTPRequestOperation!,
                responseObject:AnyObject!) in
                dispatch_async(dispatch_get_main_queue(),
                {
                    CompletinonHander(data:responseObject!)
                 })
            }, failure:{
                (operation:AFHTTPRequestOperation!,
                error:NSError!)in
                CompletinonHander(data:NSNull())
        } )

    }

}