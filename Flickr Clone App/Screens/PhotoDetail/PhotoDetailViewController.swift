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
    
        title = "Photo Detail"
        // imageView.backgroundColor = .gray
        //userPhoto.backgroundColor = .darkGray
        //usernameLabel.text = "Username"
        //aciklamaLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. "
        
        
        
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
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    /*
func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let selectedPhoto = sender as? Photo {
                if let destinationVC = segue.destination as? PhotoDetailViewController {
                  
                    destinationVC.selectedPhoto = selectedPhoto
                    
                    
                }
            }
        }
    }*/

}
