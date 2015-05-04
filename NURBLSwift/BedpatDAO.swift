//
//  BedpatDAO.swift
//  NURBLSwift
//
//  Created by cyf on 15/4/25.
//  Copyright (c) 2015年 com.dhccnurse.cyf. All rights reserved.
//

import UIKit
import MJExtension
class BedpatDAO: NSObject {
    static let shareManagerobj:BedpatDAO = BedpatDAO()
    class func shareManager()->BedpatDAO{
        return shareManagerobj
    }
    func getbeddata(locid:NSString)-> NSArray? {
        //var arr = [BedModel]()
        var arrays = [Dictionary<String,String>]()
        for i in 1...100
        {
            var dic = ["PatName":"张三哈\(i)","PatSex":(i%2==0 ? "男":"女"),"PatAge":"\(i)"]
            arrays.append(dic)
           
        }
        var arr = BedModel.objectArrayWithKeyValuesArray(arrays) as! [BedModel]
        println(arr.count)
        println(arr[0].PatName)
        return arr
    }

}
