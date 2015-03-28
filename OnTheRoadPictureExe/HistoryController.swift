//
//  HistoryController.swift
//  OnTheRoadPictureExe
//
//  Created by JiangYi Zhang on 14/11/20.
//  Copyright (c) 2014年 JiangYi Zhang. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation

class HistoryController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    
    
    @IBOutlet weak var MKMapHistroyView: MKMapView!
    
     var userid: String!
    var context: NSManagedObjectContext!
    var dataRecord:Array<AnyObject>! = []
    
    var latitude: Array<String> = []
    var longitude: Array<String> = []
    var city: Array<String> = []
    var state: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("启动history")
        
        self.MKMapHistroyView.delegate = self
        
        context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        var userDefault: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        userid = userDefault.stringForKey("userid")
        
        
        self.view.backgroundColor = UIColor.blackColor();
        
    
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.BlackOpaque
    }
    
//    override func prefersStatusBarHidden() -> Bool {
//        return true
//    }
    
    
    func refresh(){
        
        var currentMapView: MKMapView!
        
        // 数据库取数据
        var f = NSFetchRequest(entityName: "Record")
        // 返回是一个anyobject数组
        dataRecord = context.executeFetchRequest(f, error: nil)
        
        for var i = 0; i<dataRecord.count; i++ {
            
            var userid = dataRecord[i].valueForKey("userid") as String
            if self.userid == userid {
            
            var s = dataRecord[i].valueForKey("latitude") as String
            latitude.append(s)
             s = dataRecord[i].valueForKey("longitude") as String
            longitude.append(s)
             s = dataRecord[i].valueForKey("cityname") as String
            city.append(s)
             s = dataRecord[i].valueForKey("statename") as String
            state.append(s)
            }
        }
        if latitude.count == 0 {
            
        }else{
        
        var location:[CLLocationCoordinate2D] = []
        
        for var i = 0; i < latitude.count; i++ {
            
            var La: Double = (latitude[i] as NSString).doubleValue
            var Lo: Double = (longitude[i] as NSString).doubleValue
            
           location.append(CLLocationCoordinate2D(latitude: La, longitude: Lo))
            
            
        }
      
            for var num = 0; num < (location.count) ;num++ {
                let annotation = MKPointAnnotation()
                annotation.setCoordinate(location[num])
                
                annotation.title = city[num] //主标题显示城市
                annotation.subtitle = state[num] //副标题显示州
                MKMapHistroyView.addAnnotation(annotation)
            }

            //地图显示范围算法
            //get the visible range of history map
            
            var max_lat = location[0].latitude
            var max_lon = location[0].longitude
            var min_lat = location[0].latitude
            var min_lon = location[0].longitude
            
            for var index:Int = 1 ; index < (location.count) ;index += 1 {
                
                if location[index].latitude > max_lat {
                    max_lat = location[index].latitude
                }
                
                if location[index].longitude > max_lon {
                    max_lon = location[index].longitude
                }
                
                if location[index].latitude < min_lat {
                    min_lat = location[index].latitude
                }
                
                if location[index].longitude < min_lon {
                    min_lon = location[index].longitude
                }
            }
            
            let mapCenter = CLLocationCoordinate2D(
                latitude: (max_lat + min_lat)/2,
                longitude: (max_lon + min_lon)/2
            )
        
            let ratio_lat = (max_lat - min_lat)
            let ratio_lon = (max_lon - min_lon)
            let max_ratio = max(ratio_lat, ratio_lon)
            
            let ratio = max_ratio * 2.0

            //设置地图中心和缩放尺度
            //set map properties
            let span = MKCoordinateSpanMake(ratio, ratio)
            
            let region = MKCoordinateRegion(center: mapCenter, span: span)
            MKMapHistroyView.setRegion(region, animated: false)

        }}
    
    
  
    
    
    override func viewWillAppear(animated: Bool) {
        refresh()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
