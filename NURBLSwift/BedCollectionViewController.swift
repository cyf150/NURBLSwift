//
//  BedCollectionViewController.swift
//  NURBLSwift
//
//  Created by cyf on 15/4/20.
//  Copyright (c) 2015年 com.dhccnurse.cyf. All rights reserved.
//

import UIKit
import MBProgressHUD
import MJRefresh
import Alamofire

let reuseIdentifier = "BedCell"

class BedCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {

    var data:NSArray?
    var DataDao:DataComm?
    var logo:LogonModel!
    var ip=""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MBProgressHUD.showHUDAddedTo(self.collectionView, animated: true)
        self.DataDao = DataComm()
        self.logo = LogonModel()
        logo.logonloc = "98"
        
        var queue = dispatch_queue_create("myqueue1", DISPATCH_QUEUE_SERIAL)
        dispatch_sync(queue, {
            //self.getdata()
            self.getcurwardpats(flag:true)
            //self.data = self.DataDao?.getbeddata(self.logo.logonloc)
        })
        //self.data = DataDao?.getbeddata(self.logo.logonloc)
        //MBProgressHUD.hideHUDForView(self.collectionView, animated: true)
        self.collectionView?.addLegendHeaderWithRefreshingBlock({
            self.getcurwardpats()
        })
        // Register cell classes
        self.collectionView!.registerClass(BedViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        // Do any additional setup after loading the view.
    }
    func gettime()->Int{
      var date = NSDate()
      var calendar = NSCalendar.currentCalendar()
      var unitflag = NSCalendarUnit.CalendarUnitSecond|NSCalendarUnit.CalendarUnitMinute
      var datecomponet = calendar.components(unitflag, fromDate: date)
      return datecomponet.second
    }
    func getcurwardpats(flag:Bool=false){
        if flag{
           MBProgressHUD.showHUDAddedTo(self.collectionView, animated: true)
        }
        DataComm().getcurwardpats(self.logo.logonloc, Hander: {
            response in
            if flag{
                MBProgressHUD.hideHUDForView(self.collectionView, animated: true)
            }
            var type=response as? NSString
            if let tt=type{
            var data = response.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            var err=NSErrorPointer()
            let dic = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: err) as? NSArray
            if let arrs=dic{
                self.data = BedModel.objectArrayWithKeyValuesArray(arrs) as! [BedModel]
                self.collectionView?.reloadData()
             }
            }else{
                var alert = UIAlertController(title: "提示", message:response.localizedDescription,preferredStyle:.Alert)
                var action1 = UIAlertAction(title: "确定", style:.Default, handler: {(UIAlertAction) in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                alert.addAction(action1)
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            if self.collectionView!.header.isRefreshing(){
                self.collectionView!.header.endRefreshing()
            }
        })
    }

    func getsoapdataback(){
        var dic = ["parameter1":self.logo.logonloc]
        MBProgressHUD.showHUDAddedTo(self.collectionView, animated: true)
        HttpUtil().soapExcute("NurEmr.Ipad.Common", method: "getcurwardpat", paramdic: dic, CompletinonHander: {
            response in
            var data = response.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            var err=NSErrorPointer()
            let dic = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: err) as? NSArray
            if let arrs=dic{
                MBProgressHUD.hideHUDForView(self.collectionView, animated: true)
                self.data = BedModel.objectArrayWithKeyValuesArray(arrs) as! [BedModel]
                self.collectionView?.reloadData()
            }

        })
    }
    func getsoapdata22(){
        var url = "http://10.160.16.91/dthealth/web/DWR.NurseEmrComm.cls"
        var filename = "DWR.NurseEmrComm"
        var methodName = "Excute"
        var mydic = ["parameter1":"98"]
        var dicstring = NSJSONSerialization.dataWithJSONObject(mydic, options: NSJSONWritingOptions.allZeros, error: nil)
        var str = NSString(data: dicstring!, encoding: 4) as? String
        //var start=gettime()
        if let dd=str{
            var dic = ["clsName":"NurEmr.Ipad.Common","methodName":"getcurwardpat","parameters":dd]
            var soaputility = SoapUtility(fromFile: filename)
            var postData = soaputility.BuildSoapwithMethodName(methodName, withParas: dic)
            var soaprequest = SoapService()
            soaprequest.PostUrl = url
            soaprequest.SoapAction = soaputility.GetSoapActionByMethodName(methodName, soapType: SOAP)
            //var responseData = soaprequest.PostSync(postData, methodName: methodName)
            soaprequest.PostAsync(postData, methodName: methodName, success:{ str in
                //var  end=self.gettime()
                //println(end-start)
                var data = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                var flag = NSJSONSerialization.isValidJSONObject(str)
                var err=NSErrorPointer()
                let dic = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: err) as? NSArray
                if let arrs=dic{
                    dispatch_async(dispatch_get_main_queue(),
                        {
                            self.data = BedModel.objectArrayWithKeyValuesArray(arrs) as! [BedModel]
                            self.collectionView?.reloadData()
                    })}else{
                     println(err.debugDescription)
                   }
                }, falure: {
                    err in
            })
        }
       

    }
    func getdata(){
        
        var defaults = NSUserDefaults.standardUserDefaults()
        var ipval = defaults.objectForKey("IP") as? String
        if let val=ipval{
            self.ip=val
        }else{
            defaults.setObject("http://10.56.32.22/dthealth/web", forKey: "IP")
        }
        var tmpurl = ip+"/dthealth/web/DWR.NurseEmrComm.cls?wsdl"
        Alamofire.request(.GET,tmpurl).responseString{
            (_,_,string,_) in println(string)
        }
        var url = ip+"/csp/dhc.nurse.pda.common.getdata.csp?className=NurEmr.Ipad.Common&methodName=getcurwardpat&type=Method"
        let params=["wardId":self.logo.logonloc]
        var start=gettime()
        var queue = dispatch_queue_create("getpatinfo", DISPATCH_QUEUE_SERIAL)
        dispatch_sync(queue, {
            Alamofire.request(.GET, url, parameters: params).responseString{
                (_,_,string,_) in
                //println(string)
                var  end=self.gettime()
                println(end-start)
                if let str=string{
                    let astring = str.stringByReplacingOccurrencesOfString("\r\n", withString: "", options: nil, range: nil) as NSString
                    //println(astring)
                    var data = astring.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    var err=NSErrorPointer()
                    let dic = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: err) as? NSArray
                    if let arrs=dic{
                    dispatch_async(dispatch_get_main_queue(),
                    {
                        self.data = BedModel.objectArrayWithKeyValuesArray(arrs) as! [BedModel]
                        self.collectionView?.reloadData()
                    })
                        
                        //return arr
                        
                    }
                }}
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        if var dd=data{
          return dd.count
        }
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:BedViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! BedViewCell
        //cell.contentView.backgroundColor = UIColor.blueColor()
        //cell.lable.text = String(indexPath.row)
        cell.backgroundColor = UIColor.yellowColor()
        //cell.img.backgroundColor=UIColor.yellowColor()
        //cell.lables.text = "text"
        if let havedata=data{
        var bedmodel = data![indexPath.row] as! BedModel
        cell.data = bedmodel
        //var textv = UILabel(frame: CGRectMake(0, 0, cell.bounds.width, 10))
        //textv.text = "KKKDDL"
        //cell.contentView.addSubview(textv)
        }
        
        return cell
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let dd=data{
        let smodel = data![indexPath.row] as! BedModel
        let adm = smodel.EpisodeID
        println(adm)
        var dest = BLMainVC()
        dest.hidesBottomBarWhenPushed=true
        dest.title="护理病历"
        println(dest.supportedInterfaceOrientations())
        //presentViewController(dest, animated: true, completion: nil)
        showViewController(dest, sender: nil)
        }
        
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var size = CGSizeMake(100, 100)
        return size
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
