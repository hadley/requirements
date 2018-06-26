context("test-dir")

test_that("finds requirements from files", {
  expect_equal(
    req_dir(test_path("dir-simple")),
    c("dplyr", "ggplot2", "rmarkdown")
  )
})
