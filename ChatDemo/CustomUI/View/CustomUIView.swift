//
//  CustomUIView.swift
//  ChatDemo
//
//  Created by Lam Ngoc Khanh on 8/24/17.
//  Copyright © 2017 Lam Ngoc Khanh. All rights reserved.
//

import UIKit

@IBDesignable class CustomUIView: UIView {
    @IBInspectable var radius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.radius
        }
    }
}
