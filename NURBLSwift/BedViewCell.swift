//
//  BedViewCell.swift
//  NURBLSwift
//
//  Created by cyf on 15/4/21.
//  Copyright (c) 2015年 com.dhccnurse.cyf. All rights reserved.
//

import UIKit

class BedViewCell: UICollectionViewCell {
    
    var NameLable:UILabel?
    var AgeLable:UILabel?
    var SexLable:UILabel?
    var data:BedModel? {
        didSet {
           self.NameLable?.text = data!.PatName as String
           self.AgeLable?.text = data!.PatAge as String
           self.SexLable?.text = data!.PatSex as String
        }
     }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.NameLable = UILabel(frame: CGRectMake(0, 0, frame.width, 20))
        self.AgeLable = UILabel(frame: CGRectMake(0, 22, frame.width/3, 20))
        self.SexLable = UILabel(frame: CGRectMake((frame.width/3) + 2.0, 22,frame.width/3, 20))
       
        self.contentView.addSubview(NameLable!)
        self.contentView.addSubview(AgeLable!)
        self.contentView.addSubview(SexLable!)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
