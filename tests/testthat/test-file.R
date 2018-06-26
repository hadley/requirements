context("test-file.R")

# .R ----------------------------------------------------------------------

test_that("can extract requirements from .R file", {
  expect_equal(req_file(test_path("file-ok.R")), c("x", "y", "z"))
})

test_that("unparseable file requires nothing ", {
  expect_equal(req_file(test_path("file-broken.R")), character())
})

test_that("fails if path does not exist", {
  expect_error(req_file("DNE.r"), "does not exist")
})

# .Rmd --------------------------------------------------------------------

test_that("inspects output_format", {
  skip_if_not_installed("rmarkdown")

  expect_equal(
    req_file(test_path("file-format.Rmd")),
    c("rmarkdown", "tools")
  )

})

test_that("unparsed chunks are ignored", {
  expect_equal(
    req_file(test_path("file-partially-broken.Rmd")),
    c("rmarkdown", "x")
  )
})

# .Rnw --------------------------------------------------------------------

test_that("basic Rnw extraction works", {
  expect_equal(
    req_file(test_path("file-ok.Rnw")),
    "x"
  )
})
