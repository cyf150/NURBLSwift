//
//  DataComm.swift
//  NURBLSwift
//
//  Created by cyf on 15/4/23.
//  Copyright (c) 2015年 com.dhccnurse.cyf. All rights reserved.
//

import UIKit
//import MBProgressHUD
class DataComm: NSObject {
    let bedpatdao = BedpatDAO.shareManager()
    func getbeddata(locid:NSString)-> NSArray? {
       return bedpatdao.getbeddata(locid)
    }
    //mark: 根据病区科室id取所有病人
    func getcurwardpats(loc:NSString,Hander:(data:AnyObject) throws->Void){
        let dic = ["parameter1":loc]
        HttpUtil().soapExcute("NurEmr.Ipad.Common", method: "getcurwardpat", paramdic: dic, CompletinonHander: {
            response in
            try Hander(data: response)
        })
    }
    //mark: 根据病人所有模板
    func getpatemrcodes(loc:NSString,adm:NSString,Hander:(data:AnyObject)->Void){
        let dic = ["parameter1":adm,"parameter2":loc]
        HttpUtil().soapExcute("NurEmr.Ipad.Common", method: "getemrcode", paramdic: dic, CompletinonHander: {
            response in
            Hander(data: response)
        })
    }
    //mark: 根据病人模板所有数据
    func getadmemrcodedata(parr:NSString,Hander:(data:AnyObject)->Void){
        let dic = ["parameter1":parr]
        HttpUtil().soapExcute("NurEmr.Ipad.Common", method: "getadmemrcodedata", paramdic: dic, CompletinonHander: {
            response in
            Hander(data: response)
        })
    }

}
