//
//  Created by Pierluigi Cifani on 09/05/16.
//  Copyright © 2018 TheLeftBit SL. All rights reserved.
//

import Foundation

public protocol PhotoGalleryViewControllerDelegate: class {
    func photoGalleryController(_ photoGalleryController: PhotoGalleryViewController, willDismissAtPageIndex index: UInt)
}

public final class PhotoGalleryViewController: UIViewController {
    
    private let photosGallery: PhotoGalleryView
    public var allowShare: Bool
    public weak var presentFromView: UIView?
    public weak var delegate: PhotoGalleryViewControllerDelegate?
    public var currentPage: UInt = 0
    public var photos: [Photo] {
        return photosGallery.photos
    }

    public init(photos: [Photo],
         presentFromView: UIView? = nil,
         initialPageIndex: UInt = 0,
         allowShare: Bool = true) {
        self.presentFromView = presentFromView
        self.allowShare = allowShare
        self.photosGallery = PhotoGalleryView(photos: photos, imageContentMode: .scaleAspectFit)
        self.currentPage = initialPageIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var prefersStatusBarHidden : Bool {
        return true
    }

    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_) in
            self.photosGallery.invalidateLayout()
        }, completion: nil)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black

        //Set up the Gallery
        view.addSubview(photosGallery)
        photosGallery.pinToSuperview()
        
        //Add the close button
        let closeButton = UIButton(type: UIButton.ButtonType.custom)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage.templateImage(.close), for: .normal)
        closeButton.addTarget(self, action: #selector(onCloseButton), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        closeButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 12).isActive = true
        
        view.layoutIfNeeded()
        photosGallery.scrollToPhoto(atIndex: currentPage)
    }
    
    public override var shouldAutorotate: Bool {
        return true
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    //MARK:- IBActions
    
    @objc func onCloseButton() {
        delegate?.photoGalleryController(self, willDismissAtPageIndex: photosGallery.currentPage)
    }
}
