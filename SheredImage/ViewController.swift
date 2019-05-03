//
//  ViewController.swift
//  SheredImage
//
//  Created by sun on 2/5/2562 BE.
//  Copyright © 2562 sun. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIDropInteractionDelegate ,UIDragInteractionDelegate{
    
    
    // /-----------------------------------------------------------------------------------------------------/
    
    
    // draged image และทำให้เคลื่ยนย้ายภาพได้
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        
        
        let touchPoint = session.location(in: self.view)
        if let touchImageView = self.view.hitTest(touchPoint, with: nil) as? UIImageView {
            
            let touchImage = touchImageView.image
            print(touchImage)
            
            
            let itemProvider = NSItemProvider(object: touchImage!)
            
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = touchImageView
            
            return [dragItem]
        }
        
        
        
        return []
    }
    
    
    
    func dragInteraction(_ interaction: UIDragInteraction, willAnimateLiftWith animator: UIDragAnimating, session: UIDragSession) {
        session.items.forEach { (dragItem) in
            if let touchedImageView = dragItem.localObject as? UIView {
                
                touchedImageView.removeFromSuperview()
                
            }
        }
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, item: UIDragItem, willAnimateCancelWith animator: UIDragAnimating) {
        self.view.addSubview(item.localObject as! UIView)
    }
    
    
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        return UITargetedDragPreview(view: item.localObject as! UIView)
    }
    
// /------------------------------------------------------------------------------------------------------------------/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addInteraction(UIDropInteraction(delegate: self))
        view.addInteraction(UIDragInteraction(delegate: self))
       
    }
    
    
   // /----------------------------------------------------------------------------------------------------------------/
    
    // dragged and drop image
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        for dragItem in session.items {
            dragItem.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (obj, err) in
                
                if let err = err {
                    print("Failed to load our dragged item" , err)
                    return
                }
                
                guard let draggedImage = obj as? UIImage else { return }
                
              
                
                DispatchQueue.main.async {
                    
                     let imageView = UIImageView(image: draggedImage)
                    
                    imageView.isUserInteractionEnabled = true
                    
                    self.view.addSubview(imageView)
                    
                    
                    
                    imageView.frame = CGRect(x: 0, y: 0, width: draggedImage.size.width, height: draggedImage.size.height)
                    
                let centerPoint = session.location(in: self.view)
                    imageView.center = centerPoint
                    
                    
                    
                }
          
                
                
                })
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }

 // /-----------------------------------------------------------------------------------------------------------------/
}

