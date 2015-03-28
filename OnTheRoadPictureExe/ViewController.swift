//
//  ViewController.swift
//  OnTheRoadPictureExe
//
//  Created by JiangYi Zhang on 14/11/8.
//  Copyright (c) 2014年 JiangYi Zhang. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import MapKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var EditButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var userid: String!
    var recordpath: String!
    var dataArr:Array<AnyObject>! = []
    
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        println("\(NSHomeDirectory())")
        
       
        context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        // 刷新数据
        refreshData()
        
        var userDefault: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        userid = userDefault.stringForKey("userid")

        
    }
    
    override func viewWillAppear(animated: Bool) {
        refreshData()
        println("\(self.userid)")
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        var userid: AnyObject? = dataArr [indexPath.row].valueForKey("userid")
        var date: AnyObject? = dataArr [indexPath.row].valueForKey("date")
        var city: AnyObject? = dataArr [indexPath.row].valueForKey("cityname")
        var state: AnyObject? = dataArr [indexPath.row].valueForKey("statename")
        var country: AnyObject? = dataArr [indexPath.row].valueForKey("countryname")
        var zipcode: AnyObject? = dataArr [indexPath.row].valueForKey("postid")
        var comment: AnyObject? = dataArr [indexPath.row].valueForKey("rcomment")
        var recordid: AnyObject? = dataArr [indexPath.row].valueForKey("recordid")

        if userid as String? != self.userid{
            cell.backgroundColor = UIColor.lightGrayColor()
        }
        
        
        var celllabel = cell.viewWithTag(1) as UILabel
        

        celllabel.text =  "\((date! as NSString).substringWithRange(NSMakeRange(0, 20))) \n\(city!)  \n\(state!) \(zipcode!) \n\(country!)  \n \n\(comment!)"
        
        var path = NSHomeDirectory() + "/Documents/" + (recordid! as String)
        // 显示地图
        var picturename = recordid! as String + "\(0).jpg"
        var picturepath = path + "/" + picturename
        
        var cellimage = cell.viewWithTag(2) as UIImageView
        cellimage.image = UIImage(contentsOfFile: picturepath)
        return cell
        
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
       
         var userid: AnyObject? = dataArr [indexPath.row].valueForKey("userid")
        
        if userid as String == self.userid{
            return true
        }else{
            return false
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var data = dataArr[indexPath.row] as NSManagedObject
        
        var Picview = storyboard?.instantiateViewControllerWithIdentifier("PicView") as PicViewController
        
        Picview.data = data
        
        presentViewController(Picview, animated: true, completion: nil)
        
    }
    

    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            // Delete the row from the data source
            //        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            
            var recordid: AnyObject? = dataArr [indexPath.row].valueForKey("recordid")
            recordpath = "\(recordid!)"
            
          //  println("\(recordid!)")
            
            var path = NSHomeDirectory() + "/Documents/" + recordpath
            
            var manager = NSFileManager.defaultManager()
            manager.removeItemAtPath(path, error: nil)
            
            context.deleteObject(dataArr[indexPath.row] as NSManagedObject)
            context.save(nil) // 保存修改或者各种操作 在数据库中
            
            deletepic()
            refreshData()
            
        }
    }

    func deletepic(){  // 删除Picture中的相关联的图片
        var f = NSFetchRequest(entityName: "Picture")
        // 返回是一个anyobject数组
        
        var data:Array<AnyObject> = context.executeFetchRequest(f, error: nil)!
        
        for var i = 0 ; i < data.count; i++ {
            var recordid: AnyObject? = data[i].valueForKey("groupid")
            
            var recordpath = "\(recordid!)"
            
            
            if recordpath == self.recordpath {
                context.deleteObject(data[i] as NSManagedObject)
                context.save(nil)
            }
 
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func didAddBtnClicked(sender: AnyObject) {
        
        var addPic = storyboard?.instantiateViewControllerWithIdentifier("PicContent") as AddPicController
        addPic.userid = self.userid
        presentViewController(addPic, animated: true, completion: nil)
    }
    
    func refreshData(){ //刷新数据
        // 取数据
        var f = NSFetchRequest(entityName: "Record")
        // 返回是一个anyobject数组
        dataArr = context.executeFetchRequest(f, error: nil)
        tableView.reloadData() // tableview 重新加载数据
        
    }
    
    @IBAction func didEditBtnClicked(sender: AnyObject) {
        
        
        if EditButton.title == "Edit"{
            EditButton.title = "Done"
            tableView.setEditing(true, animated: true)
        } else {
            EditButton.title = "Edit"
            tableView.setEditing(false, animated: true)
            
        }
        
        
    }
    
}
