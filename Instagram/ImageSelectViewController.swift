//
//  ImageSelectViewController.swift
//  Instagram
//
//  Created by Liu Peiwen on 2021/04/21.
//

import UIKit
import CLImageEditor

class ImageSelectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction private func handleLibraryButton(_ sender: Any) {
        // ライブラリ（カメラロール）を指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction private func handleCameraButton(_ sender: Any) {
        // カメラを指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction private func handleCancelButton(_ sender: Any) {
        // 画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Extension
// UIImagePickerControllerデリゲート
extension ImageSelectViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    /// 写真を撮影/選択した時に呼ばれるメソッド
    /// - Parameters:
    ///   - picker: UIImagePickerController
    ///   - info: 選択した画像情報
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 撮影/選択された画像を取得する
        let image = info[.originalImage] as! UIImage
        
        // 後でCLImageEditorライブラリで加工する
        print("DEBUG_PRINT: image = \(image)")
        // CLImageEditorにimageを渡して、加工画面を起動する
        let editor = CLImageEditor(image: image)!
        editor.delegate = self
        editor.modalPresentationStyle = .fullScreen
        picker.present(editor, animated: true, completion: nil)
    }
    
    /// キャンセルをタップした時に呼ばれるメソッド
    /// - Parameter picker: UIImagePickerController
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // ImageSelectViewController画面を閉じてタブ画面に戻る
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

// CLImageEditorライブラリ
extension ImageSelectViewController: CLImageEditorDelegate {

    /// CLImageEditorで加工が終わった時に呼ばれるメソッド
    /// - Parameters:
    ///   - editor: CLImageEditor
    ///   - image: 加工済み画像
    func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!) {
        // 投稿画面を開く
        let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! PostViewController
        postViewController.image = image!
        editor.present(postViewController, animated: true, completion: nil)
    }
    
    /// CLImageEditorの編集がキャンセルされた時に呼ばれるメソッド
    /// - Parameter editor: CLImageEditor
    func imageEditorDidCancel(_ editor: CLImageEditor!) {
        // ImageSelectViewController画面を閉じてタブ画面に戻る
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

}
