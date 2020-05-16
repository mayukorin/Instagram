//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 井上真悠子 on 2020/05/13.
//  Copyright © 2020 taro.kirameki. All rights reserved.
//

import UIKit
import FirebaseUI

class PostTableViewCell: UITableViewCell {

    
    
    
    @IBOutlet weak var comments: UILabel!//コメントを表示する
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPostData(_ postData:PostData) {
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        postImageView.sd_setImage(with: imageRef)
        
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        
        
        self.dateLabel.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from:date)
            self.dateLabel.text = dateString
        }
        
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        if postData.isLiked {
            let buttonImage = UIImage(named:"like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named:"like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
        
        if postData.comments.count > 0 {
            self.comments.text! = ""//まずtextをリセットする
            comments.sizeToFit();
            for comment in postData.comments {
                self.comments.text! += comment + "\n"
            }
        }
        

    }
    
}
