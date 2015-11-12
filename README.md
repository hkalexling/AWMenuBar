# AWMenuBar

iOS implement of [This Dribbble concept design](https://dribbble.com/shots/1954664-CSS-Menu-Animations)

###Demo GIF:

![](https://github.com/hkalexling/AWMenuBar/blob/master/AWMenuBar.gif)

###Installation:

Simply drag and drop the (AWMenuBarView.swift)[https://github.com/hkalexling/AWMenuBar/blob/master/AWMenuBar/AWMenuBarView.swift] into your project

###Useage:

- In Storyboard, add a new `UIView` into your view controller and set the class of this newly added view to be `AWMenuBarView`. This `UIView` will be used as the menu bar
- Connect the `AWMenuBarView` into your view controller class
- In `viewDidLoad`, do something like this:

        override func viewDidLoad() {
		    super.viewDidLoad()
		
            //Customise the colors if you want
		    self.view.backgroundColor = UIColor(red: 51/255, green: 86/255, blue: 136/255, alpha: 1)
		    self.awMenuBar.backgroundColor = UIColor(red: 58/255, green: 95/255, blue: 149/255, alpha: 1)
            self.awMenuBar.menuBackGroundColor = UIColor.whiteColor()
    
            //Add as many buttons as you need
		    let baseY : CGFloat = 180
		    self.awMenuBar.addButton(baseY, text: "ABOUT")
		    self.awMenuBar.addButton(baseY + 80, text: "SHARE")
		    self.awMenuBar.addButton(baseY + 160, text: "ACTIVITY")
	    	self.awMenuBar.addButton(baseY + 240, text: "SETTINGS")
	    	self.awMenuBar.addButton(baseY + 320, text: "CONTACT")
		
            //Make sure to call the setup function
		    self.awMenuBar.setUp()
	    }

- To get call back for button click event, your viewController must conform to `AWMenuBarDelegate`. 

Example code to handle the call back:

    class ViewController: UIViewController, AWMenuBarDelegate{ //Conform to AWMenuBarDelegate
  
        //...
        //... Other set up
	    //...
	
        //use buttonTapped to handle button click call back
	      func buttonTapped(sender: UIButton) {
		      print ("\(sender.currentTitle!) tapped")
		      self.awMenuBar.closeMenu()
	      }
      }


