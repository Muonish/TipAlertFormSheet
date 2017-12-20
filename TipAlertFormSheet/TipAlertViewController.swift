//
//  TipAlertViewController.swift
//  TargetProcess
//
//  Created by Valeria Breshko on 12/19/17.
//

import Foundation
import UIKit

class TipAlertViewController: UIViewController, SheetTransitioningController {

    public var backgroundView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return view
    }()

    public var bottomConstraint: NSLayoutConstraint?
    let transition = SheetAnimatedTransitioning()

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        let isPad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
        modalPresentationStyle = isPad ? .overCurrentContext : .overFullScreen
        transitioningDelegate = self
        preferredContentSize = CGSize(width: 300, height: 400)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onBackgroundTap(_:)))
        backgroundView.addGestureRecognizer(gestureRecognizer)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
    }

    @IBAction func onGotIt(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func onBackgroundTap(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension TipAlertViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = true
        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
