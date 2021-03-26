import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 */
@objc(FileTransfer)
public class FileTransfer: CAPPlugin {
    
    @objc func download(_ call: CAPPluginCall) {
        let source: String = call.getString("source") ?? ""
        let target: String = call.getString("target") ?? ""

        if (!source.isEmpty && !target.isEmpty ) {
            let url = URL(string: source)

            DispatchQueue.global(qos: .utility).async {
                do {
                    try FileTransfer.loadFileAsync(url: url!, target: target) { (path, error) in
                        print("File downloaded to : \(path!)")
                        call.resolve();
                    }
                } catch {
                    call.reject("Download error. " + error.localizedDescription)
                }

                return
            }
        }
    }

    static func loadFileAsync(url: URL, target: String, completion: @escaping (String?, Error?) -> Void) throws {
        let destinationUrl = URL(string: target)!

        if FileManager().fileExists(atPath: destinationUrl.path) {
            print("File already exists [\(target)]")
            try? FileManager.default.removeItem(at: destinationUrl)
        }

        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: url)

        request.httpMethod = "GET"

        let task = session.dataTask(with: request, completionHandler: {
            data, response, error in

            if error == nil {
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        if let data = data {
                            if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic) {
                                completion(target, error)
                            } else {
                                completion(target, error)
                            }
                        } else {
                            completion(target, error)

                        }
                    }
                }
            } else {
                completion(target, error)
            }
        })
        task.resume()
    }
}