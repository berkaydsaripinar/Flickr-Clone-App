//
//  PhotoDetailViewController.swift
//  Flickr Clone App
//
//  Created by BDS on 18.06.2023.
//

import UIKit

class PhotoDetailViewController: UIViewController  {
    var photo: Photo?
    var selectedPhoto: Photo?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var userPhoto: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var aciklamaLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchImage(with: photo?.urlZ) { data in
            
            self.imageView.image = UIImage(data: data)
            
        }
        if let iconserver = photo?.iconserver,
           let iconfarm = photo?.iconfarm,
           let nsid = photo?.owner,
           NSString(string: iconserver).intValue > 0{
            
            
            fetchImage(with: "https://farm\(iconfarm).staticflickr.com/\(iconserver)/buddyicons/\(nsid).jpg") { data in
                self.userPhoto.image = UIImage(data: data)
            }
            
        }else {
            fetchImage(with: "https://www.flickr.com/images/buddyicon.gif") { data in
                self.userPhoto.image = UIImage(data: data)
            }
        }
        
        usernameLabel.text = photo?.ownername
        title = photo?.title
        aciklamaLabel.text = photo?.photoDescription?.content
        
        
    }
    
    //MARK: FETCH IMAGE
    private func fetchImage(with url: String?, competion: @escaping(Data) -> Void){
        if let urlString = url, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request){
                data, response, error in
                if let error = error {
                    print(error)
                    return
                }
                if let data = data {
                    DispatchQueue.main.async {
                        competion(data)
                        
                        
                    }
                }
            }.resume()
            
        }
    }
    
    
}
