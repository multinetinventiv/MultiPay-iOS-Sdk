//
//  SelectEnvironmentViewController.swift
//  FrameworkTest
//
//  Created by ilker sevim on 4.03.2021.
//  Copyright © 2021 multinet. All rights reserved.
//

import UIKit
import Multipay

class SelectEnvironmentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func openOtherScreen(environment:Environment){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "MainTestViewController") as! ViewController
        
        vc.lastSelectedApiType = environment
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func useDevEnvironmentClicked(_ sender: Any) {
        openOtherScreen(environment: .dev)
    }
    @IBAction func useTestEnvironmentClicked(_ sender: Any) {
        openOtherScreen(environment: .test)
    }
    @IBAction func usePilotEnvClicked(_ sender: Any) {
        openOtherScreen(environment: .pilot)
    }
    @IBAction func useProdEnvClicked(_ sender: Any) {
        openOtherScreen(environment: .production)
    }

}
