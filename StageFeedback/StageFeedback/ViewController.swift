
import UIKit
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate{
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var uploadLabel: UILabel!
    @IBOutlet weak var uploadImage: UIImageView!
    var uploadImageURL: NSURL?

    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }

    @IBAction func uploadButtonPressed(sender: AnyObject) {
        if (uploadImageURL != nil) {
            makePostCall((uploadImageURL?.absoluteString)!)
        }
        else {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .PhotoLibrary
            
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            uploadImage.contentMode = .ScaleAspectFit
            uploadImage.image = pickedImage
        }
        
        if let imageURL = info[UIImagePickerControllerReferenceURL] as? NSURL {
            uploadImageURL = imageURL
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func makeGetCall () {
        //"http://jsonplaceholder.typicode.com/todos/1"
        let todoEndpoint: String = "http://localhost:3000/listBuckets"
        let url = NSURL(string: todoEndpoint)
        let urlRequest = NSURLRequest(URL: url!)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            
            if data == nil {
                print("Empty data")
                return
            }
            else {
                do {
                    let myData = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String: AnyObject]
                    print(myData)
                } catch {
                
                }
            }
        }
        
        task.resume()
    }
    
    func makePostCall (uploadImageURLStrig: NSString) {
        uploadImageURL = nil
        uploadImage = nil
        
        let filePath = fileInDocumentsDirectory(uploadImageURLStrig as String)
        print(filePath)
        
        //"http://jsonplaceholder.typicode.com/todos/1"
        let todoEndpoint: String = "http://localhost:3000/upload/"
        let url = NSURL(string: todoEndpoint)
        let urlRequest = NSMutableURLRequest(URL: url!)
        urlRequest.HTTPMethod = "POST"
        
        let bodyData = "title=Abhinav1&path=\(filePath)"
        urlRequest.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            
            if data == nil {
                print("Empty data")
                return
            }
            else {
                do {
                    let myData = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String: AnyObject]
                    print(myData)
                } catch {
                    
                }
            }
        }
        
        task.resume()
    }
    
    
    func getDocumentsURL() -> NSURL {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentsURL
    }
    
    func fileInDocumentsDirectory(filename: String) -> String {
        
        let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
        return fileURL.path!
        
    }
}

