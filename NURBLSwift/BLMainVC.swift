//
//  BLMainVC.swift
//  NURBLSwift
//
//  Created by cyf on 15/5/8.
//  Copyright (c) 2015年 com.dhccnurse.cyf. All rights reserved.
//

import UIKit
//import Alamofire
//import MBProgressHUD

class BLMainVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var ltable:UITableView?
    var rtable:UITableView?
    var screenw = UIScreen.mainScreen().bounds.width
    var screenh = UIScreen.mainScreen().bounds.height
    let lreuseIdentifier="LCell"
    let rreuseIdentifier="RCell"
    var LData :NSArray?
    var RData :NSArray?
    var ip = "http://10.56.32.22/dthealth/web"
    var loc = "27"
    var selectadm = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        var defaults = NSUserDefaults.standardUserDefaults()
        
        var ipval = defaults.objectForKey("IP") as? String
        if let val=ipval{
           self.ip=val 
        }else{
           
           defaults.setObject("http://10.56.32.22/dthealth/web", forKey: "IP")
        }
        var locval = defaults.objectForKey("LOC") as? String
        if let val=locval{
            self.loc=val
        }else{
            
            defaults.setObject("27", forKey: "LOC")
        }

        self.view.backgroundColor=UIColor.whiteColor()
        ltable = UITableView(frame: CGRectMake(0, 0, screenw/3, screenh), style: .Plain)
        //ltable?.backgroundColor=UIColor.redColor()
        ltable?.separatorStyle = .None
        self.view.addSubview(ltable!)
        ltable!.delegate=self
        ltable!.dataSource = self
        self.ltable!.registerClass(UITableViewCell.self, forCellReuseIdentifier: lreuseIdentifier)
        rtable = UITableView(frame: CGRectMake(screenw/3+2, 64, screenw*2/3-4, screenh-64), style: .Plain)
        rtable?.backgroundColor=UIColor.yellowColor()
        self.view.addSubview(rtable!)
        rtable!.delegate=self
        rtable!.dataSource = self
        self.rtable!.registerClass(UITableViewCell.self, forCellReuseIdentifier: rreuseIdentifier)
        getcurwardpats(true)
        self.ltable?.addLegendHeaderWithRefreshingBlock({
            self.getcurwardpats(false)
        })
        self.rtable?.addLegendHeaderWithRefreshingBlock({
            if self.selectadm != ""
            {
               //self.getmenulist(self.selectadm,flag: "Y")
               self.getpatemrcodes(false)
            }
        })
        
       
    }
    //Mark:取所有病人
    func getcurwardpats(flag:Bool=false){
        if flag{
            //MBProgressHUD.showHUDAddedTo(self.ltable!, animated: true)
        }
        DataComm().getcurwardpats(self.loc, Hander: {
            dataresponse in
            var data = dataresponse.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            var err=NSErrorPointer()
            let dic = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSArray
            if self.ltable!.header.isRefreshing(){
                self.ltable!.header.endRefreshing()
            }
            if let arr=dic{
                if flag{
                    //MBProgressHUD.hideHUDForView(self.ltable!, animated: true)
                }
               
                self.LData = arr
                self.ltable?.reloadData()
                let obj = arr[0] as! NSDictionary
                let adms: AnyObject? = obj["EpisodeID"]
                var adm = ""
                if let dd: AnyObject=adms{
                    adm = "\(dd)"
                    self.selectadm = adm.stringByReplacingOccurrencesOfString("-", withString: "", options: [], range: nil)
                    //self.getmenulist(self.selectadm,flag: "N")
                    self.getpatemrcodes(true)
                }
            }
        })
    }
    //Mark:取病人所有模板webservice方式
    func getpatemrcodes(flag:Bool=false){
        if flag{
            MBProgressHUD.showHUDAddedTo(self.rtable!, animated: true)
        }
        DataComm().getpatemrcodes(self.loc,adm:self.selectadm, Hander: {
            dataresponse in
            let data = dataresponse.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            var err=NSErrorPointer()
            let dic = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves) as? NSArray
            if let arr=dic{
                if flag{
                    MBProgressHUD.hideHUDForView(self.rtable!, animated: true)
                }
                self.RData = dic
                self.rtable?.reloadData()
            }
            if self.rtable!.header.isRefreshing(){
                self.rtable!.header.endRefreshing()
            }
        })
    }
    //Mark:取病人http方式
    func getpatlist(flag:String)
    {
        var url = ip+"/csp/dhc.nurse.ipad.common.getdata.csp?className=NurEmr.Ipad.Common&methodName=getcurwardpat&type=Method"
        let params=["wardId":loc]
        
        Alamofire.request(.GET, url, parameters: params).responseString{
            (_,_,string,_) in
            print(string)
            if let str=string{
            let astring = str.stringByReplacingOccurrencesOfString("\r\n", withString: "", options: [], range: nil) as NSString
            //println(astring)
            var data = astring.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            var err=NSErrorPointer()
            let dic = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSArray
            self.LData = dic
            self.ltable?.reloadData()
            if let val=dic{
            let obj = val[0] as! NSDictionary
            let adms: AnyObject? = obj["EpisodeID"]
            var adm = ""
            if let dd: AnyObject=adms{
                  adm = "\(dd)"
            }else{
                
            }
            //var adm = "\(obj["EpisodeID"])" // as! String
            self.selectadm = adm.stringByReplacingOccurrencesOfString("-", withString: "", options: [], range: nil)
            self.getmenulist(self.selectadm,flag: "N")
            
            }else{
               
            }
            
            
            //println(dic)
            }else{
            
            }
            if (flag=="N")
            {
                MBProgressHUD.hideHUDForView(self.ltable, animated: true)
            }else{
                self.ltable?.header.endRefreshing()
            }
        }
    }
    //取模板列表
    func getmenulist(Sadm:String,flag:String)
    {
        if flag=="N"
        {
           MBProgressHUD.showHUDAddedTo(self.rtable, animated: true)
        }
        var url = ip+"/csp/dhc.nurse.pda.common.getdata.csp?className=NurEmr.Ipad.Common&methodName=getemrcode&type=Method"
        let param=["Adm":Sadm,"Loc":loc]
        Alamofire.request(.GET, url, parameters: param).responseString{  (_,_,string,_) in
            let astring = string!.stringByReplacingOccurrencesOfString("\r\n", withString: "", options: [], range: nil) as NSString
            //println(astring)
            var data = astring.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            var err=NSErrorPointer()
            let dic = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves) as? NSArray
            self.RData = dic
            self.rtable?.reloadData()
            if flag=="N"{
                MBProgressHUD.hideHUDForView(self.rtable, animated: true)
            }else{
                self.rtable?.header.endRefreshing()
            }
            //println(dic)
        }
    }
    

    //取模板信息
    func getemrcode(code:String)
    {
        var url = ip+"/csp/dhc.nurse.pda.common.getdata.csp?className=NurEmr.Ipad.Common&methodName=getcodexml&type=Method"
        let params=["code":"DHCNURXH2"]
        let request = Alamofire.request(.GET,url,parameters:params).responseString{
            (_,_,string,_) in
            print(string)
            let astring = string?.stringByReplacingOccurrencesOfString("\r\n", withString: "", options: [], range: nil)
            print(astring)
            
        }
        //debugPrintln(request)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       if tableView == ltable!{
        return 1
        }
       else{
        if let dd=RData{
            return dd.count
        }else{
            return 1
        }
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ltable!{
            if let dd=LData{
                return dd.count
            }else{
                return 30
            }
        }else{
            if let dd=RData{
                return dd[section].count
                
            }else{
                return 0
            }
        }
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
         if tableView == ltable!{
         }else{
        
        if let _ = RData{
            let obj = RData![section] as! NSDictionary
            title = obj["NodName"] as! String
        }
        
        
        }
        return title
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == ltable!{
            var cell = tableView.dequeueReusableCellWithIdentifier(lreuseIdentifier)! as UITableViewCell
            if let dd=LData{
            let obj = dd[indexPath.row] as! NSDictionary
            cell.textLabel?.text = obj["PatName"]  as? String
            let bedcode = obj["bedCode"] as? String
            cell.detailTextLabel?.text = bedcode
            }
            return cell
        }else{
            var cellr = tableView.dequeueReusableCellWithIdentifier(rreuseIdentifier) as! UITableViewCell
            cellr.textLabel?.text = "\(indexPath.row)"
            if let dd=RData{
            let obj = dd[indexPath.section] as! NSDictionary
            let subobj = obj["subnod"] as! NSArray
            let sub = subobj[indexPath.row] as! NSDictionary
            cellr.textLabel?.text = sub["EmrCodeName"]?.description
            cellr.textLabel?.font = UIFont(name: "System.System", size: 12.0)
            var ifsaved = sub["IfSaved"]?.description
            cellr.detailTextLabel?.text = ifsaved
            if ifsaved != "" {
                cellr.textLabel?.textColor = UIColor.blueColor()
            }
            else{
                cellr.textLabel?.textColor = UIColor.redColor()
            }
            cellr.accessoryType = UITableViewCellAccessoryType.None
            }
            return cellr
        }
    }
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        var titlearr = [NSString]()
        if let ti = RData{
            for itm in ti {
                let obj = itm as! NSDictionary
                let title = obj["NodName"] as! NSString
                let range = NSRange(location: 0, length: 1)
                let name = title.substringWithRange(range)
                titlearr.append(name)
            }
            //titlearr.append(itmname)
        }
        return titlearr
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == ltable!{
          rowclick(indexPath)
        }else{
          stableclick(indexPath)
        }
    }
    //选择病人
    func rowclick(indexPath:NSIndexPath)
    {
        if let dd=LData{
        let obj = dd[indexPath.row] as! NSDictionary
        var tmpadm: AnyObject? = obj["EpisodeID"]
        var adm = ""
        if let tmp: AnyObject=tmpadm{
           adm = "\(tmp)"
           adm = adm.stringByReplacingOccurrencesOfString("-", withString: "", options: [], range: nil)
           selectadm = adm
           self.getpatemrcodes(true)
        }
       
            //getmenulist(adm,flag:"N")
        }
    }
    //MARK:选择某个模板
    func stableclick(indexPath:NSIndexPath)
    {
        let obj = RData![indexPath.section] as! NSDictionary
        let subobj = obj["subnod"] as! NSArray
        let sub = subobj[indexPath.row] as! NSDictionary
        let code = sub["EmrCode"] as? String
        let dest = BGTableViewController()
        dest.ip = ip
        dest.code = code!
        dest.adm = selectadm
        presentViewController(dest, animated: true, completion: nil)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
