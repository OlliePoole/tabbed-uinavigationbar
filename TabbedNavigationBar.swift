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
  
  private var currentSelection: Int = 0
  
  var tabbedDelegate: TabbedNavigationBarDelegate?
  
  init(withTabs tabs: [String], navFrame: CGRect) {
    super.init(frame: navFrame)
    
    options = tabs
    
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.itemSize = CGSizeMake(90, 40) // TODO: Make this dynamic for contents
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
    
    collectonView?.registerClass(TabbedCollectionViewCell.self, forCellWithReuseIdentifier: "TabbedCollectionViewCell")
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("Not implemented")
  }
  
  func setItemSelected(itemIndex: Int) {
    let previousSelection = currentSelection
    currentSelection = itemIndex
    
    var indexPaths = [NSIndexPath(forItem: currentSelection, inSection: 0)]
    if previousSelection != currentSelection {
      indexPaths.append(NSIndexPath(forItem: previousSelection, inSection: 0))
    }
    
    collectonView?.reloadItemsAtIndexPaths(indexPaths)
    
    collectonView?.scrollToItemAtIndexPath(NSIndexPath(forItem: currentSelection, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: true)
  }
  
  @objc private func tabbedButtonPressed(sender: UIButton) {
    let previousSelection = currentSelection
    currentSelection = sender.tag
    tabbedDelegate?.tabbedNavigationBar(self, didSelectOption: sender.titleForState(.Normal)!, atIndex: sender.tag)
    
    var indexPaths = [NSIndexPath(forItem: currentSelection, inSection: 0)]
    if previousSelection != currentSelection {
      indexPaths.append(NSIndexPath(forItem: previousSelection, inSection: 0))
    }
    
    collectonView?.reloadItemsAtIndexPaths(indexPaths)
  }
}

extension TabbedNavigationBar: UICollectionViewDataSource {
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return options.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TabbedCollectionViewCell", forIndexPath: indexPath) as! TabbedCollectionViewCell
    
    if cell.hasBeenCreated {
      // update contents of cell
      cell.updateButton(isSelected: (currentSelection == indexPath.row), title: options[indexPath.row], tag: indexPath.row)
    }
    else {
      // create cell
      cell.createButton(isSelected: (currentSelection == indexPath.row), title: options[indexPath.row], tag: indexPath.row, buttonTarget: self)
    }
    
    return cell
  }
}

private class TabbedCollectionViewCell: UICollectionViewCell {
  
  let button = UIButton(type: .System)
  var hasBeenCreated: Bool = false
  
  private func styleButton(isSelected selected: Bool, title: String, tag: Int) {
    button.setTitle(title, forState: .Normal)
    button.setTitleColor((selected) ? .blackColor() : .grayColor(), forState: .Normal)
    
    button.titleLabel?.font = (selected) ? ThemeManager.Fonts.Medium(14) : ThemeManager.Fonts.Book(14)
    
    button.sizeToFit()
    button.frame = CGRectMake(10, 10, button.frame.width, button.frame.height)
    
    button.tag = tag
  }
  
  func createButton(isSelected selected: Bool, title: String, tag: Int, buttonTarget: AnyObject) {
    hasBeenCreated = true
    
    styleButton(isSelected: selected, title: title, tag: tag)
    button.addTarget(buttonTarget, action: .tabButtonAction, forControlEvents: .TouchUpInside)
    
    addSubview(button)
  }
  
  func updateButton(isSelected selected: Bool, title: String, tag: Int) {
    styleButton(isSelected: selected, title: title, tag: tag)
  }
}

private extension Selector {
  static let tabButtonAction = #selector(TabbedNavigationBar.tabbedButtonPressed(_:))
}
