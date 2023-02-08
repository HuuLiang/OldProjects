//
//  Router.swift
//  Viperit
//
//  Created by Ferran on 11/09/2016.
//  Copyright © 2016 Ferran Abelló. All rights reserved.
//

import UIKit

public protocol RouterProtocol {
    weak var _presenter: Presenter! { get set }
    var _view: UserInterface! { get }
    
    /// setup Window RootViewController
    ///
    /// - Parameters:
    ///   - window: window
    ///   - embedInNavController: 是否嵌入NavController中
    ///   - setupData: 需要传递的数据
    ///   - makeKeyAndVisible: 是否立即显示
    func show(inWindow window: UIWindow?, embedInNavController: Bool, setupData: Any?, makeKeyAndVisible: Bool)
    
    /// show ViewController push present
    ///
    /// - Parameters:
    ///   - from:
    ///   - embedInNavController: 是否嵌入NavController中
    ///   - setupData: 需要传递的数据
    func show(from: UIViewController, embedInNavController: Bool, setupData: Any?)
    
    /// addChildViewController
    ///
    /// - Parameters:
    ///   - containerView: 容器
    ///   - targetView: 目标Controller
    ///   - setupData: 需要传递的数据
    func show(from containerView: UIViewController, insideView targetView: UIView, setupData: Any?)
    
    /// present
    ///
    /// - Parameters:
    ///   - from:
    ///   - embedInNavController: 是否嵌入NavController中
    ///   - setupData: 需要传递的数据
    func showDetail(from: UIViewController, embedInNavController: Bool, setupData: Any?)
}

open class Router: RouterProtocol {
    public weak var _presenter: Presenter!
    public var _view: UserInterface! {
        return _presenter._view
    }
    
    open func show(inWindow window: UIWindow?, embedInNavController: Bool = false, setupData: Any? = nil, makeKeyAndVisible: Bool = true) {
        process(setupData: setupData)
        let view = embedInNavController ? embedInNavigationController() : _view
        window?.rootViewController = view
        if makeKeyAndVisible {
            window?.makeKeyAndVisible()
        }
    }
    
    open func show(from: UIViewController, embedInNavController: Bool = false, setupData: Any? = nil) {
        process(setupData: setupData)
        let view = embedInNavController ? embedInNavigationController() : _view
        //view.transitioningDelegate = nil
        from.show(view, sender: nil)
    }
    
    open func showDetail(from: UIViewController, embedInNavController: Bool = false, setupData: Any?) {
        process(setupData: setupData)
        let view = embedInNavController ? embedInNavigationController() : _view
        from.showDetailViewController(view, sender: nil)
    }
    
    public func show(from containerView: UIViewController, insideView targetView: UIView, setupData: Any? = nil) {
        process(setupData: setupData)
        addAsChildView(ofView: containerView, insideContainer: targetView)
    }
    
    required public init() { }
}

//MARK: - Process possible setup data
private extension Router {
    func process(setupData: Any?) {
        if let data = setupData {
            _presenter.setupView(data: data)
        }
    }
}

//MARK: - Embed view in navigation controller
public extension Router {
    private func getNavigationController() -> UINavigationController? {
        if let nav = _view.navigationController {
            return nav
        } else if let parent = _view.parent {
            if let parentNav = parent.navigationController {
                return parentNav
            }
        }
        return nil
    }
    
    func embedInNavigationController() -> UINavigationController {
        return getNavigationController() ?? UINavigationController(rootViewController: _view)
    }
}

//MARK: - Embed view in a container view
public extension Router {
    func addAsChildView(ofView parentView: UIViewController, insideContainer containerView: UIView) {
        parentView.addChildViewController(_view)
        containerView.addSubview(_view.view)
        stretchToBounds(containerView, view: _view.view)
        _view.didMove(toParentViewController: parentView)
    }
    
    private func stretchToBounds(_ holderView: UIView, view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let pinTop = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal,
                                        toItem: holderView, attribute: .top, multiplier: 1.0, constant: 0)
        let pinBottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal,
                                           toItem: holderView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let pinLeft = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal,
                                         toItem: holderView, attribute: .left, multiplier: 1.0, constant: 0)
        let pinRight = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal,
                                          toItem: holderView, attribute: .right, multiplier: 1.0, constant: 0)
        holderView.addConstraints([pinTop, pinBottom, pinLeft, pinRight])
    }
}
