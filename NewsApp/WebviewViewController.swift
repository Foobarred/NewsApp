//
//  WebviewViewController.swift
//  NewsApp
//
//  Created by Yassine on 2018-07-09.
//  Copyright © 2018 Yassine Marzouki. All rights reserved.
//

import UIKit

class WebviewViewController: UIViewController {

    @IBOutlet weak var webview: UIWebView!
    var url: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        webview.loadRequest(URLRequest(url: URL(string: url!)!))
    }

}
