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
        
        
//        จุดที่แตะ
        let touchPoint = session.location(in: self.view)
        if let touchImageView = self.view.hitTest(touchPoint, with: nil) as? UIImageView {
            
            
            // ภาพที่แตะ
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
                
//                ถ้าภาพถูกเคลื่นที่ ภาพเก่าที่จุดเดิมจะถูกลบ
                touchedImageView.removeFromSuperview()
                
            }
        }
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, item: UIDragItem, willAnimateCancelWith animator: UIDragAnimating) {
        
//        เพิ่มภาพที่ถูกลากเปลี่ยนตำแหน่งใหม่ใร view
        self.view.addSubview(item.localObject as! UIView)
    }
    
    
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        
        // ถ้าภาพถูกลากออกไปจากขอบของแอพจะกลับมาที่เดิม
        return UITargetedDragPreview(view: item.localObject as! UIView)
    }
    
// /------------------------------------------------------------------------------------------------------------------/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Sunny Collage Sharing"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
        view.addInteraction(UIDropInteraction(delegate: self))
        view.addInteraction(UIDragInteraction(delegate: self))
       
    }
    
    
   @objc func handleShare()  {
    
        print("Share image")
    
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
    
    // image of viewframe
    guard let image = UIGraphicsGetImageFromCurrentImageContext() else {return}
    
    UIGraphicsEndImageContext()
    
    // obj shared
    let activityViewController = UIActivityViewController(activityItems: [image,"Sharing this nice image"], applicationActivities: nil)
    
    // shared button
    activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    //shared
    present(activityViewController, animated: true,completion: nil)
    
    
    
    
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
                
      // guard ป้องกัน ไม่ให้ program error ถ้า draggedImage ไม่ใช่ UIImage
                guard let draggedImage = obj as? UIImage else { return }
                
              
                
                DispatchQueue.main.async {
                    
                     let imageView = UIImageView(image: draggedImage)
                    
                    imageView.isUserInteractionEnabled = true
                    imageView.layer.borderColor = UIColor.black.cgColor  // สีขอบเป็นสีดำ
                    imageView.layer.shadowRadius = 5 // เงาขอบ
                    imageView.layer.shadowOpacity = 0.3 // ความเข้มของเงาขอบ
                    
  //                  เพื่มภาพใน layer
                    self.view.addSubview(imageView)
                    
                    
//                    กำหนดขนาด
                    imageView.frame = CGRect(x: 0, y: 0, width: draggedImage.size.width, height: draggedImage.size.height)
                    
//                    จุดที่วางรูปให้เป็นตรงกลางนิ้ว
                let centerPoint = session.location(in: self.view)
                    imageView.center = centerPoint
                    
                    
                    
                }
          
                
                
                })
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy) // copyภาพที่ลากมาในแอพ
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }

 // /-----------------------------------------------------------------------------------------------------------------/
}

