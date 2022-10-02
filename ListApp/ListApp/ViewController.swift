//
//  ViewController.swift
//  ListApp
//
//  Created by Emre Terzi on 25.09.2022.
//

import UIKit
import CoreData  //core data yı  import ettik

class ViewController: UIViewController {
    
    var data=[NSManagedObject]() //Stirngin veritabındaki karşılığını tutucak
    
    @IBOutlet weak var tableview: UITableView!
    
    
    @IBAction func barButton(_ sender:UIBarButtonItem) {
        
        maainAlert()
        
    }
    @IBAction func RemovebarButton(_ sender: Any) {
        
        
        let alertRemoveBar=UIAlertController(title: "Uyarı", message: "Bütün elemanları silmek istiyor musunuz?", preferredStyle: .alert)
        
        
        
        
        let alertRemovebarCancelButton1=UIAlertAction(title: "Vazgeç", style: .default,handler: nil)
            
        
        
        let alertRemovebarCancelButton2=UIAlertAction(title: "Tamam", style: .cancel){ _ in
            
            
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            
            let managedObject = appDelegate?.persistentContainer.viewContext
            
            for item in self.data {
                managedObject?.delete(item)
            }
            
            try? managedObject?.save()
            
            self.fetch()
            
            
        }
        
        
        
        self.present(alertRemoveBar,animated: true)
       
        alertRemoveBar.addAction(alertRemovebarCancelButton1)
        alertRemoveBar.addAction(alertRemovebarCancelButton2)
        
        
    }
    

    func maainAlert(){
        
        let alert=UIAlertController(
            title: "Yeni Eleman Ekle",
            message: nil,
            preferredStyle: .alert)//alertimizi allertcontrollerdan tanımladık
        
        //daha sonra allertimizin içinde aksiyon alıcak butonomuzu tanımladık
        let defaultButton=UIAlertAction(title:"Ekle", style: .default) {  _ in
            
            let text1=alert.textFields?.first?.text
            
            if text1 != "" {
                //veri tabanına erişim yapmamız gerekiyor
                
                let appDelegate=UIApplication.shared.delegate as? AppDelegate // önce uygulamanın geneline erişim
                let manegedObject=appDelegate?.persistentContainer.viewContext  // sonra veritabanın tam kendisinine erişim
                let entity=NSEntityDescription.entity(forEntityName: "Listitem", in: manegedObject!)
                
                
                let listitem=NSManagedObject(entity:entity!, insertInto: manegedObject)//itemlerimizin nasıl olucağını
                
                listitem.setValue(text1, forKey: "title") //text 1 i atama işlemi
                
                
                    
                     try? manegedObject?.save()  //try catch yapısı gerekli
                
                //Eğer textin içi doluysa
                //textfield içinde yazan elemanı dataya ekle
                
                self.fetch()//fetch metottunu çağırdık
                
                
                //elemanı arraye eklicek ve table viewi reloaa edicek
                //self.  hangi elemana ait olduğnu gösteriyoruz
                
            }
            else{
                
                self.presentWarningAlert()
            
            }
            
        //elemanı arraye eklicek ve table viewi reloaa edicek
        //self.  hangi elemana ait olduğnu gösteriyoruz
            
        }
        
        let cancelButton=UIAlertAction(title:"Vazgeç", style: .default,handler: nil)//vazgeç butonumuzu tanımladık
        
        alert.addTextField() //texfieldimiiı alertimize ekledik alertimize
        alert.addAction(defaultButton)//default buttonumuzu  alertimize ekledik
        alert.addAction(cancelButton)  //cacel butonumuzu alertimize ekledik
        present(alert, animated: true)
        
    }
    func presentWarningAlert(){
        let alert2=UIAlertController(title: "Uyarı", message: "Boş eleman ekleyemezsiniz", preferredStyle:.alert)
        
        let cancelButton2=UIAlertAction(title: "Tamam", style: .cancel)
        self.present(alert2,animated: true)
        alert2.addAction(cancelButton2)
    }
    
    func fetch(){
        
        
        let appDelegate=UIApplication.shared.delegate as? AppDelegate // önce uygulamanın geneline erişim
        let manegedObject=appDelegate?.persistentContainer.viewContext //veritbanına erişim
        
        let fetchrequest=NSFetchRequest<NSManagedObject>(entityName: "Listitem") //genric yapıda veriyi geri çekme işlemi
        
        data = try! manegedObject!.fetch(fetchrequest)
        
        tableview.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate=self
        tableview.dataSource=self
         fetch()
        
    }
    
        
    }


    
    
    
    
    

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count  //sıra sayımızı girdiğimiz data kadar olucağını tanımladık
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "defaultCell", for:indexPath)
        
        let listitem=data[indexPath.row]
        
        cell.textLabel?.text=listitem.value(forKey: "title") as? String  //title ögesine ekleme işlemi
        
        return cell //cell sayısını elemanımızın arrayındeki eleman kadar olmasını tanımladık
        
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction=UIContextualAction(style:.normal ,title: "Sil"){ _,_,_ in
            
            
            //self.data.remove(at: indexPath.row)
            
            let appDelegate=UIApplication.shared.delegate as? AppDelegate // önce uygulamanın geneline erişim
            let manegedObject=appDelegate?.persistentContainer.viewContext //veritbanına erişim
            
            manegedObject?.delete(self.data[indexPath.row])
             try?manegedObject?.save()
            self.fetch()  //yazılan verileri geri çekme
            
        
            
            
        }
        
        deleteAction.backgroundColor = .systemRed
        
        
        let editAction=UIContextualAction(style: .normal, title: "Düzenle"){_,_,_ in
            
            
            
            let alert=UIAlertController(
                title: "Elemanı Düzenle",
                message: nil,
                preferredStyle: .alert)
            
            let defaultButton=UIAlertAction(title:"Düzenle", style: .default) { _ in
                
                let text1=alert.textFields?.first?.text
                
                if text1 != "" {
                    
                    
                    let appDelegate=UIApplication.shared.delegate as? AppDelegate // önce  uygulamanın geneline erişim
                    let manegedObject=appDelegate?.persistentContainer.viewContext //veritbanına erişim
                    self.data[indexPath.row].setValue(text1, forKey: "title")
                    
                    
                    if manegedObject!.hasChanges{
                        
                        try?manegedObject?.save()
                    }
                    
                    self.tableview.reloadData()
                    
            
                }
                else{
                    
                    self.presentWarningAlert()
                
                }
    
                
            }
            
            let cancelButton=UIAlertAction(title:"Vazgeç", style: .default,handler: nil)//vazgeç butonumuzu tanımladık
            
           alert.addTextField() //texfieldimiiı alertimize ekledik alertimize
            alert.addAction(defaultButton)//default buttonumuzu  alertimize ekledik
            alert.addAction(cancelButton)  //cacel butonumuzu alertimize ekledik
            self.present(alert, animated: true)
            
        }
        editAction.backgroundColor = .systemBlue
        
        
        
        let config=UISwipeActionsConfiguration(actions: [deleteAction,editAction])
        
        return config
       
    
    }
    
            
}


        
    
    
