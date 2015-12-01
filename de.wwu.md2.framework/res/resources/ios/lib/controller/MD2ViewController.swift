//
//  MD2ViewController.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 21.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

import UIKit

/// Custom view controller for all MD2 views that wraps the view layout specified in the model.
class MD2ViewController: UIViewController {

    /// The root view layout container.
    var layout: MD2Layout
    
    /// An auto-generated scroll-view to support long forms.
    var scrollView: UIScrollView
    
    /// Size of the view (set to the screen dimensions).
    var dimensions: MD2Dimension
    
    /// Initialize the controller with the layout to wrap.
    init(layout: MD2Layout) {
        self.layout = layout
        self.scrollView = UIScrollView()
        self.dimensions = MD2UIUtil.CGRectToDimension(UIScreen.mainScreen().bounds)
        super.init(nibName: nil, bundle: nil)
    }

    /// Unsupported initializer (required by inheritance)
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Add programmatically created view elements when the view loads.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.whiteColor()
        
        // Add the scroll view to the root view.
        self.view.addSubview(scrollView)
        
        // Render the desired layout in the scroll view.
        layout.render(self.scrollView, controller: self)
    }

    /// Handle view state when memory warning is issued.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Calculate the view controller's dimensions using the full screen size as default.
    func calculateDimensions() {
        dimensions = MD2UIUtil.CGRectToDimension(UIScreen.mainScreen().bounds)
        calculateDimensions(dimensions)
    }
    
    /// Calculate the view controller's dimensions based on given bounds.
    func calculateDimensions(dimensions: MD2Dimension) {
        self.dimensions = dimensions
        scrollView.frame = MD2UIUtil.dimensionToCGRect(dimensions)
        
        // Add small padding along the screen border
        var result = layout.calculateDimensions(dimensions + MD2Dimension(x: MD2ViewConfig.GUTTER, y: 2 * MD2ViewConfig.GUTTER, width: -1 * MD2ViewConfig.GUTTER, height: -1 * MD2ViewConfig.GUTTER))
        
        // Add extra space on the bottom if content overflows
        if result.height > dimensions.height {
            result = result + MD2Dimension(x: 0, y: 0, width: 0, height: 20)
        }
        
        // Set scroll view size
        scrollView.contentSize = MD2UIUtil.dimensionToCGSize(result)

    }
    
    /// Notify view manager about orientation change
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        MD2ViewManager.instance.rotateScreen(size)
    }
}
