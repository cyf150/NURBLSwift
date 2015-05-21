//
//  BGTableViewController.swift
//  NURBLSwift
//
//  Created by cyf on 15/5/1.
//  Copyright (c) 2015年 com.dhccnurse.cyf. All rights reserved.
//

import UIKit
import MJRefresh
import Alamofire
import MBProgressHUD

class BGTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UINavigationBarDelegate,UIPopoverPresentationControllerDelegate,UIPopoverControllerDelegate {

    var headarray:[String]?
    var datarray = [NSDictionary]()
    var headmodel=[String:String]()
    var myHeadView:UIView?
    var myscrollview:UIScrollView?
    var myTableView:UITableView?
    var headh = 0
    var headdic = [String:String]()
    let reuseIdentifier = "BGCell"
    var headharr=[CGFloat]()
    var navbar:UINavigationBar?
    var headw = 0
    var contentw=CGFloat(0)
    var screenw = UIScreen.mainScreen().bounds.width
    var screenh = UIScreen.mainScreen().bounds.height
    var ip = ""
    var code = ""
    var adm = ""
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    //program mark 计算每条记录高度
    func getheadharr(){
        headharr = [CGFloat]()
        for (index,value) in enumerate(datarray){
            var maxh = CGFloat(0.0)
           for (key,val) in value{
              if let tmp=headdic[key as! String]{
                var text = "\(val)"
                var arr = tmp.componentsSeparatedByString("^")
                var size = text.boundingRectWithSize(CGSizeMake(CGFloat(arr[1].toInt()!), 0), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [:], context: NSStringDrawingContext())
                if size.height > maxh
                {
                    maxh=size.height
                }
             }
           }
           headharr.append(maxh+15)
        }
    }
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        var wn = size.width>CGFloat(headw) ? size.width:CGFloat(headw)
        self.myTableView?.frame = CGRectMake(0, 0,wn , size.height-44)
        self.myscrollview?.frame=CGRectMake(0, 0, size.width, size.height)
        self.navbar?.frame=CGRectMake(0, 0, size.width, 44)
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        self.myTableView?.reloadData()
        //println(self.myTableView?.frame)
    }
    func close()
    {
       println("4444")
       self.dismissViewControllerAnimated(true, completion: nil)
    }
    func edit()
    {
        if myTableView?.editing == true {
            myTableView?.setEditing(false, animated: true)
        }else{
            myTableView?.setEditing(true, animated: true)
        }
    }
    func add(sender:UIBarButtonItem)
    {
        var descon =  AddBGItemVC()
        //descon.data = logoninfo?.LocArray
        //descon.pVC = self
       
        descon.modalPresentationStyle = .Popover
        let popovercontroller = descon.popoverPresentationController
        popovercontroller?.barButtonItem = sender        
        popovercontroller?.permittedArrowDirections = .Any
        popovercontroller?.delegate = self
        descon.headmodel=self.headmodel
        descon.parentobj = self
        //descon.modalInPopover=true
        presentViewController(descon, animated: true, completion: nil)
        println(self.presentedViewController?.presentationController?.frameOfPresentedViewInContainerView())
    }
   
    func search()
    {
       
       
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle{
        return UIModalPresentationStyle.None
    }
    func initbar(){
        self.view.backgroundColor=UIColor.whiteColor()
        //加载NavigationBar
        navbar = UINavigationBar(frame: CGRectMake(0, 0, screenw, 44))
        navbar?.barStyle = .BlackTranslucent
        var navitm = UINavigationItem(title: "危重护理记录单")
        var btnclose = UIBarButtonItem(barButtonSystemItem: .Done, target: nil, action: Selector("close"))
        btnclose.style = .Plain
        btnclose.tintColor = UIColor.redColor()
        var btnadd = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("add:"))
        btnadd.tintColor = UIColor.greenColor()
        var btnedit = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: Selector("edit"))
        btnedit.tintColor=UIColor.whiteColor()
        var btnsearch = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: Selector("search"))
        navitm.setLeftBarButtonItems([btnclose,btnedit], animated: true)
        navitm.setRightBarButtonItems([btnadd,btnsearch], animated: true)
        navitm.leftItemsSupplementBackButton=true
        navbar?.pushNavigationItem(navitm, animated: true)
        self.view.addSubview(navbar!)
        navbar?.setItems([navitm], animated: true)

    }
    //加载view
    func initview(){
               //navbar?.delegate=self
        //加载scrollview及tableview
        myHeadView = UIView(frame:CGRectMake(CGFloat(0), CGFloat(0), CGFloat(headw), CGFloat(headh)))
        for str in headarray! {
            var headview = HeadView(str: str)
            myHeadView?.addSubview(headview)
        }
        contentw = CGFloat(headw)>screenw ? CGFloat(headw):screenw
        myscrollview = UIScrollView(frame: CGRectMake(0, 0, contentw, screenh))
        myscrollview?.backgroundColor = UIColor.lightGrayColor()
        myscrollview?.pagingEnabled=false
        myscrollview?.contentSize = CGSizeMake(CGFloat(headw), CGFloat(headh))
        myscrollview?.bounces=false
        myscrollview?.delegate=self
        myscrollview?.canCancelContentTouches=true
        myTableView = UITableView(frame: CGRectMake(0, 0, contentw, screenh-44), style: UITableViewStyle.Plain)
        myTableView?.delegate=self
        myTableView?.dataSource=self
        myTableView?.separatorStyle=UITableViewCellSeparatorStyle.None
        myscrollview?.addSubview(myTableView!)
        self.view.addSubview(myscrollview!)
        myscrollview!.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addConstraint(NSLayoutConstraint(item: myscrollview!, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: myscrollview!, attribute: .Top   , relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 44))
        self.view.addConstraint(NSLayoutConstraint(item: myscrollview!, attribute: .Right   , relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: myscrollview!, attribute: .Bottom   , relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0))
        
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        println(scrollView.contentOffset)
        if scrollView.contentOffset.x == contentw-screenw{
           myscrollview?.touchesShouldCancelInContentView(myTableView)
        }
    }
    //Program Mark 计算表头宽高
    func gettablewh(){
        var warr = headarray!.map({
            (var str)->Int in
            var result = 0
            if str != ""
            {
            var tmparr = str.componentsSeparatedByString("^")
            var xp = tmparr[5].toInt()!
            var ww = tmparr[1].toInt()!
            result = xp + ww
            var itm=tmparr[8]
            var val = tmparr[5] + "^" + tmparr[1]
            if tmparr[8] != ""
            {
                self.headdic[itm]=val
                self.headmodel[tmparr[7] as String] = tmparr[8] as String
            }
            }
            return result
        })
        var sortarr = sorted(warr,<)
        //表头宽度
        headw = sortarr.last!
        var harr = headarray!.map({
            (var str)->Int in
            var result=0
            if str != ""
            {
            var tmparr = str.componentsSeparatedByString("^")
            var xp = tmparr[6].toInt()!
            var ww = tmparr[0].toInt()!
            result = xp + ww
            }
            return result
        })
        var sortarrh = sorted(harr,<)
        //表头高度
        headh = sortarrh.last!
    }
    //加载表头及数据
    func initBG()
    {
        var url = ip+"/csp/dhc.nurse.pda.common.getdata.csp?className=NurEmr.Ipad.Common&methodName=getcodexml&type=Method"
        let params=["code":code]
        let request = Alamofire.request(.GET,url,parameters:params).responseString{
            (_,_,string,_) in
            println(string)
            let astring = string?.stringByReplacingOccurrencesOfString("\r\n", withString: "", options: nil, range: nil)
            //let astring = string?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            self.headarray = astring?.componentsSeparatedByString("|")
            self.headarray?.removeLast()
            self.initbar()
            if self.headarray?.count>0{
              self.showview()
            }
          
        }
        //debugPrintln(request)
    }
    func showview(){
    
        self.datarray = [["Item1":"1  录华纳dssddddddddddddddddddddddfeee的顶顶顶顶顶顶顶顶顶","Item2":"100顶顶顶顶顶顶顶顶","CareTime":"12:00"],["Item1":"2  护理看看","Item2":"200","CareTime":"12:44","Item3":"400"],["Item1":"3  护理看看","Item2":"200","CareTime":"12:44","Item3":"400"],["Item1":"4  录华纳dssddddddddddddddddddddddfeee的顶顶顶顶顶顶顶顶顶","Item2":"100顶顶顶顶顶顶顶顶","CareTime":"12:00"],["Item1":"5  护理看看","Item2":"200","CareTime":"12:44","Item3":"400"],["Item1":"6  录华纳dssddddddddddddddddddddddfeee的顶顶顶顶顶顶顶顶顶","Item2":"100顶顶顶顶顶顶顶顶","CareTime":"12:00"],["Item1":"7  护理看看","Item2":"200","CareTime":"12:44","Item3":"400"],["Item1":"8  录华纳dssddddddddddddddddddddddfeee的顶顶顶顶顶顶顶顶顶","Item2":"100顶顶顶顶顶顶顶顶","CareTime":"12:00"],["Item1":"9  护理看看","Item2":"200","CareTime":"12:44","Item3":"400"]]
        self.gettablewh()
        self.getheadharr()
        self.initview()
        self.myTableView!.registerClass(BGCell.self, forCellReuseIdentifier: self.reuseIdentifier)
        //self.getdata()
        self.myTableView?.addLegendHeaderWithRefreshingBlock({
            self.getdata("Y")
        })
        getdata("N")

    }
    func getdata(flag:String){
        if flag=="N"{
           MBProgressHUD.showHUDAddedTo(self.myTableView, animated: true)
        }
        var url = ip+"/csp/dhc.nurse.pda.common.getdata.csp?className=NurEmr.Ipad.Common&methodName=getadmemrcodedata&type=Method"
        let params=["Adm":adm,"EmrCode":code]
        Alamofire.request(.GET, url, parameters: params).responseString{  (_,_,string,_) in
            let astring = string!.stringByReplacingOccurrencesOfString("\r\n", withString: "", options: nil, range: nil) as NSString
            println(astring)
            var data = astring.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            var err=NSErrorPointer()
            let dic = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves, error: err) as? NSArray
            if let val=dic{
            self.datarray = val as! [(NSDictionary)]
            self.getheadharr()
            self.myTableView?.reloadData()
            }else{
                var alert = UIAlertController(title: "提示", message:"加载数据出错",preferredStyle:.Alert)
                var action1 = UIAlertAction(title: "确定", style:.Default, handler: {(UIAlertAction) in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                alert.addAction(action1)
                self.presentViewController(alert, animated: true, completion: nil)
            }
            if (flag=="Y"){
                self.myTableView?.header.endRefreshing()
            }else{
               MBProgressHUD.hideHUDForView(self.myTableView, animated: true)
            }
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initBG()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datarray.count
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.myHeadView!
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(headh)
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return headharr[indexPath.row]
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            datarray.removeAtIndex(indexPath.row)
            headharr.removeAtIndex(indexPath.row)
            myTableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    //func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
    //    return ["hahah"]
    //}1`
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "删除"
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! BGCell
        cell.contentView.clearsContextBeforeDrawing=true
        cell.contentView.backgroundColor = UIColor.whiteColor()
        cell.model=self.headdic
        cell.cheight=headharr[indexPath.row]
        cell.data = datarray[indexPath.row]
        println("\(indexPath.row)" )
        return cell
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
