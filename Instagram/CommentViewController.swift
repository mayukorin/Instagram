//
//  CommentViewController.swift
//  Instagram
//
//  Created by 井上真悠子 on 2020/05/14.
//  Copyright © 2020 taro.kirameki. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class CommentViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var name:String!
    
    
    var post:PostData!
    @IBOutlet weak var commentView: UITableView!
    @IBOutlet weak var commenttext: UITextField!
    
    @IBAction func commentPush(_ sender: Any) {//投稿ボタンが押されたら
        if commenttext.text!.isEmpty {//コメント欄に何も書かれていなかったら
            print("DEBUG_PRINT: コメントを入力してください。")
            SVProgressHUD.showError(withStatus: "コメントを入力してください")
            return
            
        }
        let postRef = Firestore.firestore().collection(Const.PostPath).document(post.id)//受け取ったpostからデータの保存場所を取得
        postRef.updateData(["comments":FieldValue.arrayUnion([name + ":" + self.commenttext.text!])])//コメント名を追加
        SVProgressHUD.showSuccess(withStatus: "コメントを投稿しました")
        self.dismiss(animated: true, completion: nil)//ホーム画面に戻る
        
               
    }
    @IBAction func commentCancel(_ sender: Any) {//キャンセルボタンが押されたら
        self.dismiss(animated: true, completion: nil)//ホーム  画面に戻る
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser
        name = user?.displayName
        commentView.delegate = self
        commentView.dataSource = self
        
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView:UITableView,numberOfRowsInSection section:Int) -> Int {
        
        return post.comments.count
    
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = commentView.dequeueReusableCell(withIdentifier: "Cell",for:indexPath)
        
        cell.textLabel?.text = post.comments[indexPath.row]
        
        return cell
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
