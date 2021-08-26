# Weakifiable
A simple solution for tiring [weak self] in swift

## Usage
- give this repo a star
- Add EBWeakifiable to your Project.
- simply after each closure add weakify like sample below:
```
producer.register(handler: weakify { result, strongSelf in
            strongSelf.handle(result)
 })
```


