//
//  TabbedNavigationBar.swift
//  Version 0.1
//  Created by Oliver Poole on 27.04.16.
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

protocol TabbedNavigationBarDelegate {
  func tabbedNavigationBar(navigationBar: TabbedNavigationBar, didSelectOption option: String, atIndex index: Int)
}

class TabbedNavigationBar: UINavigationBar {

  private var collectonView: UICollectionView?
  private var options = [String]()
  
  var tabbedDelegate: TabbedNavigationBarDelegate?
  
  init(withTabs tabs: [String], navFrame: CGRect) {
    super.init(frame: navFrame)
    
    options = tabs
    
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.itemSize = CGSizeMake(100, 40)
    flowLayout.scrollDirection = .Horizontal
    
    let collectionViewFrame = CGRectMake(0, 0, navFrame.width, navFrame.height)
    collectonView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: flowLayout)
    
    collectonView!.dataSource = self
    collectonView!.backgroundColor = .clearColor()
    collectonView!.showsHorizontalScrollIndicator = false
    
    let navigationItem = UINavigationItem(title: "")
    navigationItem.titleView = collectonView!
    
    // Add the navigation item to the bar
    setItems([navigationItem], animated: true)
    
    collectonView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("Not implemented")
  }
  
  @objc private func tabbedButtonPressed(sender: UIButton) {
    tabbedDelegate?.tabbedNavigationBar(self, didSelectOption: sender.titleForState(.Normal)!, atIndex: sender.tag)
  }
}

extension TabbedNavigationBar: UICollectionViewDataSource {
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return options.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
    
    let button = UIButton(type: .System)
    
    button.setTitle(options[indexPath.row], forState: .Normal)
    button.setTitleColor(.blackColor(), forState: .Normal)
    
    button.sizeToFit()
    button.frame = CGRectMake(10, 10, button.frame.width, button.frame.height)
    
    button.tag = indexPath.row
    button.addTarget(self, action: .tabButtonAction, forControlEvents: .TouchUpInside)
    
    cell.addSubview(button)
    
    return cell
  }
}

private extension Selector {
  static let tabButtonAction = #selector(TabbedNavigationBar.tabbedButtonPressed(_:))
}
