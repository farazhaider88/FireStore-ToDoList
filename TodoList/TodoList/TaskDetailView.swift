//
//  TaskDetailView.swift
//  TodoList
//
//  Created by Faraz Haider on 13/02/2021.
//

import SwiftUI
import FirebaseFirestore

struct TaskDetailView: View {
    
    let task : Task
    @State private var title :String = ""
    private let db = Firestore.firestore()

    private func updateTask(){
        db.collection("task").document(task.id!).updateData(["title":title]){ error in
            
            if let err = error{
                print(err.localizedDescription)
            }else{
                print("Update Successful")
            }
            
        }
    }
    
    var body: some View {
        VStack{
            TextField(task.title, text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Update") {
                updateTask()
            }
        }
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(task: Task(title: "How The Lawn", id: "333"))
    }
}
