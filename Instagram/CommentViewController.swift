//
//  CommentViewController.swift
//  Instagram
//
//  Created by Liu Peiwen on 2021/04/23.
//

import UIKit
import Firebase

class CommentViewController: UIViewController {
    
    // 投稿データを格納する配列
    var postArray: [PostData] = []
    
    //選択されたrowのPostDataを格納する
    var postData: PostData!
    
    // Firestoreのデータ更新の監視を行うためのリスナー
    var listener: ListenerRegistration?
    
    @IBOutlet private weak var textfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.textfield.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        // ログイン済みか確認
        if Auth.auth().currentUser != nil {
            // listenerを登録して投稿データの更新を監視する
            let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
            listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                if let error = error {
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                    return
                }
                // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                self.postArray = querySnapshot!.documents.map { document in
                    print("DEBUG_PRINT: document取得 \(document.documentID)")
                    let postData = PostData(document: document)
                    return postData
                }

            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("DEBUG_PRINT: viewWillDisappear")
        // listenerを削除して監視を停止する
        listener?.remove()
    }
    
    
    @IBAction private func handleCommentButton(_ sender: Any) {
        print("DEBUG_PRINT: commentボタンがタップされました。")
        
        let name = Auth.auth().currentUser?.displayName
        print("commenter: \(name!)")
        let getComment = self.textfield.text!
        print("row_postData: \(postData.id), comment: \(getComment)")

        
        // commentを更新する
        if let myid = Auth.auth().currentUser?.uid {
            
            // comment更新データを作成する
            //let toUpdateComment: [String:String] = [name!: getComment]
            
//            let upDateCommenter: [String:String] = ["commenterName": name!]
//            let upDateComment: [String:String] = ["commentContent": getComment]
//
//            let toUpdateComment = [upDateCommenter: upDateComment]
            
            
            //------before
//            let postDic = [
//                "commentors": name!,
//                "commentsSend": getComment
//                ] as [String : Any]
//
//            // commentsReceivedに更新データを書き込む
//            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
//            //postRef.updateData(["commentsReceived": toUpdateComment])
//            postRef.updateData(["commentsReceived": postDic])
            
            //-----before------
            
            
            let postDic = ["commentor": name!, "comment": getComment]
            
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            
            var nowCommentCount: Int = 0

            postRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    
//                    for item in document.data()! {
//                        print("item: \(item)")
//                    }
                    
                    let getCommentCount = document.data()?["commentCounter"] as! Int
                    print("getCommentCount: \(getCommentCount)")
                    
                    nowCommentCount = getCommentCount
                    
                    // コメントデータを追加する
                    postRef.collection("commentsReceived").document(String(nowCommentCount)).setData(postDic)
                    
                    // 毎回コメント後に合計値+1
                    nowCommentCount += 1
                    
                    print("DEBUG_PRINT: nowCommentCount after update: \(nowCommentCount)")
                    
                    postRef.updateData(["commentCounter" : nowCommentCount])
                    
                } else {
                    print("Document does not exist")
                }
            }
            

            
        }

        
        // コメントした後Home画面に戻る
        self.dismiss(animated: true, completion: nil)
//        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! HomeViewController
//        self.present(homeViewController, animated: true, completion: nil)
    }
    
    @IBAction private func handleCancelButton(_ sender: Any) {
        // Home画面に戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Function

    

}

// MARK: - Extension
// UITextFieldデリゲート
extension CommentViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
