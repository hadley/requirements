context("test-file.R")

test_that("can extract requirements from .R file", {
  expect_equal(req_file(test_path("file-ok.R")), c("x", "y", "z"))
})

test_that("unparseable file requires nothing ", {
  expect_equal(req_file(test_path("file-broken.R")), character())
})

test_that("fails if path does not exist", {
  expect_error(req_file("DNE.r"), "does not exist")
})
