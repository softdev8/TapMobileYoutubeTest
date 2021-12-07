//
//  ViewController.swift
//  Tap Mobile Youtube
//
//  Created by BigWin on 12/7/21.
//

import UIKit
import MBProgressHUD
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var videoRenderers: [VideoRenderer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func searchVideo(search: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let url = "https://www.youtube.com/results"
        let params = [
            "search_query": search
        ]
        AF.request(url, method: .get, parameters: params).responseString { response in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            switch response.result {
            case .success(let html):
                let left = ">var ytInitialData ="
                let right = ";<"
                if let match = html.range(of: "(?<=\(left))[^\(right)]+", options: .regularExpression) {
                    let jsonString = html[match]
                    let data = Data(jsonString.utf8)
                    
                    do {
                        let initialData = try JSONDecoder().decode(InitialData.self, from: data)
                        self.videoRenderers = []
                        initialData.contents.twoColumnSearchResultsRenderer.primaryContents.sectionListRenderer.contents.forEach { content in
                            if let itemSectionRenderer = content.itemSectionRenderer {
                                itemSectionRenderer.contents.forEach { renderer in
                                    if let videoRenderer = renderer.videoRenderer {
                                        self.videoRenderers.append(videoRenderer)
                                    }
                                }
                            }
                        }
                        
                        self.tableView.reloadData()
                    } catch let error {
                        self.showError(error: error)
                    }
                }
                break
            case .failure(let error):
                self.showError(error: error)
                break
            }
        }
    }
    
    private func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            self.searchVideo(search: text)
            textField.resignFirstResponder()
        }
        return true
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoRenderers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoCell
        
        let videoRenderer = self.videoRenderers[indexPath.row]
        cell.videoRenderer = videoRenderer
        
        return cell
    }
}
