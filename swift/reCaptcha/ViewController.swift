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
  
  @IBOutlet weak var reCaptchaView: ReCaptcha!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    reCaptchaView.setupWebView(url: "https://portal-desenv.ativrotas.com")
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    print(touches.first!.view!.description)
    if let touch = touches.first, touch.view == self.view, reCaptchaView.isActive {
      reCaptchaView.resetWebView(url: "https://portal-desenv.ativrotas.com")
    }
  }
  
}

