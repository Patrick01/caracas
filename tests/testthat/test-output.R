context("output")

test_that("as.character / tex", {
  skip_if_no_sympy()
  
  x <- symbol('x')
  z <- cos(x)^2 + sin(x)^2
  
  expect_equal(as.character(z), "sin(x)^2 + cos(x)^2")
  expect_equal(tex(z), "\\sin^{2}{\\left(x \\right)} + \\cos^{2}{\\left(x \\right)}")
})

test_that("print", {
  skip_if_no_sympy()
  
  x <- symbol('x')
  z <- cos(x)^2 + sin(x)^2
  
  expect_equal(paste0(capture.output(print(z)), collapse = ""), 
               "[caracas]:    2         2              sin (x) + cos (x)")
})

