library(data.tree)

fib_tree <- function(n) {
  
  colors <- scales::brewer_pal(type = "qual", palette = 2)(n + 1)
  
  as_Fname <- function(val) glue::glue("F({val})")
  
  add_children <- function(node) {
    
    val <- node$int
    if (val >= 2) {
      vleft <- val - 1
      nleft <- node$AddChild(as_Fname(vleft), int = vleft)
      SetNodeStyle(nleft, fillcolor = colors[vleft + 1])
      add_children(nleft)
      
      vright <- val - 2
      nright <- node$AddChild(as_Fname(vright), int = vright)
      SetNodeStyle(nright, fillcolor = colors[vright + 1])
      add_children(nright)
    } 
    
    `if`(node$isRoot, node, NULL)
  }
  
  root <- Node$new(as_Fname(n), int = n)
  SetNodeStyle(root, style = "filled,rounded", shape = "box", 
               fillcolor = colors[n + 1], fontname = "helvetica")
  add_children(root)
}


plot(fib_tree(2))
plot(fib_tree(4))
plot(fib_tree(6))
plot(fib_tree(8))
