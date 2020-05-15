//
//  HomeViewController.swift
//  Instagram
//
//  Created by 井上真悠子 on 2020/05/12.
//  Copyright © 2020 taro.kirameki. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    
    var listener: ListenerRegistration!
    var postArray: [PostData] = []
    
    var i:Int = 0
    var flag:Int = 0//コメントの用のセルか、投稿用のセルか
    var count:Int=0//コメント数
    var datapath:Int = 0//投稿のデータのインデックスを保存する
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView,numberOfRowsInSection section:Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])

        // セル内のボタンのアクションをソースコードで設定する
        cell.likeButton.addTarget(self, action:#selector(handleButton(_:forEvent:)), for: .touchUpInside)
        cell.commentButton.addTarget(self, action: #selector(handleComment(_:forEvent:)), for: .touchUpInside)
        
        print(cell.captionLabel.text!)
        
        return cell
    }
    
    @objc func handleButton(_ sender: UIButton,forEvent event: UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました。")
        
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let postData = postArray[indexPath!.row]
        
        if let myid = Auth.auth().currentUser?.uid {
            var updateValue:FieldValue
            if postData.isLiked {
                updateValue = FieldValue.arrayRemove([myid])
            } else {
                updateValue = FieldValue.arrayUnion([myid])
            }
            
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["likes":updateValue])
        }
    }
    
    
    @objc func handleComment(_ sender: UIButton,forEvent event: UIEvent){//commentボタンがタップされたら
        print("DEBUG_PRINT: commentボタンがタップされました。")
        
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let postData = postArray[indexPath!.row]
        
        
        let CommentViewController = self.storyboard?.instantiateViewController(identifier: "comment") as! CommentViewController//CommentViewControllerを呼び出す
        CommentViewController.post = postData
        
        self.present(CommentViewController, animated: true, completion: nil)//CommentViewControllerに遷移する
        
    }
   
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillApper")
        
        if Auth.auth().currentUser != nil {
            
            if listener == nil {
                let postRef = Firestore.firestore().collection(Const.PostPath).order(by:"date",descending: true)
                
                listener = postRef.addSnapshotListener() {(QuerySnapshot,error) in
                    if let error = error {
                        print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                        return
                    }
                    
                    self.postArray = QuerySnapshot!.documents.map{document in
                        print("DEBUG_PRINT: documet取得 \(document.documentID)")
                        let postData = PostData(document:document)
                        return postData
                    
                    }
                    self.tableView.reloadData()
                }
            }
            
        } else {
            if listener != nil {
                listener.remove()
                listener = nil
                postArray = []
                tableView.reloadData()
            }
        }
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
