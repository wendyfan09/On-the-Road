//
//  ProfileViewController.swift
//  OnTheRoadPictureExe
//
//  Created by JiangYi Zhang on 14/12/13.
//  Copyright (c) 2014年 JiangYi Zhang. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var photoImageview: UIImageView!
    
    
    
     var context: NSManagedObjectContext!
     var dataArr:Array<AnyObject>! = []
    var userid: String!
    var picturenamearray: Array<String> = []
    var picgroupidarray: Array<String> = []
    
    var originalimage: UIImage!
    var desimage: UIImage!
    var data: NSManagedObject!
  
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        var userDefault: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        userid = userDefault.stringForKey("userid")
        
        context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
        refreshData()
  
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        var path = NSHomeDirectory() + "/Documents/" + "userphoto"
        var picturepath = path + "/" + self.userid + ".jpg"
        
        photoImageview.image = UIImage(contentsOfFile:picturepath)
        
        originalimage = photoImageview.image
        photoImageview.userInteractionEnabled = true
        var tapSensor = UITapGestureRecognizer(target: self, action: Selector("tapSensor:"))
        self.photoImageview.addGestureRecognizer(tapSensor)
    }
    
    
    
    
    func tapSensor(sender: UIGestureRecognizer) {
        
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            var picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.allowsEditing = true
            self.presentViewController(picker, animated: true, completion: nil)
        }
        else{
            NSLog("No Camera.")
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        
        let OriginalImage = info[UIImagePickerControllerOriginalImage] as UIImage
        
       photoImageview.image = OriginalImage
       desimage = OriginalImage
        
        if originalimage != desimage {
            
//            var x = NSFetchRequest(entityName: "User")
//            dataArr = context.executeFetchRequest(x, error: nil)
//            
//            var photopath: AnyObject?
//           for var i = 0; i < dataArr.count; i++ {
//                
//            var useriddata: AnyObject? = dataArr [i].valueForKey("idemail") as String
//            if useriddata as String == userid {
//                 photopath = dataArr [i].valueForKey("photo") as String
//            }
//            }
            
            var path = NSHomeDirectory() + "/Documents/" + "userphoto"
            var picturepath = path + "/" + self.userid + ".jpg"

            
            var manager = NSFileManager.defaultManager()
            manager.removeItemAtPath(picturepath, error: nil)
            UIImageJPEGRepresentation(desimage, 1).writeToFile(picturepath, atomically: true)  // 1代表占地最大， 0 代表占地最小

        
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    func refreshData(){ //刷新数据
        
        var x = NSFetchRequest(entityName: "User")
        dataArr = context.executeFetchRequest(x, error: nil)
        
        for var i = 0; i < dataArr.count; i++ {
            var useriddata: AnyObject? = dataArr [i].valueForKey("idemail") as String
            var agedata: AnyObject? = dataArr [i].valueForKey("age") as String
             var passworddata: AnyObject? = dataArr [i].valueForKey("password") as String
             var genderdata: AnyObject? = dataArr [i].valueForKey("gender") as String
            
            if self.userid == useriddata as String{
              
                idLabel.text = self.userid
                ageLabel.text = agedata? as String?
                passwordLabel.text = passworddata? as String?
                genderLabel.text = genderdata? as String?
                
            }
  
        }
        
        // 取数据
        var f = NSFetchRequest(entityName: "Record")
        var s = NSFetchRequest(entityName: "Picture")
        
        var groupidarray: Array<String> = []
               // 返回是一个anyobject数组
        dataArr = context.executeFetchRequest(f, error: nil)
        println("DATA RECORD\(dataArr.count)")
        
        for var i = 0; i < dataArr.count; i++ {
            var useriddata: AnyObject? = dataArr [i].valueForKey("userid")
            
            println("\(useriddata)")
            
            var recordid: AnyObject? = dataArr[i].valueForKey("recordid") as String
            
            if useriddata as String == userid {
                groupidarray.append(recordid as String)
                
            }
        }
        dataArr = context.executeFetchRequest(s, error: nil)
        for var y = 0; y < groupidarray.count; y++ {
        for var i = 0; i < dataArr.count; i++ {
            
            var groupid: AnyObject? = dataArr [i].valueForKey("groupid") as String
            var picturename: AnyObject? = dataArr[i].valueForKey("picturename") as String
            
            
            if groupidarray[y] == groupid as String {
               
                picturenamearray.append(picturename as String)
                picgroupidarray.append(groupid as String)
            }
            }
        }
        tableView.reloadData() // tableview 重新加载数据
        
        
        println("多少张图\(picturenamearray.count)")
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell",
            forIndexPath: indexPath) as UITableViewCell
        
         var path = NSHomeDirectory() + "/Documents/" + picgroupidarray[indexPath.row]
         var picturepath = path + "/" + picturenamearray[indexPath.row]
        
        println("\(picturepath)")
        
//        cell.imageView?.image = UIImage(contentsOfFile: picturepath)

        
    //    cell.textLabel?.text = picturepath
        
        var cellimage = cell.viewWithTag(1000) as UIImageView
       
//        var cellimage = cell.viewWithTag(1) as UIImageView
        cellimage.image = UIImage(contentsOfFile: picturepath)
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return picturenamearray.count
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
