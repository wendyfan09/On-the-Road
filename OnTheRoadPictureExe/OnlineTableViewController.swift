//
//  OnlineTableViewController.swift
//  DVIPlayer
//
//  Created by JiangYi Zhang on 14/11/24.
//  Copyright (c) 2014年 JiangYi Zhang. All rights reserved.
//

import UIKit

class OnlineTableViewController: UITableViewController {

    var channelList: Array<Channel> = []
    var currentChannel: Channel!
    
    func loadChannelList(){
        
        var url = NSURL(string: "https://gitcafe.com/wcrane/XXXYYY/raw/master/baidu.json")!
        var request = NSURLRequest(URL: url)
        //主队列
        var mainQueue = NSOperationQueue.mainQueue()
        // 发送异步请求
        NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
           
            var httpReponse = response as NSHTTPURLResponse
           
            if httpReponse.statusCode == 200 {
                // 将NSData 转化为字符串
                var str = NSString(data: data, encoding: NSUTF8StringEncoding)!
               // println("\(str)")
                
                
                //将json串转换为对象
                var error: NSError?
                var array: NSArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) as NSArray
               // println("\(array)")
               
                for dict in array {
                    var channel = Channel(dict:dict as NSDictionary)
                    self.channelList.append(channel)
                    
                }
            //    println("\(self.channelList)")
                self.tableView.reloadData()
            }
            
        
        
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        println("OnlineTableViewController")
        //获取网络上的频道列表
        loadChannelList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.channelList.count
    }

 
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

       var channel = self.channelList[indexPath.row]
        cell.textLabel!.text = channel.title

        return cell
    }
  
   
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        currentChannel = self.channelList[indexPath.row]
        return indexPath
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var desViewController: OnlineViewController = segue.destinationViewController as OnlineViewController
        desViewController.channel = currentChannel
     }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
