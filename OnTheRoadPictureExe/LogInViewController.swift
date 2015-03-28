//
//  LogInViewController.swift
//  OnTheRoadPictureExe
//
//  Created by JiangYi Zhang on 14/12/12.
//  Copyright (c) 2014年 JiangYi Zhang. All rights reserved.
//

import UIKit
import CoreData

class LogInViewController: UIViewController,UIActionSheetDelegate {

    @IBOutlet weak var IDTextField: UITextField!
    
    @IBOutlet weak var PassWordTextField: UITextField!
    
    
    @IBOutlet weak var ConfirmPassWordTextField: UITextField!
    
    
    @IBOutlet weak var AgeTextField: UITextField!
    
    @IBOutlet weak var GenderSwitch: UISwitch!
    
    var defaultphoto: UIImage!
    
    
    
    var context: NSManagedObjectContext!
    
    var ppButtonImage: UIImage?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        defaultphoto = UIImage(named: "defaultimg")
        
        // 数据库启用
        context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
       

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @IBAction func BtnCreatAccount(sender: AnyObject) {
        
        var userinfor:AnyObject =  NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context!)
        
        var id = IDTextField.text
        var password = PassWordTextField.text
        var age = AgeTextField.text
        var gender = ""
        var confirmpassword = ConfirmPassWordTextField.text
        if GenderSwitch.enabled{
            gender = "Male"
        }else{
            gender = "Female"
        }
      
        
        if id == "" || password == "" || confirmpassword != password {
        
        displaywarning()
        }
        else {
            
            var userDefault: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            
            userDefault.setObject(id, forKey: "userid")
            
            userDefault.synchronize()
            
            
            var path = NSHomeDirectory() + "/Documents/" + "userphoto"
            var picturepath = path + "/" + id + ".jpg"
            println("\(picturepath)")
            // 创建文件夹
            var manager = NSFileManager.defaultManager()
            var flag = manager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil, error: nil) // 如果中间路径不存在那么intermediation属性应设置为true
            
            UIImageJPEGRepresentation(defaultphoto, 1).writeToFile(picturepath, atomically: true)  // 1代表占地最大， 0 代表占地最小


            
            
                    userinfor.setValue(id, forKey: "idemail")
                    userinfor.setValue(password, forKey: "password")
                    userinfor.setValue(age, forKey: "age")
                    userinfor.setValue(gender, forKey: "gender")
                    userinfor.setValue(picturepath, forKey: "photo")
                    context?.save(nil)
            
            
            var choosepage = storyboard?.instantiateViewControllerWithIdentifier("CHP") as ChoosePageTabBarController
            presentViewController(choosepage, animated: true, completion: nil)

        }

    }
    
    @IBAction func TapGCloseKeyBoard(sender: AnyObject) {
        // 关键盘
         self.view.endEditing(true)
    }
    
    
    func displaywarning(){
        
        var alertControl = UIAlertController(title: "Warning", message: "Try again!", preferredStyle: UIAlertControllerStyle.Alert)
        
        var action1 = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
            (action: UIAlertAction!) -> Void in
            
            }
        )
        // 将动作添加到控制器
        alertControl.addAction(action1)
        // 显示模糊视图
        self.presentViewController(alertControl, animated: true, completion: nil)
        
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
