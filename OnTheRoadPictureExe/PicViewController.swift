//
//  PicViewController.swift
//  OnTheRoadPictureExe
//
//  Created by JiangYi Zhang on 14/11/8.
//  Copyright (c) 2014年 JiangYi Zhang. All rights reserved.
//

import UIKit
import CoreData

class PicViewController: UIViewController, UIScrollViewDelegate {
    
    var dataPic:Array<AnyObject>! = []

     var data: NSManagedObject!
    
    var context: NSManagedObjectContext!
    
    var Scrollview: UIScrollView!
    
    var picturearray: Array<String> = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
        Scrollview = UIScrollView(frame: CGRectMake(0, 65, 378, 568))
        
        Scrollview.scrollEnabled = true
        self.view.backgroundColor = UIColor.blackColor()
//        self.navigationController?.navigationBar.backgroundColor = UIColor.whiteColor()
          }

    
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        var comment = data.valueForKey("rcomment") as String
        var groupid = data.valueForKey("recordid") as String
        var f = NSFetchRequest(entityName: "Picture")
        // 返回是一个anyobject数组
        dataPic = context.executeFetchRequest(f, error: nil)
        
        var doc = NSHomeDirectory() + "/Documents"
        
        for var i = 0; i < dataPic.count; i++ {
            var recordid: AnyObject? = dataPic[i].valueForKey("groupid")
            
            var picname: AnyObject? = dataPic[i].valueForKey("picturename")
            
            var groupidp = "\(recordid!)"
            
            var picnamep = "\(picname!)"
            
            if groupid == groupidp {
                
                let tmp:String = "\(doc)/\(groupid)/\(picnamep)"
                picturearray.append(tmp)
            }
        }

        println("\(picturearray[0])")
        
        var commentTextView = UITextView(frame: CGRectMake(5, 5, 180, 165))
        commentTextView.text = comment
        var MapImageView = UIImageView(frame: CGRectMake(190, 5, 185, 165))
        MapImageView.image = UIImage(contentsOfFile: picturearray[0])
        Scrollview.addSubview(commentTextView)
        Scrollview.addSubview(MapImageView)
        var y: CGFloat = 180
        for var i = 1; i < picturearray.count; i++ {
            
            let cgrect = CGRectMake(0, y, 378, 170)
            var imageview = UIImageView(frame: cgrect)
            imageview.image = UIImage(contentsOfFile: picturearray[i])
            println("\(picturearray[i])")
            self.Scrollview.addSubview(imageview)
        
            y = y + 180
            
        }
        
        

    }
    
    override func viewDidAppear(animated: Bool) {
        
        let height = picturearray.count * 180
        Scrollview.contentSize = CGSize(width: 378, height: height)
        self.view.addSubview(Scrollview)

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.BlackOpaque
    }
    
   
    @IBAction func didBackBtnClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)

        
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
