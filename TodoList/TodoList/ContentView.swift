//
//  ContentView.swift
//  TodoList
//
//  Created by Faraz Haider on 10/02/2021.
//

import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    @State private var title = ""
    @State private var tasks : [Task] = []
    private var db : Firestore
    
    init() {
        db = Firestore.firestore()
    }
    
    
    private func saveTask(task:Task){
        
        do {
            try db.collection("task").addDocument(data: task.asDictionary(), completion: { (error) in
                if let err = error{
                    print(err.localizedDescription)
                }else{
                    print("Document successfully saved")
                    fetchAllTasks()
                }
            })
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
    }
    
    private func fetchAllTasks(){
        db.collection("task").getDocuments { (snapshot, error) in
            if let err = error{
                print(err.localizedDescription)
            }else{
                if let snap = snapshot{
                    tasks  = snap.documents.compactMap{ doc in
                        var task = try? Task.init(from: doc.data())
                        if task != nil{
                            task!.id = doc.documentID
                        }
                        
                        return task
                    }
                }
            }
        }
    }
    
    
    private func deleteTask(at indexSet:IndexSet){
        
        indexSet.forEach{ index in
            let task = tasks[index]
            db.collection("task").document(task.id!).delete { (error) in
                if let err = error{
                    print(err.localizedDescription)
                }else{
                    fetchAllTasks()
                }
            }
            
            
        }
    }
    
    var body: some View {
        
        NavigationView{
            VStack {
                TextField("Enter Task", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Save") {
                    let task = Task(title: title)
                    saveTask(task: task)
                }
                
                Spacer()
                
                List{
                    ForEach(tasks, id: \.id) { task in
                        
                        NavigationLink(
                            destination: TaskDetailView(task: task)){
                                Text(task.title)
                            }
                    }.onDelete(perform: deleteTask)
                }.listStyle(PlainListStyle())
                
                
                .onAppear(perform: {
                    fetchAllTasks()
                })
            }.padding().navigationTitle("Tasks")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
