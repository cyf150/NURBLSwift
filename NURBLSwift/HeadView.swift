//
//  HeadView.swift
//  NURBLSwift
//
//  Created by cyf on 15/5/3.
//  Copyright (c) 2015年 com.dhccnurse.cyf. All rights reserved.
//

import UIKit

class HeadView: UIView {

    var Text:UILabel?
    var Textcontent:String?
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
      convenience init(str:String)
    {
      var arr = str.componentsSeparatedByString("^")
      var myframe = CGRectMake(CGFloat(arr[5].toInt()!), CGFloat(arr[6].toInt()!), CGFloat(arr[1].toInt()!), CGFloat(arr[0].toInt()!))
      self.init(frame:myframe)
      Text = UILabel(frame: CGRectMake(0, 0, myframe.width, myframe.height))
      Textcontent = arr[9]
      Text?.numberOfLines = 0
      Text?.text = Textcontent
      Text?.font = UIFont.boldSystemFontOfSize(15)
      Text?.textAlignment = .Center
      self.addSubview(Text!)
      self.backgroundColor = UIColor.whiteColor()
    }

   required init(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        var context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1.0);
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
        CGContextAddRect(context, rect);
        CGContextStrokePath(context);                

    }
       /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
