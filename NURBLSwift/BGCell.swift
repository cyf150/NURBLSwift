//
//  BGCell.swift
//  NURBLSwift
//
//  Created by cyf on 15/5/4.
//  Copyright (c) 2015年 com.dhccnurse.cyf. All rights reserved.
//

import UIKit
import QuartzCore
class BGCell: UITableViewCell {

    var model=[String:String]()
    var cheight = CGFloat(0)
    var data:NSDictionary{
        willSet{
        
        }
        didSet{
            //self.contentView.clearsContextBeforeDrawing=true
            for obj in self.contentView.subviews{
               obj.removeFromSuperview()
            }
            for (key,val) in data{
                if let tmp=model[key as! String]{
                    
                    var text = "\(val)"
                    var arr = tmp.componentsSeparatedByString("^")
                    var rect=CGRectMake(CGFloat(arr[0].toInt()!),0,CGFloat(arr[1].toInt()!),cheight)
                    var textview = UITextView(frame: rect)
                    textview.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
                    textview.text = "\(val)"
                    textview.textAlignment = .Natural
                    
                    textview.editable=false
                    textview.selectable=false
                    textview.layer.borderColor = UIColor.blackColor().CGColor
                    textview.layer.borderWidth = 0.5
                    self.contentView.addSubview(textview)
                    model[key as! String]=nil
                }
            }
            for value in model.values {
                var arr = value.componentsSeparatedByString("^")
                var rect=CGRectMake(CGFloat(arr[0].toInt()!),0,CGFloat(arr[1].toInt()!),cheight)
                var textview = UITextView(frame: rect)
                textview.editable=false
                textview.selectable=false
                textview.layer.borderColor = UIColor.blackColor().CGColor
                textview.layer.borderWidth = 0.5
                self.contentView.addSubview(textview)
            }
            
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.data=[:]
        super.init(style:style,reuseIdentifier:reuseIdentifier)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
