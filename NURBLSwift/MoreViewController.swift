//
//  FirstViewController.swift
//  NURBLSwift
//
//  Created by cyf on 15/4/14.
//  Copyright (c) 2015年 com.dhccnurse.cyf. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var btn = UIButton(frame: CGRectZero)
        btn.backgroundColor = UIColor.redColor()
        btn.setTitle("注销", forState: .Normal)
        btn.addTarget(self, action: Selector("btnclick"), forControlEvents:.TouchUpInside)
        self.view.addSubview(btn)
        btn.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addConstraint(NSLayoutConstraint(item: btn, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 10))
        self.view.addConstraint(NSLayoutConstraint(item: btn, attribute: .Top   , relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 50))
        self.view.addConstraint(NSLayoutConstraint(item: btn, attribute: .Right   , relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1.0, constant: -10))
        
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

