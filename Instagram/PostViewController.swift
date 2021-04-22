//
//  PostViewController.swift
//  Instagram
//
//  Created by Liu Peiwen on 2021/04/21.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController {
    
    var image: UIImage!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // 投稿ボタンをタップしたときに呼ばれるメソッド
    @IBAction func handlePostButton(_ sender: Any) {
    }
    
    // キャンセルボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleCancelButton(_ sender: Any) {
    }
    

}
