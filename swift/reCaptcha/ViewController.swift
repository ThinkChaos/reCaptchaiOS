//
//  ViewController.swift
//  reCaptcha
//
//  Created by Gabriela Bezerra on 11/10/17.
//  Copyright © 2017 gabrielabezerra. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, ReCaptchaDelegate {

  @IBOutlet weak var reCaptchaView: ReCaptcha!

  override func viewDidLoad() {
    super.viewDidLoad()
    reCaptchaView.delegate = self
    reCaptchaView.setupWebView(url: "https://example.com")
  }

  func didSolve(response: String) {
    print("response: \(response)")
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first, touch.view == self.view, reCaptchaView.isActive {
      reCaptchaView.resetWebView(url: "https://example.com")
    }
  }
}
