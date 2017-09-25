parent <- setRefClass("parent",
                      fields = list(
                        test = function() 2
                      ))
child <- setRefClass("child",
                     contains = "parent",
                     fields = list(
                       test = function() .self$export("parent")$test  + 1
                     ))
child2 <- setRefClass("child2",
                     contains = "parent",
                     fields = list(
                       test = function() .self$callSuper() + 1
                     ))

tmp <- new("child")
tmp$test
tmp2 <- new("child2")
tmp2$test
