//
//  BGTableViewController.swift
//  NURBLSwift
//
//  Created by cyf on 15/5/1.
//  Copyright (c) 2015年 com.dhccnurse.cyf. All rights reserved.
//

import UIKit

class BGTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var headarray:[String]?
    var datarray=[NSDictionary]()
    var myHeadView:UIView?
    var myscrollview:UIScrollView?
    var myTableView:UITableView?
    var headh = 0
    var headdic = [String:String]()
    let reuseIdentifier = "BGCell"
    var headharr=[CGFloat]()
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    func getheadharr(){
        
        for (index,value) in enumerate(datarray){
            var maxh = CGFloat(0.0)
           for (key,val) in value{
              if let tmp=headdic[key as! String]{
                var text = val as! NSString
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
    override func viewDidLoad() {
        super.viewDidLoad()
        headarray = [
                     "145^37^0^0^1^0^0^S103^CareTime^时间","30^385^1^0^2^37^0^^^入量ml",
                     "30^185^2^0^5^422^0^^^出量ml","30^163^3^0^11^607^0^^^生命体征",
                     "115^298^9^1^2^37^30^S104^Item1^项目","115^43^10^1^3^335^30^S105^Item2^备用量",
                     "115^44^11^1^4^378^30^S106^Item3^实用量",
                     "115^32^12^1^5^422^30^S107^Item4^尿量","115^39^13^1^6^454^30^S107^Item31^",
                    ]
         datarray = [["Item1":"录华纳dssddddddddddddddddddddddfeee的顶顶顶顶顶顶顶顶顶","Item2":"100顶顶顶顶顶顶顶顶","CareTime":"12:00"],["Item1":"护理看看","Item2":"200","CareTime":"12:44","Item3":"400"]]
        var warr = headarray!.map({
         (var str)->Int in
            var tmparr = str.componentsSeparatedByString("^")
            var xp = tmparr[5].toInt()!
            var ww = tmparr[1].toInt()!
            var result = xp + ww
            var itm=tmparr[8]
            var val = tmparr[5] + "^" + tmparr[1]
            if tmparr[8] != ""
            {
              self.headdic[itm]=val
            }
            return result
        })
        var sortarr = sorted(warr,<)
        //表头宽度
        var headw = sortarr.last!
        var harr = headarray!.map({
            (var str)->Int in
            var tmparr = str.componentsSeparatedByString("^")
            var xp = tmparr[6].toInt()!
            var ww = tmparr[0].toInt()!
            var result = xp + ww
            return result
        })
        var sortarrh = sorted(harr,<)
        //表头高度
        headh = sortarrh.last!
        var screenw = UIScreen.mainScreen().bounds.width
        var screenh = UIScreen.mainScreen().bounds.height
        myHeadView = UIView(frame:CGRectMake(CGFloat(0), CGFloat(0), CGFloat(headw), CGFloat(headh)))
        for str in headarray! {
            var headview = HeadView(str: str)
            myHeadView?.addSubview(headview)
        }
        getheadharr()
        myscrollview = UIScrollView(frame: CGRectMake(0, 0, screenw, screenh))
        //myscrollview?.addSubview(myHeadView!)
        //myscrollview?.bounces = false
        myscrollview?.backgroundColor = UIColor.lightGrayColor()
        myscrollview?.contentSize = CGSizeMake(CGFloat(headw), CGFloat(headh))
        myTableView = UITableView(frame: CGRectMake(0, 0, CGFloat(headw), screenh), style: UITableViewStyle.Plain)
        myTableView?.delegate=self
        myTableView?.dataSource=self
        myTableView?.separatorStyle=UITableViewCellSeparatorStyle.None
        myscrollview?.addSubview(myTableView!)
        self.view.addSubview(myscrollview!)
        myscrollview!.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addConstraint(NSLayoutConstraint(item: myscrollview!, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: myscrollview!, attribute: .Top   , relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: myscrollview!, attribute: .Right   , relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: myscrollview!, attribute: .Bottom   , relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0))
        self.myTableView!.registerClass(BGCell.self, forCellReuseIdentifier: reuseIdentifier)
       
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
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! BGCell
        cell.contentView.backgroundColor = UIColor.whiteColor()
        cell.model=self.headdic
        cell.cheight=headharr[indexPath.row]
        cell.data = datarray[indexPath.row]
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
