//
//  SignInViewController.swift
//  OnTheRoadPictureExe
//
//  Created by JiangYi Zhang on 14/12/12.
//  Copyright (c) 2014年 JiangYi Zhang. All rights reserved.
//

import UIKit
import CoreData
class SignInViewController: UIViewController {
    
    @IBOutlet weak var ID: UITextField!
    
    @IBOutlet weak var PassWord: UITextField!
    
    var context: NSManagedObjectContext!
     var dataArr:Array<AnyObject>! = []

    @IBAction func BtnSignInClicked(sender: AnyObject) {
        
        let id = ID.text
        let password = PassWord.text

        if id == "" || password == ""{
            
            displaywarning("ID And Password can not be empty")
        }else{
            
            // 取数据
            var f = NSFetchRequest(entityName: "User")
            // 返回是一个anyobject数组
            dataArr = context.executeFetchRequest(f, error: nil)
            
            var idreal:String = ""
            // 判断是否有这个账户
            for var i = 0; i < dataArr.count; i++ {
            let iddata: AnyObject? = dataArr [i].valueForKey("idemail")
            let passworddata: AnyObject? = dataArr [i].valueForKey("password")
                if (id == iddata as String) && (password == passworddata as String) {
                    idreal = id
                }
            }
            if idreal == ""{
                ID.text = ""
                PassWord.text = ""
                displaywarning("Invalid ID and Password")
            }
            else {
//                var index = storyboard?.instantiateViewControllerWithIdentifier("index") as ViewController
//                
//                index.userid = idreal
//                presentViewController(index, animated: true, completion: nil)
                
                
                var userid: NSString = idreal
                
                var userDefault: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                
                userDefault.setObject(userid, forKey: "userid")
                
                
                
                userDefault.synchronize()
                
                
                
                
               var choosepage = storyboard?.instantiateViewControllerWithIdentifier("CHP") as ChoosePageTabBarController
                presentViewController(choosepage, animated: true, completion: nil)
                
 
            }
            
        }

        
        
    }
    
    @IBAction func TapGKeyBoard(sender: AnyObject) {
        // 关键盘
        self.view.endEditing(true)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        navigationController?.navigationBarHidden = true

    }
    
    
    
    @IBAction func BtnExit(sender: UIButton) {
        
        exit(0)
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func displaywarning(information: String){
        
        var alertControl = UIAlertController(title: "Warning", message: information, preferredStyle: UIAlertControllerStyle.Alert)
        
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
