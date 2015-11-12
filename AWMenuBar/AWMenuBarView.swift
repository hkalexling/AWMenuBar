//
//  AWMenuBarView.swift
//  AWMenuBar
//
//  Created by Alex Ling on 13/11/2015.
//  Copyright © 2015 Alex Ling. All rights reserved.
//

import UIKit

protocol AWMenuBarDelegate {
	func buttonTapped(sender : UIButton)
}

class AWMenuBarView: UIView {
	
	var delegate : AWMenuBarDelegate?
	
	var animationDuration = NSTimeInterval(0.3)
	var scaleDuration = NSTimeInterval(0.5)
	
	var menuBackGroundColor : UIColor = UIColor.whiteColor()
	var buttonTitleColor : UIColor!
	
	private let screenWidth = UIScreen.mainScreen().bounds.size.width
	private let screenHeight = UIScreen.mainScreen().bounds.size.height
	
	private let buttonView = UIView()
	
	private let upperLine = UIView()
	private let middleLine = UIView()
	private let bottomLine = UIView()
	
	private let scalableMenuView = UIView()
	private var scale : CGFloat!
	
	private var upInitialCenter : CGPoint!
	private var bottomInitialCenter : CGPoint!
	
	private var rotationState : Int = 0
	
	private var buttons : [UIButton] = []
	private var buttonFinalY : [CGFloat] = []
	
	func setUp(){
		self.layer.shadowColor = UIColor.blackColor().CGColor
		self.layer.shadowOffset = CGSize(width: 0, height: 5)
		self.layer.shadowOpacity = 0.2
		
		self.buttonView.frame = CGRectMake(self.frame.height/3 * 0.8, self.frame.height/3, self.frame.height/3 * 1.2, self.frame.height/3)
		
		let lineHeight = self.buttonView.frame.height/7
		self.upperLine.frame = CGRectMake(0, 0, self.buttonView.frame.width, lineHeight)
		self.middleLine.frame = CGRectMake(0, self.buttonView.frame.height/2 - lineHeight/2, self.buttonView.frame.width, lineHeight)
		self.bottomLine.frame = CGRectMake(0, self.buttonView.frame.height - lineHeight, self.buttonView.frame.width, lineHeight)
		
		self.upInitialCenter = self.upperLine.center
		self.bottomInitialCenter = self.bottomLine.center
		
		self.scalableMenuView.frame = CGRectMake(self.middleLine.center.x - lineHeight/2, self.middleLine.center.y - lineHeight/2, lineHeight, lineHeight)
		self.scalableMenuView.layer.cornerRadius = self.scalableMenuView.frame.width/2
		self.scalableMenuView.clipsToBounds = true
		self.scalableMenuView.layer.masksToBounds = true
		self.scalableMenuView.layer.anchorPoint = CGPointMake(0.5, 0.5)
		self.scalableMenuView.backgroundColor = self.menuBackGroundColor
		self.buttonView.addSubview(self.scalableMenuView)
		
		self.upperLine.backgroundColor = self.menuBackGroundColor
		self.middleLine.backgroundColor = self.menuBackGroundColor
		self.bottomLine.backgroundColor = self.menuBackGroundColor
		
		self.buttonView.addSubview(self.upperLine)
		self.buttonView.addSubview(self.middleLine)
		self.buttonView.addSubview(self.bottomLine)
		
		let tapRec = UITapGestureRecognizer(target: self, action: Selector("tapped"))
		self.buttonView.addGestureRecognizer(tapRec)
		
		self.addSubview(self.buttonView)

	}
	
	func addButton(centerY : CGFloat, text : String){
		
		if self.buttonTitleColor == nil {
			self.buttonTitleColor = self.backgroundColor
		}
		
		self.buttonFinalY.append(centerY)
		let button = UIButton(frame: CGRectMake(self.screenWidth/4, centerY - 15, self.screenWidth/2, 30))
		button.backgroundColor = UIColor.clearColor()
		button.setTitleColor(self.buttonTitleColor, forState: .Normal)
		button.setTitle(text, forState: .Normal)
		button.titleLabel!.font = UIFont.systemFontOfSize(23)
		button.hidden = true
		button.addTarget(self, action: Selector("handleTap:"), forControlEvents: .TouchDown)
		self.superview!.addSubview(button)
		self.buttons.append(button)
	}
	
