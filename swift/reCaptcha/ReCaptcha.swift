//
//  ReCaptcha.swift
//  reCaptcha
//
//  Created by Gabriela Bezerra on 17/10/17.
//  Copyright © 2017 gabrielabezerra. All rights reserved.
//

import Foundation
import WebKit

class ReCaptcha: UIView {
  
  var wk: WKWebView?
  var initialFrame: CGRect?
  var isActive: Bool = false
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  
  func setupWebView(url: String) {
    
    let wkController = WKUserContentController()
    wkController.add(self, name: "reCaptchaiOS")
    wkController.addUserScript(self.readScript())
    
    let wkConfig = WKWebViewConfiguration()
    wkConfig.userContentController = wkController
    
    self.wk = WKWebView(frame: self.frame, configuration: wkConfig)
    
    guard let wk = self.wk else {
      return
    }
    
    wk.backgroundColor = UIColor.clear
    wk.isOpaque = false
    wk.scrollView.isScrollEnabled = false
    wk.frame = self.frame
    
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
    tapRecognizer.delegate = self
    tapRecognizer.numberOfTapsRequired = 1
    wk.addGestureRecognizer(tapRecognizer)
    
    wk.load(URLRequest(url: URL(string: url)!))
    
  }
  
  func resetWebView(url: String) {
    self.wk!.removeFromSuperview()
    self.wk = nil
    
    setupWebView(url: url)
  }
  
  func readScript() -> WKUserScript {
    let scriptSource = try! String(contentsOfFile: (Bundle.main.path(forResource: "script", ofType: "js"))!)
    return WKUserScript(source: scriptSource, injectionTime: .atDocumentStart, forMainFrameOnly: true)
  }
  
}






extension ReCaptcha: WKScriptMessageHandler {
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
    print("loaded")
    
    guard let wk = self.wk else {
      return
    }
    
    initialFrame = self.frame
    wk.frame = self.frame
    wk.layer.position = CGPoint(x: self.frame.midX ,y: self.layer.position.y)
    superview!.addSubview(wk)
  }
  
  //snapKit - constraints
  
  func captchaDidSolve(response: String) {
    print("response: \(response)")
    
    guard let wk = self.wk else {
      return
    }
    
    self.isActive = false
    
    wk.frame = initialFrame!
    wk.isUserInteractionEnabled = false
  }
  
  func captchaDidExpire() {
    print("Captcha Expired")
    
    guard let wk = self.wk else {
      return
    }
    
    wk.isUserInteractionEnabled = true
    
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
    tapRecognizer.delegate = self
    tapRecognizer.numberOfTapsRequired = 1
    wk.addGestureRecognizer(tapRecognizer)
  }
  
  @objc func handleSingleTap() {
    
    guard let wk = self.wk else {
      return
    }
    
    self.isActive = true
    
    wk.gestureRecognizers?.removeAll()
    
    let when = DispatchTime.now() + 1.2
    DispatchQueue.main.asyncAfter(deadline: when) {
      self.adjustSize(of: wk)
    }
    
  }
  
  func adjustSize(of wk: WKWebView) {
    let SERect = CGRect(x: self.wk!.frame.minX, y: self.wk!.frame.midY/4, width: self.wk!.frame.width, height: self.wk!.frame.height*6.5)
    let eightRect = CGRect(x: self.wk!.frame.minX, y: self.wk!.frame.midY/4, width: self.wk!.frame.width/1.05, height: self.wk!.frame.height*5.5)
    let eightPlusRect = CGRect(x: self.wk!.frame.minX, y: self.wk!.frame.midY/3, width: self.wk!.frame.width/1.1, height: self.wk!.frame.height*5)
    
    if UIScreen.main.bounds.size.height == 568 {
      wk.frame = SERect
      
    } else if UIScreen.main.bounds.size.height == 667 {
      wk.frame = eightRect
      
    } else if UIScreen.main.bounds.size.height == 736 {
      wk.frame = eightPlusRect
      
    } else {
      wk.frame = eightPlusRect
    }
  }
  
}






extension ReCaptcha: UIGestureRecognizerDelegate {
  func gestureRecognizer(_: UIGestureRecognizer,
                         shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}
