//
//  BedpatDAO.swift
//  NURBLSwift
//
//  Created by cyf on 15/4/25.
//  Copyright (c) 2015年 com.dhccnurse.cyf. All rights reserved.
//

import UIKit
import MJExtension
//import Alamofire
class BedpatDAO: NSObject {
    static let shareManagerobj:BedpatDAO = BedpatDAO()
    var ip=""
    class func shareManager()->BedpatDAO{
        return shareManagerobj
    }
    func getbeddata(locid:NSString)-> NSArray? {
        //var arr = [BedModel]()
//        var arrays = [Dictionary<String,String>]()
//        for i in 1...100
//        {
//            var dic = ["PatName":"张三哈\(i)","PatSex":(i%2==0 ? "男":"女"),"PatAge":"\(i)"]
//            arrays.append(dic)
//           
//        }
//        var arr = BedModel.objectArrayWithKeyValuesArray(arrays) as! [BedModel]
//        var defaults = NSUserDefaults.standardUserDefaults()
//        var ipval = defaults.objectForKey("IP") as? String
//        if let val=ipval{
//            self.ip=val
//        }else{
//            defaults.setObject("http://10.56.32.22/dthealth/web", forKey: "IP")
//        }
//        var url = ip+"/csp/dhc.nurse.pda.common.getdata.csp?className=NurEmr.Ipad.Common&methodName=getcurwardpat&type=Method"
//        let params=["wardId":locid]
//        var queue = dispatch_queue_create("getpatinfo", DISPATCH_QUEUE_SERIAL)
//        dispatch_sync(queue, {
//                Alamofire.request(.GET, url, parameters: params).responseString{
//                (_,_,string,_) in
//                print(string)
//                if let str=string{
//                    let astring = str.stringByReplacingOccurrencesOfString("\r\n", withString: "", options: [], range: nil) as NSString
//                    //println(astring)
//                    var data = astring.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
//                    var err=NSErrorPointer()
//                    let dic = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSArray
//                    if let arrs=dic{
//                        dispatch_async(dispatch_get_main_queue(),
//                            {
//                                 arr = BedModel.objectArrayWithKeyValuesArray(arrs) as! [BedModel]
//                        })
//                       
//                        //return arr
//                        
//                    }
//                }}
//        })
//        
//        
//        print(arr.count)
//        print(arr[0].PatName)
        return []
    }

}
