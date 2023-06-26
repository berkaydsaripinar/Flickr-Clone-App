//
//  ViewController.swift
//  Flickr Clone App
//
//  Created by BDS on 17.06.2023.
//

import UIKit

class RecentPhotosTableViewController: UITableViewController, UISearchResultsUpdating {
    private var selectedPhoto: Photo?
    private var response: PhotosResponse? {
        didSet {
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
            
            //PhotoResponse datası çekildiğinde, datayı yenile.
        }
    }
    
  
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        fotoCekmeData()
    }
    
    
    //MARK: REFLESH BUTTON
    @IBAction func refleshButton(_ sender: Any) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    
    //MARK: TABLEVİEW
    override func numberOfSections(in tableView: UITableView) -> Int { // tableview içinde kaç farklı alan olacak ?
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //tableView içinde toplam kaç hücre olacak ?
        return response?.photos?.photo?.count ?? .zero
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let photo = response?.photos?.photo?[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! PhotoTableViewCell
        
        fetchImage(with: photo?.urlN) { data in
            
            cell.photoImageView.image = UIImage(data: data)
        }
        
        if let iconserver = photo?.iconserver,
           let iconfarm = photo?.iconfarm,
           let nsid = photo?.owner,
           NSString(string: iconserver).intValue > 0{
            
            fetchImage(with: "https://farm\(iconfarm).staticflickr.com/\(iconserver)/buddyicons/\(nsid).jpg") { data in
                cell.ppImageView.image = UIImage(data: data)
            }
            
        }
        else {
            fetchImage(with: "https://www.flickr.com/images/buddyicon.gif") { data in
                cell.ppImageView.image = UIImage(data: data)
            }
        }
        
        cell.usernameLabel.text = photo?.ownername
        cell.titleLabel.text = photo?.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPhoto = response?.photos?.photo?[indexPath.row]
        performSegue(withIdentifier: "detailSegue", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let viewController = segue.destination as? PhotoDetailViewController {
            viewController.photo = selectedPhoto
        }
    }
    
   
    
    // MARK: GET RECENT DATA
    private func fotoCekmeData() { //flickr resimlerinin datalarının api'den çekimi
        guard let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=d8b37002d7ef1f3b81cdd27524ff0845&format=json&nojsoncallback=1&extras=description,license,date_upload,date_taken,owner_name,icon_server,original_format,last_update,geo,tags,machine_tags,o_dims,views,media,path_alias,url_sq,url_t,url_s,url_q,url_m,url_n,url_z,url_c,url_l,url_o") else { return}
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Sunucudan veri çekilemedi.")
                return
            }
            if let data = data, let response = try? JSONDecoder().decode(PhotosResponse.self, from: data){
                self.response = response
                print(data)
            }
        }.resume()
    }
   
    
    
    // MARK: FETCH IMAGE
    
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
    
    
    
    
    
    // MARK: SEARCH
    
    private func aramaFoto(with text: String) { // search bar'ın fonksiyonu
        guard let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=d8b37002d7ef1f3b81cdd27524ff0845&text=flower&format=json&nojsoncallback=1&extras=description,license,date_upload,date_taken,owner_name,icon_server,original_format,last_update,geo,tags,machine_tags,o_dims,views,media,path_alias,url_sq,url_t,url_s,url_q,url_m,url_n,url_z,url_c,url_l,url_o") else { return}
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Sunucudan veri çekilemedi.")
                return
            }
            if let data = data, let response = try? JSONDecoder().decode(PhotosResponse.self, from: data){
                self.response = response
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                }
            }
        }.resume()
    }
    
    
    
    private func setupSearchController(){
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Hangi konuda fotoğraf görmek istiyorsun?"
        navigationItem.searchController = search
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        guard var text = searchController.searchBar.text else { return }
        if text.count > 1 {
            aramaFoto(with: text)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        }
        else {
            fotoCekmeData()}
    }
    
    
    
}




