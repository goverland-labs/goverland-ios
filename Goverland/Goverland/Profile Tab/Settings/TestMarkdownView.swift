//
//  TestMarkdownView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 16.08.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import MarkdownUI

struct TestMarkdownView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack() {
                ScrollView {
                    Markdown(markdown)
                        .markdownTheme(.goverland)
                }
                .scrollIndicators(.hidden)

                SecondaryButton("Close") {
                    dismiss()
                }
                .padding(.top, 8)
                .padding(.bottom, 16)
            }
            .padding(.horizontal, Constants.horizontalPadding)
            .navigationTitle("Test Markdown")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension TestMarkdownView {
    var markdown: String {
"""

# Heading Level 1

text 1

## Heading Level 2

text 2

### Heading Level 3

text 3

#### Heading Level 4

text 4

##### Heading Level 5

text 5

###### Heading Level 6

---

**Bold Text**

*Italic Text*

***Bold and Italic Text***

~~Strikethrough Text~~

---

> Blockquote example. This is a blockquote.


> Blockquote example. This is a blockquote with a bit longer description. Testing it out. Blockquote example. This is a blockquote with a bit longer description. Testing it out. Blockquote example. This is a blockquote with a bit longer description. Testing it out. Blockquote example. This is a blockquote with a bit longer description. Testing it out. Blockquote example. This is a blockquote with a bit longer description. Testing it out. Blockquote example.

---

1. Ordered List Item 1
2. Ordered List Item 2
    - Nested Unordered List Item 1
    - Nested Unordered List Item 2

- Unordered List Item 1
- Unordered List Item 2
  1. Nested Ordered List Item 1
  2. Nested Ordered List Item 2

---

`Inline code example`

```python
# Code Block Example
def hello_world():
    print("Hello, World!")
```

```javascript
// Another Code Block Example
console.log("Hello, World!"); console.log("Hello, World!"); console.log("Hello, World!");

console.log("Hello, World!"); console.log("Hello, World!");

console.log("Hello, World!");

console.log("Hello, World!");
console.log("Hello, World!");

console.log("Hello, World!");
console.log("Hello, World!");

console.log("Hello, World!");
console.log("Hello, World!");
console.log("Hello, World!");

console.log("Hello, World!");
console.log("Hello, World!");
console.log("Hello, World!");
console.log("Hello, World!");
console.log("Hello, World!");

```

---

[Link to OpenAI](https://www.openai.com)

![Alt Text for Image](https://via.placeholder.com/150)

---

| Header 1 | Header 2 | Header 3 |
| -------- | -------- | -------- |
| Row 1    | Data 1   | Data 2   |
| Row 2    | Data 3   | Data 4   |

---

**Horizontal Rule Below**

---

*Here is an example of footnote*[^1].

[^1]: This is the footnote.

---

**Task List Example:**

- [x] Task 1
- [ ] Task 2
- [ ] Task 3

"""
    }
}
