//
//  InspectorsTabController.swift
//  Peek-Example
//
//  Created by Shaps Benkau on 21/02/2018.
//  Copyright © 2018 Snippex. All rights reserved.
//

import UIKit
import GraphicsRenderer

internal final class InspectorsTabController: UITabBarController {
    
    fileprivate let model: Model & Peekable
    unowned var peek: Peek
    fileprivate let context: Context
    
    init(peek: Peek, model: Model & Peekable) {
        self.model = model
        self.peek = peek
        self.context = PeekContext()
        
        if let view = model as? UIView {
            view.preparePeek(context)
            view.layer.preparePeek(context)
            view.owningViewController()?.preparePeek(context)
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationStyle = .popover
        preferredContentSize = CGSize(width: 375, height: CGFloat.greatestFiniteMagnitude)
        
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.backgroundColor = .inspectorBackground
        tabBar.tintColor = .primaryTint
        tabBar.isHidden = true
        
        if #available(iOS 10.0, *) {
            tabBar.unselectedItemTintColor = .lightGray
        }
        
        let inspector = InspectorViewController(peek: peek, model: model)
        let nav = UINavigationController(rootViewController: inspector)
        
        inspector.title = "Peek"
        inspector.tabBarItem.image = Images.inspectorImage(.attributes)
        
        viewControllers = [nav]
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.index(of: item) {
            guard let nav = viewControllers?[index] as? UINavigationController,
                let inspector = nav.viewControllers.first as? InspectorViewController else {
                    fatalError()
            }
            
            print(inspector)
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return peek.supportedOrientations
    }
    
    // MARK: Unused
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}