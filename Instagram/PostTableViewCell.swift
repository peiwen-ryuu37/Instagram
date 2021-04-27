//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by Liu Peiwen on 2021/04/22.
//

import UIKit
import FirebaseUI
import Firebase

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commenterLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var commentStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.commenterLabel.text = "コメント"
        self.commentLabel.text = "0"

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // PostDataの内容をセルに表示
    func setPostData(_ postData: PostData) {
        
        // 画像の表示
        self.postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        self.postImageView.sd_setImage(with: imageRef)
        
        // キャプションの表示
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        
        // 日時の表示
        self.dateLabel.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            self.dateLabel.text = dateString
        }
        
        // いいね数の表示
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        // いいねボタンの表示
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
        

        if postData.commentCounter != 0 {
            // 元にあるstackViewを削除
            self.commentStackView.subviews.forEach { (view) in
                view.removeFromSuperview()
            }
            
            self.commentLabel.text = String(postData.commentCounter ?? 0)
            

            for count in 0..<postData.commentCounter! {

                print("###########\(String(postData.caption!)): \(count)")
                //self.getCommentData(postData, count)
                
                let toaddCommentLabel = UILabel()
                //toaddCommentLabel.backgroundColor = UIColor.customRed
                toaddCommentLabel.text = postData.commentsArray[count]
                toaddCommentLabel.textAlignment = .center
                toaddCommentLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
                self.commentStackView.addArrangedSubview(toaddCommentLabel)

            }


        } else {
            self.commentLabel.text = "0"
            //self.commentStackView.heightAnchor.constraint(equalToConstant: 150).isActive = false
            // 元にあるstackViewを削除
            self.commentStackView.subviews.forEach { (view) in
                view.removeFromSuperview()
            }
            print("==============test:")
            
        }
        
    }
    
    
    
    // コメントデータを取得(ここにデータを取得しないよう)
    func getCommentData(_ postData: PostData, _ count: Int) {
        
        let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id).collection("commentsReceived").document(String(count))
        
        postRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                
                let getCommentor = document.data()?["commentor"] as! String
                //print("getCommentor: \(getCommentor)")
                
                let getComment = document.data()?["comment"] as! String
                //print("getComment: \(getComment)")
                
                // add view in stack view
                let commentorLabel = UILabel()
                //commentorLabel.backgroundColor = UIColor.customRed
                commentorLabel.text = getCommentor
                commentorLabel.textAlignment = .center
                commentorLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true

                let commentLabel = UILabel()
                //commentLabel.backgroundColor = UIColor.customSeaGreen
                commentLabel.text = getComment

                // 一つのコメントを格納するstackView
                let stackView = UIStackView()
//                stackView.translatesAutoresizingMaskIntoConstraints = false
                stackView.axis  = NSLayoutConstraint.Axis.horizontal
                stackView.distribution  = UIStackView.Distribution.fillProportionally
                stackView.alignment = UIStackView.Alignment.top
                stackView.spacing = 20.0
                //stackView.backgroundColor = UIColor.customDarkCyan
                stackView.widthAnchor.constraint(equalToConstant: self.commentStackView.frame.width).isActive = true
                stackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
                stackView.addArrangedSubview(commentorLabel)
                stackView.addArrangedSubview(commentLabel)
                stackView.translatesAutoresizingMaskIntoConstraints = false
                
                
                self.commentStackView.addArrangedSubview(stackView)
                //self.commentStackView.addSubview(stackView)
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
}
