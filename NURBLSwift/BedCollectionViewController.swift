//
//  BedCollectionViewController.swift
//  NURBLSwift
//
//  Created by cyf on 15/4/20.
//  Copyright (c) 2015年 com.dhccnurse.cyf. All rights reserved.
//

import UIKit
import MBProgressHUD
import MJRefresh

let reuseIdentifier = "BedCell"

class BedCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {

    var data:NSArray?
    var DataDao:DataComm?
    var logo:LogonModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MBProgressHUD.showHUDAddedTo(self.collectionView, animated: true)
        self.DataDao = DataComm()
        self.logo = LogonModel()
        logo.logonloc = "98"
        
        self.data = DataDao?.getbeddata(self.logo.logonloc)
        MBProgressHUD.hideHUDForView(self.collectionView, animated: true)
        self.collectionView?.addLegendHeaderWithRefreshingBlock({
            self.data = nil
            var queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_SERIAL)
            dispatch_sync(queue, {
                 self.data = self.DataDao?.getbeddata(self.logo.logonloc)
            })
            self.collectionView?.reloadData()
            self.collectionView?.header.endRefreshing()
        
            })
        
                // Register cell classes
        self.collectionView!.registerClass(BedViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        if var dd=data{
          return dd.count
        }
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:BedViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! BedViewCell
        //cell.contentView.backgroundColor = UIColor.blueColor()
        //cell.lable.text = String(indexPath.row)
        cell.backgroundColor = UIColor.yellowColor()
        //cell.img.backgroundColor=UIColor.yellowColor()
        //cell.lables.text = "text"
        var bedmodel = data![indexPath.row] as! BedModel
        cell.data = bedmodel
        //var textv = UILabel(frame: CGRectMake(0, 0, cell.bounds.width, 10))
        //textv.text = "KKKDDL"
        //cell.contentView.addSubview(textv)
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var size = CGSizeMake(100, 100)
        return size
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
