//
//  FeartureVC.swift
//  NURBLSwift
//
//  Created by cyf on 15/5/8.
//  Copyright (c) 2015年 com.dhccnurse.cyf. All rights reserved.
//

import UIKit

class FeartureVC: UIViewController {

    var screenw = UIScreen.mainScreen().bounds.width
    var screenh = UIScreen.mainScreen().bounds.height
    var scrollview:UIScrollView!
    var TitleArr=[[String:CGFloat]]()
    func initview(){
        var nh = screenw>screenh ? (screenh-76):(screenh-108)
        var yy = screenw>screenh ? CGFloat(32):CGFloat(64)
        scrollview = UIScrollView(frame: CGRectMake(0, 0, screenw, nh))
        scrollview.backgroundColor = UIColor.yellowColor()
        scrollview.contentSize = CGSizeMake(screenw,nh)
        //self.view.addSubview(scrollview)
        var toph = self.traitCollection.verticalSizeClass == .Compact ? CGFloat(32):CGFloat(44)
        var y:CGFloat = 10
        for itm in TitleArr{
            for val in itm.keys{
                var obj = UIButton(frame: CGRectMake(10, toph, screenw-20, itm[val]!))
                obj.setTitle(val, forState: .Normal)
                obj.setTitleColor(UIColor.redColor(), forState: .Highlighted)
                obj.reversesTitleShadowWhenHighlighted=true
                obj.addTarget(self, action: Selector("showhlbl:"), forControlEvents: .TouchUpInside)
                obj.backgroundColor=UIColor.blueColor()
                self.view.addSubview(obj)
                obj.snp_makeConstraints({(make)->Void in
                    make.top.equalTo(70)
                    make.centerX.equalTo(self.view)
                    make.right.equalTo(-10)
                    
                })
                y+=itm[val]!
            }
        }

    }
    func showhlbl(sender:UIButton){
       let dest = BLMainVC()
        dest.hidesBottomBarWhenPushed=true
        dest.title="护理病历"
        print(dest.supportedInterfaceOrientations())
        
       //presentViewController(dest, animated: true, completion: nil)
       showViewController(dest, sender: sender)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.hidesBottomBarWhenPushed=true
        TitleArr=[["护理病历":88]]
        self.view.backgroundColor = UIColor(red: 188/255, green: 133/255, blue: 1/255, alpha: 0.5)
        initview()
        
    }
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if newCollection.verticalSizeClass == .Compact{
           
        }
    }
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        screenw=size.width
        screenh=size.height
        var nh = size.width>size.height ? (size.height-76):(size.height-108)
        var yy = size.width>size.height ? CGFloat(32):CGFloat(64)
        //scrollview?.frame = CGRectMake(0, yy, CGFloat(size.width), nh)
        //scrollview?.contentSize = CGSizeMake(screenw,nh)
        //initview()
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
      
        //println(self.myTableView?.frame)
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
