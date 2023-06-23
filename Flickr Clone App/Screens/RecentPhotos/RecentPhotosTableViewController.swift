//
//  ViewController.swift
//  Flickr Clone App
//
//  Created by yasin on 17.06.2023.
//

import UIKit

class RecentPhotosTableViewController: UITableViewController, UISearchResultsUpdating {
    
    private var response: Photo? {
        didSet {
            
            DispatchQueue.main.async {
                self.tableView.reloadData()

            }
            
            //PhotoResponse datası çekildiğinde, datayı yenile.
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.count > 2 {
            aramaFoto(with: text)        }
    }
    private func setupSearchController(){
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Hangi konuda fotoğraf görmek istiyorsun?"
        navigationItem.searchController = search
        
    }
    private func fotoCekmeData() { //flickr resimlerinin datalarının api'den çekimi
        guard let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=d8b37002d7ef1f3b81cdd27524ff0845&format=json&nojsoncallback=1&extras=escription,license,date_upload,date_taken,owner_name,icon_server,original_format,last_update,geo,tags,machine_tags,o_dims,views,media,path_alias,url_sq,url_t,url_s,url_q,url_m,url_n,url_z,url_c,url_l,url_o") else { return}
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Sunucudan veri çekilemedi.")
                return
            }
            if let data = data, let response = try? JSONDecoder().decode(Photo.self, from: data){
                self.response = response
                print(data)
            }
        }.resume()
    }
    
    private func aramaFoto(with  text: String) { // search bar'ın fonksiyonu
        guard let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=d8b37002d7ef1f3b81cdd27524ff0845&text=flower&format=json&nojsoncallback=1&extras=escription,license,date_upload,date_taken,owner_name,icon_server,original_format,last_update,geo,tags,machine_tags,o_dims,views,media,path_alias,url_sq,url_t,url_s,url_q,url_m,url_n,url_z,url_c,url_l,url_o") else { return}
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Sunucudan veri çekilemedi.")
                return
            }
            if let data = data, let response = try? JSONDecoder().decode(Photo.self, from: data){
                self.response = response
            }
        }.resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        fotoCekmeData()
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: "CustomCell")
    }
    override func numberOfSections(in tableView: UITableView) -> Int { // tableview içinde kaç farklı alan olacak ?
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //tableView içinde toplam kaç hücre olacak ?
        return 5
    }
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? PhotoTableViewCell else {
                    // Hücre oluşturulamadıysa, yeni bir hücre oluşturun veya bir hata mesajı gösterin.
                    return UITableViewCell()
                }
            cell.ppImageView.backgroundColor = .darkGray
            cell.usernameLabel.text = "Username"
            cell.photoImageView.backgroundColor = .gray
            cell.titleLabel.text = "Title Name"
            return cell
        }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "detailSegue", sender: nil) // seçim durumda gideceği ekran atmaası
        }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.destination is PhotoDetailViewController{
                //TODO: Seçimden fotoğrafı detay ekranına gönder.
            }
        }
        
        
    }
    

