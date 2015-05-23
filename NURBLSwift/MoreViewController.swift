//
//  FirstViewController.swift
//  NURBLSwift
//
//  Created by cyf on 15/4/14.
//  Copyright (c) 2015年 com.dhccnurse.cyf. All rights reserved.
//

import UIKit
import SnapKit

class MoreViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var LocID: UITextField!
    @IBOutlet weak var IPText: UITextField!
    @IBAction func SaveIP(sender: UIButton) {
        var textval = IPText.text=="" ? IPText.placeholder:IPText.text
        var locval = LocID.text=="" ? LocID.placeholder:LocID.text
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(textval, forKey: "IP")
        defaults.setObject(locval, forKey: "LOC")
        var alert = UIAlertController(title: "提示", message:"保存成功",preferredStyle:.Alert)
        var action1 = UIAlertAction(title: "确定", style:.Default, handler: {(UIAlertAction) in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        var action2 = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        
        //alert.addAction(action2)
        alert.addAction(action1)
        presentViewController(alert, animated: true, completion: nil)
        println(defaults.objectForKey("LOC"))
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        LocID.resignFirstResponder()
        IPText.resignFirstResponder()
        return true
    }
    @IBAction func bgtest(sender: AnyObject) {
        var destvc = BGTableViewController()
        self.presentViewController(destvc, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var defaults = NSUserDefaults.standardUserDefaults()
        var ipval = defaults.objectForKey("IP") as? String
        if let val=ipval{
          IPText.text = val
        }
        var locval = defaults.objectForKey("LOC") as? String
        if let val=locval{
            LocID.text = val
        }
        var btn = UIButton(frame: CGRectZero)
        btn.backgroundColor = UIColor.redColor()
        btn.setTitle("注销", forState: .Normal)
        btn.addTarget(self, action: Selector("btnclick"), forControlEvents:.TouchUpInside)
        self.view.addSubview(btn)
        println(self.topLayoutGuide)
        btn.snp_makeConstraints({(make)->Void in
             //make.width.equalTo(150)
             //make.height.equalTo(50)
             //make.top.equalTo(22)
             //make.center.equalTo(self.view)
             //make.right.equalTo(self.view).offset(-5)
               make.top.equalTo(self.view).offset(self.topLayoutGuide.length)
             //make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(5,50,44,5))
        })
        self.view.layoutSubviews()
        println(btn.frame)
//        btn.setTranslatesAutoresizingMaskIntoConstraints(false)
//        self.view.addConstraint(NSLayoutConstraint(item: btn, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 10))
//        self.view.addConstraint(NSLayoutConstraint(item: btn, attribute: .Top   , relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 50))
//        self.view.addConstraint(NSLayoutConstraint(item: btn, attribute: .Right   , relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1.0, constant: -10))
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func btnclick()
    {
        var alert = UIAlertController(title: "注销", message:"确定要注销？",preferredStyle:.Alert)
        var action1 = UIAlertAction(title: "确定", style:.Default, handler: {(UIAlertAction) in
           self.dismissViewControllerAnimated(true, completion: nil)
        })
        var action2 = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        
        alert.addAction(action2)
        alert.addAction(action1)
        presentViewController(alert, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

