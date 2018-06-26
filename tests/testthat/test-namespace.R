context("test-namespace")

test_that("can extract from simple namespace file", {
  expect_equal(
    req_namespace(test_path("namespace-simple")),
    c("x", "y")
  )
})
