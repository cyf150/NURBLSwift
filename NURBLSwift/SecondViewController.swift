//
//  SecondViewController.swift
//  NURBLSwift
//
//  Created by cyf on 15/4/14.
//  Copyright (c) 2015年 com.dhccnurse.cyf. All rights reserved.
//

import UIKit
import Alamofire
class SecondViewController: UIViewController {

    @IBAction func click(sender: AnyObject) {
        var destvc = BGTableViewController()
        self.showViewController(destvc, sender: nil)
    }
    @IBOutlet weak var testclick: UIButton!
    @IBOutlet weak var textview2: UITextView!
    @IBOutlet weak var textview: UILabel!
    @IBOutlet weak var intro: UIActivityIndicatorView!
    @IBAction func find(sender: UIButton) {
        
        Alamofire.request(.GET, "http://httpbin.org/get")
        Alamofire.request(.GET, "http://httpbin.org/get", parameters: ["foo": "bar"])
            .response { (request, response, data, error) in
                //println(request)
               // println(response)
                //println(error)
        }
        Alamofire.request(.GET, "http://www.baidu.com")
            .responseString { (_, _, string, _) in
               // println(string)
                self.textview2.text = string!
            }
            .responseJSON { (_, _, JSON, _) in
                println(JSON)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func unwindsegue(sender:UIStoryboardSegue)
    {
    
    }


}

