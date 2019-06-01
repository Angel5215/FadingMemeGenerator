//
//  ViewController.swift
//  FadingMemeGenerator
//
//  Created by Angel Vázquez on 5/30/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    var firstImage: UIImage?
    var secondImage: UIImage?
    
    /// Used to determine which button was tapped.
    var imageType = 0
    
    var actionButton: UIBarButtonItem!
    var refreshButton: UIBarButtonItem!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage))
        refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        navigationItem.rightBarButtonItems = [refreshButton, actionButton]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Swap", style: .plain, target: self, action: #selector(swapImages))
        updateButtons()
    }
    
    // MARK: - Actions
    @IBAction func selectImage(_ sender: UIButton) {
        imageType = sender.tag
        
        let controller = UIImagePickerController()
        controller.allowsEditing = true
        controller.delegate = self
        present(controller, animated: true)
    }
    
    // MARK: - Methods
    /// Draws the first and second images inside an image view with varying opacity.
    /// The offset is used to give the images a little space between them.
    func processImages() {
        let size = imageView.frame.size
        let renderer = UIGraphicsImageRenderer(size: size)
        let offset: CGFloat = 2
        let image = renderer.image { context in
            firstImage?.draw(in: CGRect(x: 0, y: 0, width: size.width / 2 - offset, height: size.height / 2 - offset))
            firstImage?.draw(in: CGRect(x: size.width / 2 + offset, y: 0, width: size.width / 2 - offset, height: size.height / 2 - offset), blendMode: .normal, alpha: 0.6)
            firstImage?.draw(in: CGRect(x: 0, y: size.height / 2 + offset, width: size.width / 2 - offset, height: size.height / 2 - offset), blendMode: .normal, alpha: 0.4)
            
            secondImage?.draw(in: CGRect(x: size.width / 2 + offset, y: 0, width: size.width / 2 - offset, height: size.height / 2 - offset), blendMode: .normal, alpha: 0.4)
            secondImage?.draw(in: CGRect(x: 0, y: size.height / 2 + offset, width: size.width / 2 - offset, height: size.height / 2 - offset), blendMode: .normal, alpha: 0.6)
            secondImage?.draw(in: CGRect(x: size.width / 2 + offset, y: size.height / 2 + offset, width: size.width / 2 - offset, height: size.height / 2 - offset))
        }
        
        imageView.image = image
    }
    
    func updateButtons() {
        actionButton.isEnabled = (firstImage != nil && secondImage != nil)
    }
    
    @objc func shareImage() {
        guard let image = imageView.image else { return }
        let ac = UIActivityViewController(activityItems: [image, "Fading image generator"], applicationActivities: nil)
        present(ac, animated: true)
    }
    
    @objc func refresh() {
        firstImage = nil
        secondImage = nil
        imageView.image = nil
        updateButtons()
    }
    
    @objc func swapImages() {
        let temp = firstImage
        firstImage = secondImage
        secondImage = temp
        processImages()
    }
}

// MARK: - View controller -> ImagePicker Delegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        switch imageType {
        case 0:
            firstImage = image
        case 1:
            secondImage = image
        default:
            break
        }
        
        updateButtons()
        processImages()
        dismiss(animated: true)
    }
}
