//
//  HttpUtil.swift
//  dhcnur
//
//  Created by cyf on 14/10/24.
//  Copyright (c) 2014年 cyf. All rights reserved.
//

import UIKit
import AFNetworking
//import Alamofire
class HttpUtil :NSObject {

    func requestString(type:String,url:String,params:NSDictionary,complete:(data:AnyObject)->Void){
//        let request = Alamofire.request(.GET,url,parameters:params as? [String : AnyObject]).responseString{
//            (_,_,string,_) in
//            print(string)
//            let astring = string?.stringByReplacingOccurrencesOfString("\r\n", withString: "", options: [], range: nil)
//                dispatch_async(dispatch_get_main_queue(),
//                {
//                    complete(data:astring!)
//            })
        }
    }
    func soapExcute(clsname:String,method:String,paramdic:NSDictionary,CompletinonHander:(data:AnyObject)->Void)
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        let ipval = defaults.objectForKey("IP") as? String
        if let ip=ipval{
            let url = ip+"/DWR.NurseEmrComm.cls"
            let filename = "DWR.NurseEmrComm"
            let methodName = "Excute"
            var dicstring: NSData?
            do {
                dicstring = try NSJSONSerialization.dataWithJSONObject(paramdic, options: NSJSONWritingOptions())
            } catch _ {
                dicstring = nil
            }
            let str = NSString(data: dicstring!, encoding: 4) as? String
            if let dd=str{
                let dic = ["clsName":clsname,"methodName":method,"parameters":dd]
                let soaputility = SoapUtility(fromFile: filename)
                let postData = soaputility.BuildSoapwithMethodName(methodName, withParas: dic)
                let soaprequest = SoapService()
                soaprequest.PostUrl = url
                soaprequest.SoapAction = soaputility.GetSoapActionByMethodName(methodName, soapType: SOAP)
                //var responseData = soaprequest.PostSync(postData, methodName: methodName)
                soaprequest.PostAsync(postData, methodName: methodName,
                                      success:{
                                               str in
                                               CompletinonHander(data: str)
                                      },
                                      falure: {
                                              err in
                                              CompletinonHander(data: err)
                                      })
            }
        }
    }
    func getsoapdata(){
        let url = "http://10.160.16.91/dthealth/web/DWR.NurseEmrComm.cls"
        let filename = "DWR.NurseEmrComm"
        let methodName = "Excute"
        let mydic = ["parameter1":"98"]
        var dicstring: NSData?
        do {
            dicstring = try NSJSONSerialization.dataWithJSONObject(mydic, options: NSJSONWritingOptions())
        } catch _ {
            dicstring = nil
        }
        let str = NSString(data: dicstring!, encoding: 4) as? String
        //var start=gettime()
        if let dd=str{
            let dic = ["clsName":"NurEmr.Ipad.Common","methodName":"getcurwardpat","parameters":dd]
            let soaputility = SoapUtility(fromFile: filename)
            let postData = soaputility.BuildSoapwithMethodName(methodName, withParas: dic)
            let soaprequest = SoapService()
            soaprequest.PostUrl = url
            soaprequest.SoapAction = soaputility.GetSoapActionByMethodName(methodName, soapType: SOAP)
            //var responseData = soaprequest.PostSync(postData, methodName: methodName)
            soaprequest.PostAsync(postData, methodName: methodName, success:{ str in
                let data = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                var flag = NSJSONSerialization.isValidJSONObject(str)
                var err=NSErrorPointer()
                let dic = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSArray
              }, falure: {
                    err in
            })
        }
        
        
    }

    func requestwithurlandparam(urlstr:String,paramdic:NSDictionary,CompletinonHander:(data:AnyObject)->Void)
    {
        let manager=AFHTTPRequestOperationManager()
        //var url = "http://api.openweathermap.org/data/2.5/weather"
        //var url = "http://10.160.16.30/dthealth/web/csp/dhc.nurse.pda.common.getdata.csp?className=Nur.Iphone.Common&methodName=logon&type=Method"
        //var urlstr:NSString = "
        let set=NSSet()
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