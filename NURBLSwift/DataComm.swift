//
//  DataComm.swift
//  NURBLSwift
//
//  Created by cyf on 15/4/23.
//  Copyright (c) 2015年 com.dhccnurse.cyf. All rights reserved.
//

import UIKit

class DataComm: NSObject {
    let bedpatdao = BedpatDAO.shareManager()
    func getbeddata(locid:NSString)-> NSArray? {
       return bedpatdao.getbeddata(locid)
    }
}