	func handleTap(sender : UIButton){
		delegate?.buttonTapped(sender)
	}
	func buttonTapped(sender : UIButton){}
	
	func tapped(){
		if self.rotationState == 0{
			self.rotationState = 1
			self.openMenu()
		}
		if self.rotationState == 2{
			self.rotationState = 1
			self.closeMenu()
		}
	}
	
	func openMenu(){
		for i in 0..<self.buttons.count{
			let button = buttons[i]
			if i == 0{
				button.hidden = false
			}
			button.center = CGPointMake(button.center.x, self.buttonFinalY[i] - 30.0)
			UIView.animateWithDuration(0.2, delay: NSTimeInterval(CGFloat(i) * 0.08), options: [], animations: {
				button.center = CGPointMake(button.center.x, self.buttonFinalY[i])
				}, completion: {(finished) in
					if i != self.buttons.count - 1{
						self.buttons[i + 1].hidden = false
					}
			})
		}
		
		UIView.animateWithDuration(self.animationDuration, animations: {
			self.middleLine.alpha = 0
			self.upperLine.center = self.middleLine.center
			self.bottomLine.center = self.middleLine.center
			}, completion: {(finished) in
				self.rotationState = 2
		})
		UIView.animateWithDuration(self.scaleDuration, animations: {
			self.upperLine.backgroundColor = self.backgroundColor
			self.middleLine.backgroundColor = self.backgroundColor
			self.bottomLine.backgroundColor = self.backgroundColor
			
			self.scale = CGFloat(hypotf(Float(self.scalableMenuView.center.x - self.screenWidth), Float(self.scalableMenuView.center.y - self.screenHeight)))/(self.scalableMenuView.frame.width/2)
			self.scalableMenuView.transform = CGAffineTransformScale(self.scalableMenuView.transform, self.scale, self.scale)
			}, completion: {(finished) in
				self.rotationState = 2
		})
		let animation = CABasicAnimation(keyPath: "transform.rotation.z")
		animation.duration = self.animationDuration
		animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
		animation.removedOnCompletion = false
		animation.fillMode = kCAFillModeForwards
		animation.byValue = NSNumber(float: Float(M_PI) / 4)
		self.upperLine.layer.addAnimation(animation, forKey: nil)
		animation.byValue = NSNumber(float: Float(M_PI) * 3/4)
		self.bottomLine.layer.addAnimation(animation, forKey: nil)
	}
	
	func closeMenu(){
		for i in 0..<self.buttons.count{
			let button = buttons[i]
			button.hidden = true
		}
		
		UIView.animateWithDuration(self.animationDuration, animations: {
			self.middleLine.alpha = 1
			self.upperLine.center = self.upInitialCenter
			self.bottomLine.center = self.bottomInitialCenter
			}, completion: {(finished) in
				self.rotationState = 0
		})
		UIView.animateWithDuration(self.scaleDuration, animations: {
			self.upperLine.backgroundColor = self.menuBackGroundColor
			self.middleLine.backgroundColor = self.menuBackGroundColor
			self.bottomLine.backgroundColor = self.menuBackGroundColor
			
			self.scalableMenuView.transform = CGAffineTransformScale(self.scalableMenuView.transform, 1/self.scale, 1/self.scale)
			}, completion: {(finished) in
				self.rotationState = 0
		})
		let animation = CABasicAnimation(keyPath: "transform.rotation.z")
		animation.duration = self.animationDuration
		animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
		animation.removedOnCompletion = false
		animation.fillMode = kCAFillModeForwards
		animation.byValue = NSNumber(float: Float(M_PI) / -4)
		self.upperLine.layer.addAnimation(animation, forKey: nil)
		animation.byValue = NSNumber(float: Float(M_PI) * -3/4)
		self.bottomLine.layer.addAnimation(animation, forKey: nil)
	}

}
