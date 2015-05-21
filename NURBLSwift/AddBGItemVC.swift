//
//  AddBGItemVC.swift
//  NURBLSwift
//
//  Created by cyf on 15/5/7.
//  Copyright (c) 2015年 com.dhccnurse.cyf. All rights reserved.
//

import UIKit

class AddBGItemVC: UIViewController {

    var model=[[NSString:AnyObject]]()
    var itmarray=[String]()
    var datadic=[String:String]()
    var headmodel=[String:String]()
    var parentobj:BGTableViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        println(headmodel)
        model=[["D102":"日期"],["D103":"时间"],["G104":"项目"],["S105":"脉搏是"],["S106":"脉搏程看"],["S107":"脉搏擦擦擦"]]
        initview()
        self.view.backgroundColor=UIColor.lightTextColor()

        // Do any additional setup after loading the view.
    }
    func initview(){
        var xmargin = CGFloat(5)
        var ymargin = CGFloat(5)
        var y = CGFloat(10)
        println(self.view.frame)
        println(self.presentedViewController)
        var lw = CGFloat(self.view.bounds.width/2)
        var lh = CGFloat(20)
        var lablew=CGFloat(10)
        var lableh=CGFloat(10)
        for val in model{
            for itm in val.values{
                var itmstring = itm as! NSString
                var size = itmstring.boundingRectWithSize(CGSizeMake(100, 100), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [:], context: NSStringDrawingContext())
                if size.width > lablew
                {
                    lablew=size.width
                }
                if size.height > lableh
                {
                    lableh = size.height
                }
            }
        }
        lableh*=1.5
        lablew*=1.5
        var num=0
        for (index,dic) in enumerate(model){
            for itm in dic.keys{
               var text = dic[itm] as! NSString
               var firstchar = itm.substringToIndex(1)
                switch(firstchar){
                  case "D":
                    println("D")
                  case "S":
                    var label=UILabel(frame: CGRectMake(xmargin, y, lablew, lableh))
                    label.text = text as String
                    self.view.addSubview(label)
                    var textfield = UITextField(frame: CGRectMake(lablew+xmargin+5, y, lablew, lableh))
                    textfield.layer.borderColor = UIColor.blackColor().CGColor
                    textfield.layer.borderWidth = 1
                    textfield.backgroundColor=UIColor.redColor()
                    textfield.tag=num+10000
                    self.view.addSubview(textfield)
                    self.itmarray.append(itm as String)
                    num+=1
                    y+=lableh + ymargin
                  case "G":
                    var ratio = CGFloat(4)
                    var label=UILabel(frame: CGRectMake(xmargin, y, lablew, lableh))
                    label.text = text as String
                    self.view.addSubview(label)
                    var textview=UITextView(frame: CGRectMake(lablew+xmargin+5, y, lablew, lableh*ratio))
                    self.view.addSubview(textview)
                    textview.layer.borderColor = UIColor.blackColor().CGColor
                    textview.layer.borderWidth = 1.0
                    textview.tag=num+10000
                    self.itmarray.append(itm as String)
                    num+=1
                    y+=ymargin + lableh*ratio
                default :
                    println("none")
                    
                }
            }
        }
        var btnsave=UIButton(frame: CGRectMake(xmargin, y+ymargin, 100, 20))
        btnsave.setTitle("保存", forState: .Normal)
        btnsave.backgroundColor=UIColor.greenColor()
        btnsave.addTarget(self, action: Selector("Save"), forControlEvents: .TouchUpInside)
        self.view.addSubview(btnsave)
        
    }
    func Save(){
        for (index,itm) in enumerate(itmarray){
            var val=""
            var obj=self.view.viewWithTag(index+10000)
            if obj is UITextView {
               val = (obj as! UITextView).text
            }
            if obj is UITextField {
                val = (obj as! UITextField).text
            }
            var itmname=headmodel[itm as String]
            if let itmn=itmname{
                 datadic[itmn] = val
            }
            //println(itm)
        }
        //println(self.presentingViewController)
        self.dismissViewControllerAnimated(true, completion: {
            if let obj = self.parentobj{
                obj.datarray.append(self.datadic)
                obj.getheadharr()
                obj.myTableView?.reloadData()
            }
        })
        println(datadic)
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
