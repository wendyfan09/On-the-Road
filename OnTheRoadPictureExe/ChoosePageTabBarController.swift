//
//  ChoosePageTabBarController.swift
//  OnTheRoadPictureExe
//
//  Created by JiangYi Zhang on 14/12/13.
//  Copyright (c) 2014年 JiangYi Zhang. All rights reserved.
//

import UIKit

class ChoosePageTabBarController: UITabBarController {

    
    var userid: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
  

}
