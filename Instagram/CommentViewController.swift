//
//  CommentViewController.swift
//  Instagram
//
//  Created by 井上真悠子 on 2020/05/14.
//  Copyright © 2020 taro.kirameki. All rights reserved.
//

import UIKit
import Firebase

class CommentViewController: UIViewController {
    
    var cellId:String!
    @IBOutlet weak var commenttext: UITextField!
    
    @IBAction func commentPush(_ sender: Any) {//投稿ボタンが押されたら
    }
    @IBAction func commentCancel(_ sender: Any) {//キャンセルボタンが押されたら
        self.dismiss(animated: true, completion: nil)//ひとつ前の画面に戻る
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let postRef = Firestore.firestore().collection(Const.PostPath).document(cellId)//受け取ったcellIdからデータの保存場所を取得
        

        // Do any additional setup after loading the view.
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
