//
//  SnippetController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/13/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import Foundation

class SnippetController {
    
    func createSnippet(withBody body: String, author: User, story: Story, completion: @escaping(Snippet?) -> Void) {
        let snippet = Snippet(body: body, author: author, storyRef: story.uid)
        story.snippets.append(snippet)
        story.saveToFirestore { (success, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else if success {
                completion(snippet)
            }
        }
        completion(nil)
    }
    
    func modifySnippet(with snippet: Snippet) {
        let fc: FirebaseController = FirebaseController()
        fc.updateData(fromCollection: .storiescollectionPathKey, inDocument: snippet.storyRef, newData: [String.snippetReferenceKey: snippet.documentData])
    }
}
