//
//  LogonDAO.swift
//  NURBLSwift
//
//  Created by cyf on 15/4/25.
//  Copyright (c) 2015年 com.dhccnurse.cyf. All rights reserved.
//

import UIKit

class LogonDAO: NSObject {
   static let shareManagerobj:LogonDAO = LogonDAO()
   class func shareManager()->LogonDAO{
       return shareManagerobj
    }
    func getbeddata(locid:NSString)-> NSArray? {
        var arr = [BedModel]()
        
        for i in 1...100
        {
            var bed =  BedModel()
            bed.PatName = "张三\(i)"
            if i%2 == 0
            {
                bed.PatSex = "男"
            }else{
                bed.PatSex = "女"
            }
            bed.PatAge = "\(i)"
            arr.append(bed)
        }
        return arr
    }

}
