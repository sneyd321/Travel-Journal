//
//  DetailViewController.swift
//  plainoldnotes27
//
//  Created by Marc Bueno on 2017-11-30.
//  Copyright © 2017 Marc Bueno Inc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var count : Int = 0
    var selectedValue : Int = -1
    @IBOutlet weak var tableView: UITableView!
    
    var imageView: UIImageView!
    
    var images : [UIImage] = []
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell
        
        cell.testImage.image = images[indexPath.row]
        return cell
    }
    

    @IBOutlet weak var textView: UITextView!
    
    var text : String = ""
    var refToSourceVC : ViewController!
    
    @IBAction func useCamera(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title : "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
            else{
                print("Camera Failed")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action: UIAlertAction) in imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView = UIImageView()
        
        //createImageView(image: image)
        imageView.image = image
        images.append(imageView.image!)
        
        save()
        tableView.reloadData()
        picker.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    public func setText(t: String) {
        text = t
        if isViewLoaded {
            textView.text = t
        }
    }
    
    public func setSelectedValue(sv : Int){
        selectedValue = sv
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refToSourceVC.newRowText = textView.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        load()
        
        
        
        // Do any additional setup after loading the view.
        textView.text = text
        textView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func save(){
        var counter : Int = 0
        for index in 0...(images.count - 1){
            let image = images[index]
            let imageData : NSData = UIImagePNGRepresentation(image)! as NSData
            UserDefaults.standard.set(imageData, forKey: "image" + String(index))
            counter += 1
            
        }
        
        UserDefaults.standard.set(counter, forKey: "counter")
        
        
        
    }
    
    func load(){
        let x = UserDefaults.standard.integer(forKey: "counter")
        if x != 0{
            for index in 0...(x - 1) {
                
                let data = UserDefaults.standard.object(forKey:  "image" + String(index)) as! NSData
                
                images.append(UIImage(data: data as Data)!)
                
            }
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
