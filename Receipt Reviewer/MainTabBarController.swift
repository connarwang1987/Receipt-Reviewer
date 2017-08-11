//
//  MainTabBarController.swift
//  Receipt Reviewer
//
//  Created by Linglong Wang on 7/10/17.
//  Copyright © 2017 Connar Wang. All rights reserved.
//

import UIKit
import Foundation

class MainTabBarController: UITabBarController {
    let photoHelper = RRPhotoHelper()
    var arrayOfImageNameForSelectedState: [String] = [ "icons8-Receipt Filled-30-2","icons8-Combo Chart Filled-30" ]
    var arrayOfImageNameForUnselectedState:[String] = ["icons8-Receipt-30-2","icons8-Combo Chart-30-2"]
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
            
        self.tabBar.barTintColor = UIColor(red: 22/255, green: 30/255, blue: 110/255, alpha: 1)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let count = self.tabBar.items?.count {
            for i in 0...(count-1) {
                let imageNameForSelectedState   = arrayOfImageNameForSelectedState[i]
                let imageNameForUnselectedState = arrayOfImageNameForUnselectedState[i]
                
                self.tabBar.items?[i].selectedImage = UIImage(named: imageNameForSelectedState)?.withRenderingMode(.alwaysOriginal)
                self.tabBar.items?[i].image = UIImage(named: imageNameForUnselectedState)?.withRenderingMode(.alwaysOriginal)
            }
        }
        
        let selectedColor   = UIColor.white
        let unselectedColor = UIColor.white
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: selectedColor], for: .selected)
        
        photoHelper.completionHandler  = { image in
            print("handle image")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
