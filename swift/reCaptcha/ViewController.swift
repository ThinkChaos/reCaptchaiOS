//
//  ViewController.swift
//  reCaptcha
//
//  Created by Gabriela Bezerra on 11/10/17.
//  Copyright © 2017 gabrielabezerra. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

  var wk: WKWebView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.initWebView()
    if let wk = wk {
      wk.load(URLRequest(url: URL(string: "https://example.com")!))
    }
  }

  func initWebView() {
    let wkController = WKUserContentController()
    wkController.add(self, name: "reCaptchaiOS")
    wkController.addUserScript(self.readScript())
    
    let wkConfig = WKWebViewConfiguration()
    wkConfig.userContentController = wkController
    
    self.wk = WKWebView(frame: self.view.frame, configuration: wkConfig)
    self.wk?.backgroundColor = UIColor.clear
    self.wk?.isOpaque = false
  }
  
  func readScript() -> WKUserScript {
    let scriptSource = try! String(contentsOfFile: (Bundle.main.path(forResource: "script", ofType: "js"))!)
    return WKUserScript(source: scriptSource, injectionTime: .atDocumentStart, forMainFrameOnly: true)
  }
  
}


extension ViewController: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    if let args = message.body as? [String] {
      
      switch args[0] {
      
      case "didLoad":
        self.captchaDidLoad()
        break
        
      case "didSolve":
        self.captchaDidSolve(response: args[1])
        break
        
      case "didExpire":
        self.captchaDidExpire()
        break
        
      default:
        print("args[0]: \(args[0])")
        break
        
      }
    }
    
  }
  
  
  func captchaDidLoad() {
    if let wk = self.wk {
      wk.frame = self.view.frame
      self.view.addSubview(wk)
    } else {
      print("wk is null")
    }
  }
  
  func captchaDidSolve(response: String) {
    print("response: \(response)")
  }
  
  func captchaDidExpire() {
    print("Captcha Expired")
  }
  
}

