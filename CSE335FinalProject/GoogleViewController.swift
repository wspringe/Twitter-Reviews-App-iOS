//
//  GoogleViewController.swift
//  CSE335FinalProject
//
//  Created by Wesley Springer on 4/20/17.
//  Copyright © 2017 ASU. All rights reserved.
//

import UIKit

class GoogleViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var activityProgress: UIActivityIndicatorView!
    
    var query: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.webview.delegate = self
        self.webview.scrollView.isScrollEnabled = true
        self.webview.scalesPageToFit = true
        
        //removes whitespaces from string
        let trimmedString = query.replacingOccurrences(of: " ", with: "")
        
        //google search for passed in string
        let webpage: String = "https://google.com/search?q=\(trimmedString)"
        print(webpage)
        let url = URL(string: webpage)
        let request = URLRequest(url: url!)
        
        activityProgress.hidesWhenStopped = true
        activityProgress.startAnimating()
        webview.loadRequest(request) 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityProgress.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("\(error)")
    }
}
