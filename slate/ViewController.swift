//
//  ViewController.swift
//  slate
//
//  Created by Alex Macmillan on 29/08/2015.
//  Copyright © 2015 x13N. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func listen() {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let request = app.apiAI.requestWithType(.Voice)
        request.setCompletionBlockSuccess({ (request, response) -> Void in
            print("Success", response)
            }) { (request, error) -> Void in
                print("Error", error)
        }
        app.apiAI.enqueue(request)
    }
    

}

