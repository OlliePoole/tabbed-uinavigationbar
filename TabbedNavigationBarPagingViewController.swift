//
//  TabbedNavigationBarPagingViewController.swift
//  Version 0.1
//  Created by Oliver Poole on 18.05.16.
//

// This code is distributed under the terms and conditions of the MIT license.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

class TabbedNavigationBarPagingViewController: UIViewController {
  
  private var tabbedNavBar: TabbedNavigationBar?
  private var pageViewController: SimplePageViewController?
  
  /// The values to display for each section
  var navigationHeaders: [String]
  
  /// The first tab to select - Defaults to 0
  var initalTab = 0 {
    didSet {
      currentSelection = initalTab
      
      assert(initalTab < viewControllersToDisplay.count,
             "You cannot have an inital tab higher than the number of view controllers to display")
    }
  }
  
  /// The currently selected tab
  var currentSelection = 0
  
  /// The view controllers to display.
  /// Must match order of navigation headers
  var viewControllersToDisplay: [UIViewController]
  
  
  /**
   Default initalizer
   
   - parameter headers:         The headers to use
   - parameter viewControllers: The matching view controllers to display
   */
  init(withNavigationHeaders headers: [String], viewControllers: [UIViewController]) {
    navigationHeaders = headers
    viewControllersToDisplay = viewControllers
    
    super.init(nibName: nil, bundle: nil)
    
    assert(navigationHeaders.count == viewControllersToDisplay.count,
           "The number of headers provided does not match the number of view controllers")
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    // Add the Tabbed Navigation Bar
    if let navFrame = navigationController?.navigationBar.frame {
      tabbedNavBar = TabbedNavigationBar(withTabs: navigationHeaders, navFrame: navFrame)
      tabbedNavBar?.setItemSelected(initalTab)
      
      tabbedNavBar?.tabbedDelegate = self
      
      navigationItem.titleView = tabbedNavBar?.topItem?.titleView
    }
  }

  
  override func viewDidLoad() {
    super.viewDidLoad()
        
    pageViewController = SimplePageViewController(withViewControllers: viewControllersToDisplay)
    
    // set the first view controller
    pageViewController?.setViewControllers([viewControllersToDisplay[initalTab]], direction: .Forward, animated: false, completion: nil)
    
    addChildViewController(pageViewController!)
    pageViewController?.didMoveToParentViewController(self)
    pageViewController?.view.frame = CGRectMake(0, 62, view.frame.width, view.frame.height)
    
    pageViewController?.pageDelegate = self
    
    view.addSubview(pageViewController!.view)
  }
}

// MARK: - TabbedNavigationBarDelegate
extension TabbedNavigationBarPagingViewController: TabbedNavigationBarDelegate {
  
  func tabbedNavigationBar(navigationBar: TabbedNavigationBar, didSelectOption option: String, atIndex index: Int) {
    // move page view controller to selected index
    var direction: UIPageViewControllerNavigationDirection?
    
    if currentSelection < index {
      direction = .Forward
    } else {
      direction = .Reverse
    }
    
    pageViewController?.moveToViewController(atIndex: index, direction: direction!)
    
    currentSelection = index
  }
  
}

// MARK: - SimplePageViewControllerDelegate
extension TabbedNavigationBarPagingViewController: SimplePageViewControllerDelegate {
  
  func simplePageViewController(pageViewController: SimplePageViewController, didMoveToPage page: UIViewController) {
    if let controllerIndex = viewControllersToDisplay.indexOf(page) {
      tabbedNavBar?.setItemSelected(controllerIndex)
    }
  }
  
}
