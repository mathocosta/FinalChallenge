//
//  ImagePicker.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 12/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
}

class ImagePicker: NSObject {
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?

    init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        super.init()

        self.presentationController = presentationController
        self.delegate = delegate

        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }

    func present(from sourceView: UIView) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = action(for: .camera, title: "Tirar uma foto") {
            alertController.addAction(action)
        }

        if let action = action(for: .savedPhotosAlbum, title: "Rolo da câmera") {
            alertController.addAction(action)
        }

        if let action = action(for: .photoLibrary, title: "Galeria") {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(alertController, animated: true)
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)

        delegate?.didSelect(image: image)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pickerController(picker, didSelect: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return pickerController(picker, didSelect: nil)
        }
        pickerController(picker, didSelect: image)
    }
}
