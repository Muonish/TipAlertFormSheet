//
//  SheetAnimatedTransitioning.swift
//  TargetProcess
//
//  Created by Valeria Breshko on 12/20/17.
//

import Foundation
import UIKit

public protocol SheetTransitioningController {
    var preferredContentSize: CGSize { get }
    var view: UIView! { get }
    var backgroundView: UIView { get }
    var bottomConstraint: NSLayoutConstraint? { get set }
}

class SheetAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 0.5
    var presenting = true

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard var viewController = transitionContext.viewController(forKey: presenting ? .to : .from)
            as? SheetTransitioningController else {
            return
        }

        let preferredSize = viewController.preferredContentSize
        let backgroundView = viewController.backgroundView

        if presenting {
            setupConstraints(presentingViewController: viewController,
                             containerView: containerView)
            backgroundView.alpha = 0
        }

        viewController.bottomConstraint?.constant = presenting ? 0 : preferredSize.height
        containerView.setNeedsLayout()

        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: presenting ? .curveEaseOut : .curveEaseIn,
                       animations: {
                        backgroundView.alpha = self.presenting ? 1 : 0
                        containerView.layoutIfNeeded()
        }, completion: { _ in
            if !self.presenting {
                backgroundView.removeFromSuperview()
            }
            transitionContext.completeTransition(true)
        })
    }

    private func setupConstraints(presentingViewController: SheetTransitioningController,
                                  containerView: UIView) {
        var viewController = presentingViewController
        guard let targetView = viewController.view else {
            return
        }
        let preferredHeight = viewController.preferredContentSize.height
        let backgroundView = viewController.backgroundView

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        targetView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(backgroundView)
        containerView.addSubview(targetView)

        backgroundView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true

        let leading = NSLayoutConstraint(item: targetView, attribute: .leading, relatedBy: .equal,
                                         toItem: containerView, attribute: .leading,
                                         multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: targetView, attribute: .trailing, relatedBy: .equal,
                                          toItem: containerView, attribute: .trailing,
                                          multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: targetView, attribute: .height, relatedBy: .equal,
                                        toItem: nil, attribute: .notAnAttribute,
                                        multiplier: 1, constant: preferredHeight)
        let bottom = NSLayoutConstraint(item: targetView, attribute: .bottom, relatedBy: .equal,
                                        toItem: containerView, attribute: .bottom,
                                        multiplier: 1, constant: preferredHeight)
        containerView.addConstraints([leading, trailing, height, bottom])
        viewController.bottomConstraint = bottom
        containerView.setNeedsLayout()
        containerView.layoutIfNeeded()
    }
}
